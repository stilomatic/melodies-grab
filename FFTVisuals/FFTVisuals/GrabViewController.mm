//
//  ViewController.m
//  FFTVisuals
//
//  Created by AntonioStilo on 27/08/16.
//  Copyright © 2016 AntonioStilo. All rights reserved.
//

#import "GrabViewController.h"
#import "ASAudioUnit.h"
#import "Spektrum.h"
#import "Graph.h"
#import "Converter.h"
#import <MIKMIDI/MIKMIDI.h>
#import "FileManager.h"

@interface GrabViewController ()<ASAudioUnitDelegate>

@property(nonatomic,strong) ASAudioUnit *au;
@property(nonatomic,strong) Spektrum *spk;
@property(nonatomic,strong) Graph *graph;

@property(nonatomic,strong) UILabel *frequencyLabel;
@property(nonatomic,strong) UILabel *noteLabel;
@property(nonatomic,strong) UIButton *filesButton;

@property(nonatomic,strong) NSDictionary *currentMetadata;
@property(nonatomic,strong) MIKMIDITrack *currentTrack;
@property(nonatomic) NSInteger noteCount;

@property(nonatomic) BOOL isWorking;

-(void)filesButtonHandler;

@end

@implementation GrabViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.isWorking = NO;
    self.au = [[ASAudioUnit alloc] initWithDelegate:self];
    
    self.spk = [[Spektrum alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.spk initSpektrum];
    [self.view addSubview:self.spk];
    
    self.graph = [Graph new];
    [self.view addSubview:self.graph];
    
    self.frequencyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 30, self.view.bounds.size.width, 80)];
    self.frequencyLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    self.frequencyLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    self.frequencyLabel.textAlignment = NSTextAlignmentCenter;
    self.frequencyLabel.numberOfLines = 3;
    [self.view addSubview:self.frequencyLabel];
    
    self.noteLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    self.noteLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:144.0];
    self.noteLabel.text = @"REC";
    self.noteLabel.textAlignment = NSTextAlignmentCenter;
    self.noteLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    [self.view addSubview:self.noteLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    self.filesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.filesButton.frame = CGRectMake(self.view.bounds.size.width - 54, 10, 44, 44);
    [self.filesButton setImage:[UIImage imageNamed:@"Arrow-DOWN"] forState:UIControlStateNormal];
    [self.filesButton addTarget:self action:@selector(filesButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.filesButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)tap:(UIGestureRecognizer*)gesture
{
    self.isWorking = !self.isWorking;
    if(self.isWorking){
        self.noteCount = 0;
        NSError *error = nil;
        MIKMIDISequence *sequence = [[MIKMIDISequence alloc] init];
        self.currentTrack = [[sequence addTrackWithError:&error] retain];
        
        NSLog(@"CREATE MIDI SEQ &error %@",error.description);
        
        self.currentMetadata = [[FileManager sharedInstance] prepareAudioFile];
        [self.au start:self.currentMetadata[kMetaDataAUDIOFile]];
        self.filesButton.hidden = YES;
    }else{
        [self.au stop];
         self.filesButton.hidden = NO;
        self.frequencyLabel.text = @"";
        self.noteLabel.text = @"REC";
        [self.spk initSpektrum];
        NSError *error = nil;
        [self.currentTrack.sequence writeToURL:[NSURL fileURLWithPath:self.currentMetadata[kMetaDataMIDIFile]] error:&error];
        if(error){
            NSLog(@"CANT SAVE MIDI FILE: %@",error.description);
        }
        [self.currentTrack release];
    }

    [self.graph initGraph];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getNote:(float)freq
{
    self.frequencyLabel.text = [NSString stringWithFormat:@"tap to stop\n%1.2fHz\n=",freq];
    UInt8 midiNote = [Converter midi:freq];
    NSLog(@"MIDI NOTE::: %ld",(long)midiNote);
    self.noteLabel.text = [Converter note:midiNote];
    [self.graph update:freq];
    MIKMIDINoteEvent *note = [MIKMIDINoteEvent noteEventWithTimeStamp:self.noteCount note:midiNote velocity:127 duration:0.7 channel:0];
    [self.currentTrack addEvent:note];
    self.noteCount++;
}

-(void)getSpektrum:(NSArray *)spekturm
{
   [self.spk updateSpektrum:spekturm];
}

-(void)filesButtonHandler
{
    [self performSegueWithIdentifier:@"filesSegueIn" sender:nil];
}


@end

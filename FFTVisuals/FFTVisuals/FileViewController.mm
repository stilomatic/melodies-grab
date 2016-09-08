//
//  FileViewController.m
//  FFTVisuals
//
//  Created by AntonioStilo on 28/08/16.
//  Copyright © 2016 AntonioStilo. All rights reserved.
//

#import "FileViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "FileManager.h"
#import "PlayerProgress.h"
#import "Global.h"

@interface FileViewController()<UITextFieldDelegate>

@property (nonatomic,strong) PlayerProgress *progresAudioView;
@property (nonatomic,strong) IBOutlet UIButton *audioPlayBtn;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL isPlayingAudio;
@property (nonatomic,strong) NSTimer *audioProgressTimer;

-(void)audioPlayHandler;
-(void)playAudioFile;
-(void)stopAudioFile;
-(void)updateAudioProgress:(NSTimer*)timer;

@end

@implementation FileViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.isPlayingAudio = NO;
    
    NSString *soundFilePath = self.metadata[kMetaDataAUDIOFile];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    self.audioPlayer.numberOfLoops = -1;
    
    self.titleText.placeholder = [self.metadata valueForKey:kMetaDataTitle];
    self.titleText.delegate = self;
    self.titleText.autocorrectionType = UITextAutocorrectionTypeNo;
    self.dateText.text = [self.metadata valueForKey:kMetaDataDate];
    
    self.progresAudioView = [[PlayerProgress alloc] initWithFrame:CGRectMake(((self.view.bounds.size.width * 0.5) - 260)/2, 80, 260, 260)];
    [self.progresAudioView setPercent:100];
    [self.view addSubview:self.progresAudioView];
    
    NSLog(@"META %@",self.metadata);
    NSLog(@"FILE EXIST: %@",[[NSFileManager defaultManager] fileExistsAtPath:[self.metadata valueForKey:kMetaDataAUDIOFile]]?@"YES":@"NO");
    
    [self.audioPlayBtn setTitle:@"" forState:UIControlStateNormal];
    [self.audioPlayBtn addTarget:self action:@selector(audioPlayHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.audioPlayBtn];
    [self.view bringSubviewToFront:self.audioPlayBtn];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(self.isPlayingAudio)[self stopAudioFile];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.metadata setValue:self.titleText.text forKey:kMetaDataTitle];
    BOOL isSaved = [self.metadata writeToFile:[self.metadata valueForKey:kMetaDataMETAFile] atomically:YES];
    NSLog(@"METADAT UPDATED: %@ \n %@",isSaved ? @"YES":@"NO",[self.metadata valueForKey:kMetaDataMETAFile]);
    [self.titleText resignFirstResponder];
    return YES;
}

-(void)audioPlayHandler{
    
     if (self.isPlayingAudio) {
         [self stopAudioFile];
         self.audioPlayBtn.selected = NO;
     } else {
         [self playAudioFile];
         self.audioPlayBtn.selected = YES;
     }
    self.isPlayingAudio = !self.isPlayingAudio;
}

-(void)playAudioFile
{
    [self.audioPlayer play];
    self.audioProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateAudioProgress:) userInfo:nil repeats:YES];
}
-(void)stopAudioFile
{
    
    [self.audioProgressTimer invalidate];
    self.audioProgressTimer = nil;
    [self.progresAudioView setPercent:100];
    [self.progresAudioView setNeedsDisplay];
    [self.audioPlayer stop];
}

-(void)updateAudioProgress:(NSTimer*)timer
{
    NSInteger percent = (NSInteger)(([self.audioPlayer currentTime] / [self.audioPlayer duration]) * 100.0);
    [self.progresAudioView setPercent:percent];
    [self.progresAudioView setNeedsDisplay];
}




@end

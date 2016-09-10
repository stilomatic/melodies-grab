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
#import "MIDIGraph.h"
#import <MIKMIDI.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface FileViewController()<UITextFieldDelegate,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) PlayerProgress *progresAudioView;
@property (nonatomic,strong) IBOutlet UIButton *audioPlayBtn;
@property (nonatomic,strong) IBOutlet UIButton *midiPlayBtn;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (nonatomic,strong) NSTimer *audioProgressTimer;
@property (nonatomic,strong) MIKMIDISequencer *sequencer;
@property (nonatomic,strong) MIDIGraph *graph;

@property (nonatomic) BOOL isPlayingAudio;
@property (nonatomic) BOOL isPlayingMIDI;

-(void)audioPlayHandler;
-(void)playAudioFile;
-(void)stopAudioFile;
-(void)updateAudioProgress:(NSTimer*)timer;

-(void)midiPlayHandler;
-(void)playMIDIFile;
-(void)stopMIDIFile;

-(void)shareBtnHandler;

@end

@implementation FileViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.isPlayingAudio = NO;
    self.isPlayingMIDI = NO;
    
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
    [self.view bringSubviewToFront:self.audioPlayBtn];

    [self.midiPlayBtn setTitle:@"PLAY MIDI" forState:UIControlStateNormal];
    [self.midiPlayBtn addTarget:self action:@selector(midiPlayHandler) forControlEvents:UIControlEventTouchUpInside];
    
    self.graph = [[MIDIGraph alloc] initWithFrame:CGRectMake((self.view.bounds.size.width * 0.5)+(((self.view.bounds.size.width * 0.5) - 260)/2), 80, 260, 260)];
    [self.view addSubview:self.graph];
    [self.view bringSubviewToFront:self.midiPlayBtn];
    
    NSURL *file = [NSURL fileURLWithPath:self.metadata[kMetaDataMIDIFile]];
    NSError *error = nil;
    MIKMIDISequence *sequence = [MIKMIDISequence sequenceWithFileAtURL:file error:&error];
    MIKMIDITrack *currentTrack = [sequence.tracks firstObject];
    [self.graph update:currentTrack.events];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height - 44, self.view.bounds.size.width * 05, 44);
    shareBtn.backgroundColor = UIRandomColor;
    [shareBtn setTitle:@"share" forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(self.isPlayingAudio)[self stopAudioFile];
    if(self.isPlayingMIDI)[self stopMIDIFile];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.metadata setValue:self.titleText.text forKey:kMetaDataTitle];
    BOOL isSaved = [self.metadata writeToFile:[self.metadata valueForKey:kMetaDataMETAFile] atomically:YES];
    NSLog(@"METADAT UPDATED: %@ \n %@",isSaved ? @"YES":@"NO",[self.metadata valueForKey:kMetaDataMETAFile]);
    [self.titleText resignFirstResponder];
    return YES;
}

-(void)audioPlayHandler
{
    
    if(self.isPlayingMIDI)
    {
        self.isPlayingMIDI = NO;
        [self stopMIDIFile];
    }
    
     if (self.isPlayingAudio) {
         [self stopAudioFile];
         self.audioPlayBtn.selected = NO;
     } else {
         [self playAudioFile];
         self.audioPlayBtn.selected = YES;
     }
    self.isPlayingAudio = !self.isPlayingAudio;
}

-(void)midiPlayHandler
{
    if(self.isPlayingAudio)
    {
        self.isPlayingAudio = NO;
        [self stopAudioFile];
    }
    
    if (self.isPlayingMIDI) {
        [self stopMIDIFile];
    } else {
        [self playMIDIFile];
    }
    self.isPlayingMIDI = !self.isPlayingMIDI;

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

-(void)playMIDIFile
{
    NSURL *file = [NSURL fileURLWithPath:self.metadata[kMetaDataMIDIFile]];
    NSError *error = nil;
    MIKMIDISequence *sequence = [MIKMIDISequence sequenceWithFileAtURL:file error:&error];
    self.sequencer = [MIKMIDISequencer sequencerWithSequence:sequence];
    [self.sequencer setLoopStartTimeStamp:0 endTimeStamp:sequence.tracks.firstObject.events.count];
    [self.sequencer startPlayback];
}

-(void)stopMIDIFile
{
    [self.sequencer stop];
    self.sequencer = nil;
}

-(void)shareBtnHandler
{
    NSData *wavData = [NSData dataWithContentsOfFile:self.metadata[kMetaDataAUDIOFile]];
    NSData *midiData = [NSData dataWithContentsOfFile:self.metadata[kMetaDataMIDIFile]];
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    [mailController setSubject:self.metadata[kMetaDataTitle]];
    [mailController setMessageBody:@"This file was generated using iPhone App melodies-grabber"
                             isHTML:NO];
    [mailController addAttachmentData:midiData mimeType:@"audio/midi" fileName:[NSString stringWithFormat:@"%@.mid",self.metadata[kMetaDataTitle]]];
    [mailController addAttachmentData:wavData mimeType:@"audio/wav" fileName:[NSString stringWithFormat:@"%@.wav",self.metadata[kMetaDataTitle]]];
    mailController.mailComposeDelegate = self;
    [self presentViewController:mailController animated:YES completion:NULL];

}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end

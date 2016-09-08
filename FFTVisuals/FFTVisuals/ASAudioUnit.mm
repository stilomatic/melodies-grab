//
//  AudioUnit.m
//  FFTVisuals
//
//  Created by AntonioStilo on 27/08/16.
//  Copyright © 2016 AntonioStilo. All rights reserved.
//

#import "ASAudioUnit.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Global.h"
#import "mo_audio.h" //stuff that helps set up low-level audio
#import "FFTHelper.h"
#import "FileManager.h"

UInt32 inNumberFrames = 0;

/// Nyquist Maximum Frequency
const Float32 NyquistMaxFreq = SAMPLE_RATE/2.0;

/// caculates HZ value for specified index from a FFT bins vector
Float32 frequencyHerzValue(long frequencyIndex, long fftVectorSize, Float32 nyquistFrequency ) {
    return ((Float32)frequencyIndex/(Float32)fftVectorSize) * nyquistFrequency;
}



// The Main FFT Helper
FFTHelperRef *fftConverter = NULL;
Float32 *fftData = NULL;

//Accumulator Buffer=====================

const UInt32 accumulatorDataLenght = DATA_LENGHT;  //16384; //32768; 65536; 131072;
UInt32 accumulatorFillIndex = 0;
Float32 *dataAccumulator = nil;
static void initializeAccumulator()
{
    dataAccumulator = (Float32*) malloc(sizeof(Float32)*accumulatorDataLenght);
    accumulatorFillIndex = 0;
}
static void destroyAccumulator() {
    if (dataAccumulator!=NULL) {
        free(dataAccumulator);
        dataAccumulator = NULL;
    }
    accumulatorFillIndex = 0;
    
    free(fftData);
}

static BOOL accumulateFrames(Float32 *frames, UInt32 lenght) { //returned YES if full, NO otherwise.
    //    float zero = 0.0;
    //    vDSP_vsmul(frames, 1, &zero, frames, 1, lenght);
    
    if (accumulatorFillIndex>=accumulatorDataLenght) { return YES; } else {
        memmove(dataAccumulator+accumulatorFillIndex, frames, sizeof(Float32)*lenght);
        accumulatorFillIndex = accumulatorFillIndex+lenght;
        if (accumulatorFillIndex>=accumulatorDataLenght) { return YES; }
    }
    return NO;
}

static void emptyAccumulator() {
    accumulatorFillIndex = 0;
    memset(dataAccumulator, 0, sizeof(Float32)*accumulatorDataLenght);
}
//=======================================


//==========================Window Buffer
const UInt32 windowLength = accumulatorDataLenght;
Float32 *windowBuffer= NULL;
//=======================================



/// max value from vector with value index (using Accelerate Framework)
static Float32 vectorMaxValueACC32_index(Float32 *vector, unsigned long size, long step, unsigned long *outIndex) {
    Float32 maxVal;
    vDSP_maxvi(vector, step, &maxVal, outIndex, size);
    return maxVal;
}


///returns HZ of the strongest frequency.
static Float32 strongestFrequencyHZ(Float32 *buffer, FFTHelperRef *fftHelper, UInt32 frameSize, Float32 *freqValue) {
    
    
    //the actual FFT happens here
    //****************************************************************************
    fftData = computeFFT(fftHelper, buffer, frameSize);
    //****************************************************************************
    
    
    fftData[0] = 0.0;
    unsigned long length = frameSize/2.0;
    Float32 max = 0;
    unsigned long maxIndex = 0;
    max = vectorMaxValueACC32_index(fftData, length, 1, &maxIndex);
    if (freqValue!=NULL) { *freqValue = max; }
    Float32 HZ = frequencyHerzValue(maxIndex, length, NyquistMaxFreq);
    return HZ;
}

__weak id<ASAudioUnitDelegate> mdelegate = nil;

#pragma mark MAIN CALLBACK
void AudioCallback( Float32 * buffer, UInt32 frameSize, void * userData )
{
    
    
    //take only data from 1 channel
    Float32 zero = 0.0;
    vDSP_vsadd(buffer, 2, &zero, buffer, 1, frameSize*NUMCHANNELS);
    
    
    
    if (accumulateFrames(buffer, frameSize)==YES) { //if full
        
        //windowing the time domain data before FFT (using Blackman Window)
        if (windowBuffer==NULL) { windowBuffer = (Float32*) malloc(sizeof(Float32)*windowLength); }
        vDSP_blkman_window(windowBuffer, windowLength, 0);
        vDSP_vmul(dataAccumulator, 1, windowBuffer, 1, dataAccumulator, 1, accumulatorDataLenght);
        //=========================================
        
        
        Float32 maxHZValue = 0;
        Float32 maxHZ = strongestFrequencyHZ(dataAccumulator, fftConverter, accumulatorDataLenght, &maxHZValue);
        
        NSMutableArray *fft = [NSMutableArray new];
        
        for (int i  = 0; i < FRAMESIZE; i++){
            [fft addObject:[NSNumber numberWithFloat:fftData[i] * SAMPLE_RATE * SAMPLE_SCALE]];
        }
        
        //NSLog(@" max HZ = %0.3f ", maxHZ);
        dispatch_async(dispatch_get_main_queue(), ^{ //update UI only on main thread
                [mdelegate getNote:maxHZ];
                [mdelegate getSpektrum:fft];
        });
        
        emptyAccumulator(); //empty the accumulator when finished
    }
    memset(buffer, 0, sizeof(Float32)*frameSize*NUMCHANNELS);
}

@implementation ASAudioUnit

-(id)initWithDelegate:(id<ASAudioUnitDelegate>)delegate
{
    self = [super init];
    if(self){
        mdelegate = delegate;
        fftConverter = FFTHelperCreate(accumulatorDataLenght);
        initializeAccumulator();
        
    }
    
    return self;
}

-(void) initMomuAudio {
    bool result = false;
    result = MoAudio::init( SAMPLE_RATE, FRAMESIZE, NUMCHANNELS, false);
    if (!result) { NSLog(@" MoAudio init ERROR"); }
    result = MoAudio::start( AudioCallback, NULL );
    if (!result) { NSLog(@" MoAudio start ERROR"); }
}

-(void)start:(NSString*)filePath
{
    MoAudio::initRecording(filePath);
    [self initMomuAudio];
}

-(void)stop
{
    MoAudio::shutdown();
}

-(void) dealloc {
    destroyAccumulator();
    FFTHelperRelease(fftConverter);
}

@end

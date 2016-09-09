//
//  Global.h
//  FFTVisuals
//
//  Created by AntonioStilo on 27/08/16.
//  Copyright © 2016 AntonioStilo. All rights reserved.
//

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

#define UIRandomColor [UIColor colorWithRed:(float)(arc4random()%122 /255.0)+0.5 green:(float)(arc4random()%122 /255.0)+0.5 blue:(float)(arc4random()%122 /255.0)+0.5 alpha:1.0]
#define UIRandomColorLight [UIColor colorWithRed:(float)(arc4random()%122 /255.0)+0.5 green:(float)(arc4random()%122 /255.0)+0.5 blue:(float)(arc4random()%122 /255.0)+0.5 alpha:0.5]
#define SAMPLE_RATE 44100.0  //22050 //44100
#define FRAMESIZE  512

#define NUMCHANNELS 1
#define SAMPLE_SCALE 100000
#define kOutputBus 0
#define kInputBus 1
#define DATA_LENGHT 16384 //16384; //32768; 65536; 131072;
#define SCALE_VALUE(a,b) ( a / 12544 ) * b
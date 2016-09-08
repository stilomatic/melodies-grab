//
//  AudioUnit.h
//  FFTVisuals
//
//  Created by AntonioStilo on 27/08/16.
//  Copyright © 2016 AntonioStilo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ASAudioUnitDelegate <NSObject>

-(void)getNote:(float)freq;
-(void)getSpektrum:(NSArray *)spekturm;

@end

@interface ASAudioUnit : NSObject

-(id)initWithDelegate:(id<ASAudioUnitDelegate>)delegate;
-(void)stop;
-(void)start:(NSString*)filePath;

@end

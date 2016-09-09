//
//  MIDIGraph.m
//  FFTVisuals
//
//  Created by AntonioStilo on 09/09/16.
//  Copyright © 2016 AntonioStilo. All rights reserved.
//

#import "MIDIGraph.h"
#import <MIKMIDI.h>
#import "Global.h"

#define W 4

@interface MIDIGraph ()

@end

@implementation MIDIGraph


-(void)update:(NSArray*)events
{
    for(int i = 0 ; i < events.count; i++ ){
        
        MIKMIDINoteEvent *event = (MIKMIDINoteEvent*)events[i];
        float height = (event.frequency / 5000.0) * self.bounds.size.height;
        float width = (event.timeStamp * W) + event.duration;
        NSLog(@"MIDIEVENT %@",event);
        NSLog(@"MIDIEVENT %f - %f",width,height);
        CGRect dotFrame = CGRectMake(width, (self.bounds.size.height - height) * 0.5, width, height);
        UIView *tmpView = [[UIView alloc] initWithFrame:dotFrame];
        tmpView.backgroundColor = UIRandomColor;
        [self addSubview:tmpView];
    }
}

@end

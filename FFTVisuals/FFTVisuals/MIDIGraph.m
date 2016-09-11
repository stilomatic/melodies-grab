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


@interface MIDIGraph ()

@end

@implementation MIDIGraph

-(void)playView:(NSInteger)index
{
    self.subviews[index].backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.7];
    NSInteger oldIndex = index > 0 ? index - 1 : self.subviews.count - 1;
    self.subviews[oldIndex].backgroundColor = UIRandomColor;
}


-(void)update:(NSArray*)events
{
    float W = (self.bounds.size.width - 20) / events.count;
    
    for(int i = 0 ; i < events.count; i++ ){
        
        MIKMIDINoteEvent *event = (MIKMIDINoteEvent*)events[i];
        float height = (event.frequency / 1000.0) * self.bounds.size.height;
        float width = (i * W);
        CGRect dotFrame = CGRectMake(width, (self.bounds.size.height - height) * 0.5, W, height);
        UIView *tmpView = [[UIView alloc] initWithFrame:dotFrame];
        tmpView.backgroundColor = UIRandomColor;
        [self addSubview:tmpView];
    }
}

@end

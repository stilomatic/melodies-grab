//
//  Spektrum.m
//  FFTVisuals
//
//  Created by AntonioStilo on 27/08/16.
//  Copyright © 2016 AntonioStilo. All rights reserved.
//

#import "Spektrum.h"
#import "Global.h"

@interface Spektrum ()

@property (nonatomic,strong) NSArray *data;
@property (nonatomic) float w;

@end

@implementation Spektrum

-(void)initSpektrum
{
    for(UIView *v in self.subviews)
        [v removeFromSuperview];
    
    self.w = self.bounds.size.width / FRAMESIZE;
    
    for(int i = 0; i < FRAMESIZE; i++){
        UIView *tmp = [[UIView alloc] initWithFrame:CGRectMake(i * self.w, self.bounds.size.height - 20.0, self.w, 20.0)];
        tmp.backgroundColor = UIRandomColor;
        [self addSubview:tmp];
    }
}

-(void)updateSpektrum:(NSArray*)data
{
    self.data = data;
    
    for(int i = 0; i < FRAMESIZE; i++){
        UIView *tmp = self.subviews[i];
        float value = [self.data[i] floatValue] > 10.0 ? [self.data[i] floatValue] : 10.0;
        tmp.frame = CGRectMake(self.w * i, self.bounds.size.height - (SCALE_VALUE(value,self.bounds.size.height) * 0.05) - 20.0, self.w, self.bounds.size.height);
    }
    
}

@end

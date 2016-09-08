//
//  Graph.m
//  FFTVisuals
//
//  Created by AntonioStilo on 27/08/16.
//  Copyright © 2016 AntonioStilo. All rights reserved.
//

#import "Graph.h"
#import "Global.h"

#define W 6.0

@interface Graph ()

@property(nonatomic)NSInteger count;

@end

@implementation Graph

-(void)initGraph
{
    for(UIView *v in self.subviews)
        [v removeFromSuperview];
        
    self.count = 0;
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(self.superview.bounds.size.width, 0.0, 100000, self.superview.bounds.size.height);
}

-(void)update:(float)freq
{
    self.frame = CGRectMake(self.superview.bounds.size.width - (self.count * W), 0.0, 100000, self.superview.bounds.size.height);
    
    CGRect dotFrame = CGRectMake((self.count * W), self.superview.bounds.size.height - SCALE_VALUE(freq, self.bounds.size.height) - 20, W, W);
    UIView *tmpView = [[UIView alloc] initWithFrame:dotFrame];
    tmpView.backgroundColor = UIRandomColor;
    [self addSubview:tmpView];
    self.count++;
}


@end

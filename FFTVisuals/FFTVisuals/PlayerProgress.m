//
//  PlayerProgress.m
//  FFTVisuals
//
//  Created by AntonioStilo on 29/08/16.
//  Copyright © 2016 AntonioStilo. All rights reserved.
//

#import "PlayerProgress.h"
#import "Global.h"

@interface PlayerProgress () {
    CGFloat startAngle;
    CGFloat endAngle;
}

@end

@implementation PlayerProgress

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        // Determine our start and stop angles for the arc (in radians)
        startAngle = M_PI * 1.5;
        endAngle = startAngle + (M_PI * 2);
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Display our percentage as a string
    NSString* textContent = self.percent < 100 ? [NSString stringWithFormat:@"%ld", self.percent]:@"Play";
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    // Create our arc, with the correct angles
    [bezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:100
                      startAngle:startAngle
                        endAngle:(endAngle - startAngle) * (_percent / 100.0) + startAngle
                       clockwise:YES];
    
    // Set the display for the path, and stroke it
    bezierPath.lineWidth = 45;
    [UIRandomColor setStroke];
    [bezierPath stroke];
    
    // Text Drawing
    CGRect textRect = CGRectMake((rect.size.width / 2.0) - 71/2.0, (rect.size.height / 2.0) - 45/2.0, 71, 45);
    [[UIColor grayColor] setFill];
    [textContent drawInRect: textRect withFont: [UIFont fontWithName: @"HelveticaNeue-UltraLight" size: 42] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
}

@end


//
//  CKCustomSlideOutSegue.m
//  familynet
//
//  Created by AntonioStilo on 24/03/16.
//  Copyright © 2016 familynet. All rights reserved.
//

#import "CustomSlideOutSegue.h"

@implementation CustomSlideOutSegue

- (void)perform
{
    UIViewController *sourceController = (UIViewController*)self.sourceViewController;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    // Set transition animation type
    transition.type = kCATransitionPush;
    // Set transition animation subtype
    transition.subtype = kCATransitionFromBottom;
    
    // Change animation
    [sourceController.navigationController.view.layer addAnimation:transition forKey:@"mytransition"];
    
    // Transition
    [sourceController.navigationController popViewControllerAnimated:NO];
}

@end

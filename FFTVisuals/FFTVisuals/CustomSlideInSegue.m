//
//  CKCustomSegue.m
//  familynet
//
//  Created by Ralf Peters on 01/09/14.
//  Copyright (c) 2014 Codekanzlei. All rights reserved.
//

#import "CustomSlideInSegue.h"


@implementation CustomSlideInSegue


- (void)perform
{
    UIViewController *sourceController = (UIViewController*)self.sourceViewController;
    UIViewController *destinationController = (UIViewController*)self.destinationViewController;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    // Set transition animation type
    transition.type = kCATransitionPush;
    // Set transition animation subtype
    transition.subtype = kCATransitionFromTop;
    
    // Change animation
    [sourceController.navigationController.view.layer addAnimation:transition forKey:@"mytransition"];
    
    // Transition
    [sourceController.navigationController pushViewController:destinationController animated:NO];
}

@end

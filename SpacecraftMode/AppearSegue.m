//
//  AppearSegue.m
//  SpacecraftMode
//
//  Created by Daniel Munoz on 4/9/14.
//  Copyright (c) 2014 Greencraft. All rights reserved.
//

#import "AppearSegue.h"

@implementation AppearSegue
- (void) perform {
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    [dst.view setFrame:CGRectMake(0, 0, 768, 955)];
    [UIView transitionFromView:src.view toView:dst.view duration:1 options:UIViewAnimationOptionTransitionNone completion:nil];
}
@end

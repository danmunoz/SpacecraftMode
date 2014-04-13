//
//  WayDownViewController.h
//  SpacecraftMode
//
//  Created by Daniel Munoz on 4/13/14.
//  Copyright (c) 2014 Greencraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface WayDownViewController : UIViewController
@property (strong, nonatomic) CMMotionManager *motionManager;
@end

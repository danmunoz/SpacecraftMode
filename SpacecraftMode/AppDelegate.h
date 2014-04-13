//
//  AppDelegate.h
//  SpacecraftMode
//
//  Created by Daniel Munoz on 4/7/14.
//  Copyright (c) 2014 Greencraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PebbleKit/PebbleKit.h>
//#import "ModeSelectorViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, PBPebbleCentralDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property (strong, nonatomic) ModeSelectorViewController *initialVC;
@property (strong, nonatomic) PBWatch *connectedWatch;

@end

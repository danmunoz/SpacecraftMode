//
//  AppDelegate.m
//  SpacecraftMode
//
//  Created by Daniel Munoz on 4/7/14.
//  Copyright (c) 2014 Greencraft. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    self.initialVC = [[ModeSelectorViewController alloc] initWithNibName:@"ModeSelectorViewController" bundle:nil];
//    self.window.rootViewController = self.initialVC;
//    [self.window makeKeyAndVisible];
    return YES;
}

- (void)startPebbleCommunication{
    self.connectedWatch = [[PBPebbleCentral defaultCentral] lastConnectedWatch];
    [[PBPebbleCentral defaultCentral] setDelegate:self];
    NSLog(@"Last connected watch: %@", self.connectedWatch);
    NSLog(@"Pebble name: %@", self.connectedWatch.name);
    NSLog(@"Pebble serial number: %@", self.connectedWatch.serialNumber);
    [self setPebbleUDID];
    [self launchApp];
}

- (void)setPebbleUDID{
    uuid_t myAppUUIDbytes;
    NSUUID *myAppUUID = [[NSUUID alloc] initWithUUIDString:@"99cc44b0-d196-4d0d-9e63-fb899c842bd3"];
    [myAppUUID getUUIDBytes:myAppUUIDbytes];
    
    [[PBPebbleCentral defaultCentral] setAppUUID:[NSData dataWithBytes:myAppUUIDbytes length:16]];
}

- (void)launchApp{
    [self.connectedWatch appMessagesLaunch:^(PBWatch *watch, NSError *error) {
        if (!error) {
            NSLog(@"Successfully launched app.");
//            [self performSelector:@selector(sendTestMessage) withObject:nil afterDelay:3.0f];
        }
        else {
            NSLog(@"Error launching app - Error: %@", error);
        }
    }
     ];
}

- (void)sendTestMessage{
    NSDictionary *update = @{ @(0):[NSNumber numberWithUint8:42],
                              @(1):@"HOOOOOOLA" };
    [self.connectedWatch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        if (!error) {
            NSLog(@"Successfully sent message: %@", update);
        }
        else {
            NSLog(@"Error sending message: %@", error);
        }
    }];
}


- (void)pebbleCentral:(PBPebbleCentral *)central watchDidDisconnect:(PBWatch *)watch{
    NSLog(@"Disconnected");
    if (self.connectedWatch == watch || [watch isEqual:self.connectedWatch]) {
        self.connectedWatch = nil;
    }
}

- (void)pebbleCentral:(PBPebbleCentral *)central watchDidConnect:(PBWatch *)watch isNew:(BOOL)isNew{
     NSLog(@"Pebble connected: %@", [watch name]);
    self.connectedWatch = watch;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

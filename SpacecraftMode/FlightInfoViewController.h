//
//  FlightInfoViewController.h
//  SpacecraftMode
//
//  Created by Daniel Munoz on 4/11/14.
//  Copyright (c) 2014 Greencraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>

@interface FlightInfoViewController : UIViewController<CLLocationManagerDelegate>
@property (strong, nonatomic) CMMotionManager *motionManager;


@property (weak, nonatomic) IBOutlet UILabel *distanceToISS;
@property (weak, nonatomic) IBOutlet UILabel *accelX;
@property (weak, nonatomic) IBOutlet UILabel *accelY;
@property (weak, nonatomic) IBOutlet UILabel *accelZ;
@property (weak, nonatomic) IBOutlet UIView *dataIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *gyroX;
@property (weak, nonatomic) IBOutlet UILabel *gyroY;
@property (weak, nonatomic) IBOutlet UILabel *gyroZ;
@property (weak, nonatomic) IBOutlet UIImageView *arrowView;
@property (weak, nonatomic) IBOutlet UILabel *issVelocityLabel;
@property (weak, nonatomic) IBOutlet UILabel *issAltitudeLabel;

@property (weak, nonatomic) IBOutlet UILabel *gravityVector;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (nonatomic, assign) BOOL connected;

@end

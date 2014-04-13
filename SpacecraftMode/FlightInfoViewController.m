//
//  FlightInfoViewController.m
//  SpacecraftMode
//
//  Created by Daniel Munoz on 4/11/14.
//  Copyright (c) 2014 Greencraft. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kLatestKivaLoansURL [NSURL URLWithString:@"https://api.wheretheiss.at/v1/satellites/25544"] //2

#import "FlightInfoViewController.h"
#import "Reachability.h"

@interface FlightInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *altitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *issVisibilityLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *heartBeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *bloodPressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *glucoseLabel;

@end

@implementation FlightInfoViewController

//100 HZ (1/100, 100 times per second)
#define deltaTime 0.05;
{
    float issLatitude;
    float issLongitude;
    float issAltitude;
    float issVelocity;
    NSString *issVisibility;
    CLLocation *userLocation;
    CLLocationManager *locationManager;
    NSTimer *updateApiTimer;
    BOOL didReceiveUserLocation;
    NSString *erase;
    Reachability *internetReachableFoo;
}

CGFloat radiansToDegrees(CGFloat radians) {
    return radians * 180 / M_PI;
};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Objeto locationManager:
    locationManager = [[CLLocationManager alloc] init];
    
    //Objeto motionManager:
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = deltaTime;
    self.motionManager.deviceMotionUpdateInterval = deltaTime;
    self.motionManager.gyroUpdateInterval = deltaTime;
    self.motionManager.magnetometerUpdateInterval = deltaTime;
    
    //userLocation bool
    didReceiveUserLocation = NO;
    
    [self retrieveData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)retrieveData{
    
    //GPS:
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    //INERTIAL:
    
    //Start updating accelerometer data
    [self.motionManager startDeviceMotionUpdates];
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error){
                                                 [self outputAccelertionData:accelerometerData.acceleration];if(error){NSLog(@"%@", error);}}];
    
    //Start device motion data
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler:^(CMDeviceMotion *motion, NSError *error) {[self processMotion:motion];}];
    
    //Mag
    [self.motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler:^(CMMagnetometerData *magnetometerData, NSError *error) {[self outputMagnetometerData:magnetometerData.magneticField];
                                            }];
    
    //Start updating gyroscope data
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {[self outputRotationData:gyroData.rotationRate];}];
    
    //Start api updating method
    updateApiTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateApiData) userInfo:nil repeats:YES];
}

-(void)outputAccelertionData:(CMAcceleration)acceleration{
    float accelerationVector = sqrtf((acceleration.x*acceleration.x)+(acceleration.y*acceleration.y)+(acceleration.z*acceleration.z));
    
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / 1000.0;
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI*-1, acceleration.x*-5, acceleration.y*-5, acceleration.z);
    
    [UIView animateWithDuration:0.1 animations:^{
        self.arrowView.layer.anchorPoint = CGPointMake(0.5, 0);
        
        self.arrowView.layer.transform = rotationAndPerspectiveTransform;
    } completion:^(BOOL finished){
        // code to be executed when flip is completed
    }];
    
    //Create CLLocation ISS object
    CLLocation *ISS = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(issLatitude, issLongitude)altitude:issAltitude*1000 horizontalAccuracy:0 verticalAccuracy:0 timestamp:[NSDate date]];
    
    //Calculate distance from ISS to UserLocation
    CLLocationDistance distance = [ISS distanceFromLocation:userLocation];
    
    //ISS
    if (issVisibility == nil) {
        [self.issVisibilityLabel setText:@"Updating..."];
    }
    else{
        self.issVisibilityLabel.text = [NSString stringWithFormat:@"%@",issVisibility];
    }
    
    self.issVelocityLabel.text = [NSString stringWithFormat:@"%g km/h",issVelocity];
    self.issAltitudeLabel.text = [NSString stringWithFormat:@"%g km",issAltitude];
    self.distanceToISS.text = [NSString stringWithFormat:@"%g km (L), %g km(C)",((distance/1000)/(M_PI))*2,(distance/1000)];
    
    //ACCEL
    self.accelX.text = [NSString stringWithFormat:@"%.2f m/sˆ2",acceleration.x*9.81];
    self.accelY.text = [NSString stringWithFormat:@"%.2f m/sˆ2",acceleration.y*9.81];
    self.accelZ.text = [NSString stringWithFormat:@"%.2f m/sˆ2",acceleration.z*9.81];
    
    self.gravityVector.text = [NSString stringWithFormat:@"%.2f (%.2f m/sˆ2)",accelerationVector,accelerationVector*9.81];
    //Accelerometer Update Interval.
    
}

-(void)outputRotationData:(CMRotationRate)rotation{
    
    self.gyroX.text = [NSString stringWithFormat:@"%.2f rad/s",rotation.x];
    self.gyroY.text = [NSString stringWithFormat:@"%.2f rad/s",rotation.y];
    self.gyroZ.text = [NSString stringWithFormat:@"%.2f rad/s",rotation.z];
}

//Update location
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation

{
    
    CLLocation *currentLocation = newLocation;
    if (currentLocation != nil) {
        
        didReceiveUserLocation = YES;
        
        //Save user location
        userLocation = currentLocation;
        
        //Print gps data
        [self.locationLabel setText:[NSString stringWithFormat:@"%.3f, %.3f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude]];
//        self.longitudeLabel.text = [NSString stringWithFormat:@"%.3f", currentLocation.coordinate.longitude];
//        self.latitudeLabel.text = [NSString stringWithFormat:@"%.3f", currentLocation.coordinate.latitude];
        
        self.altitudeLabel.text = [NSString stringWithFormat:@"%.2f m / %.2f km",currentLocation.altitude,currentLocation.altitude/1000];
        self.timeLabel.text = [NSString stringWithFormat:@"%@",currentLocation.timestamp];
        if (currentLocation.speed <0) {
            self.speedLabel.text = @"0 m/s, 0 km/h";
        }
        else{
            self.speedLabel.text = [NSString stringWithFormat:@"%.2f m/s, %.2f km/h",currentLocation.speed,(currentLocation.speed / 1000)*3600];
        }
        self.courseLabel.text = [NSString stringWithFormat:@"%.2f˚ deg",currentLocation.course];
        
    }else{
        
        NSLog(@"NIL LOCATION DATA");
        
    }
}

//GPS:

//Handle gps error
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

//Check connection
- (void)testInternetConnection
{
    
    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    
    // Internet is reachable
    __weak FlightInfoViewController *blockSelf = self;
    
    
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            NSLog(@"Offline");
            blockSelf.connected = NO;
            
        });
    };
    
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            NSLog(@"Online");
            blockSelf.connected = YES;
            
        });
    };
    [internetReachableFoo startNotifier];
    
    
}

-(void)updateApiData{
    
    //Check connection
    [self testInternetConnection];
    
    if (!self.connected) {
        
        NSLog(@"No internet connection");
        
    }else{
        
        if (didReceiveUserLocation) {
            
            //Update API Data
            dispatch_async(kBgQueue, ^{
                NSData* data = [NSData dataWithContentsOfURL:kLatestKivaLoansURL];
                [self performSelectorOnMainThread:@selector(fetchedData:)withObject:data waitUntilDone:YES];
//                NSLog(@"Updating");
                
            });
            
        }else{
            
            NSLog(@"User location not found");
        }
    }
}

- (void)fetchedData:(NSData *)responseData {
    
    if (responseData == nil) {
        self.distanceToISS.text = @"...";
        self.issVisibilityLabel.text = @"...";
        self.issVelocityLabel.text = @"...";
        self.issAltitudeLabel.text = @"...";
    }else{
        
        //Parse out the json data
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions
                                                               error:&error];
        
        //Grab data from API
        NSString *lat = [json objectForKey:@"latitude"];
        NSString *lon = [json objectForKey:@"longitude"];
        NSString *alt = [json objectForKey:@"altitude"];
        NSString *vel = [json objectForKey:@"velocity"];
        
        //Save ISS data
        issVisibility = [json objectForKey:@"visibility"];
        issLatitude = [lat doubleValue];
        issLongitude = [lon doubleValue];
        issAltitude = [alt doubleValue];
        issVelocity = [vel doubleValue];
        
    }
}

-(void)processMotion:(CMDeviceMotion*)motion {
}

-(void)outputMagnetometerData:(CMMagneticField)magneticField{
}


@end

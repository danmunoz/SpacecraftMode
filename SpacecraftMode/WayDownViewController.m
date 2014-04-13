//
//  WayDownViewController.m
//  SpacecraftMode
//
//  Created by Daniel Munoz on 4/13/14.
//  Copyright (c) 2014 Greencraft. All rights reserved.
//

#import "WayDownViewController.h"
#define kFilteringFactor 0.1
#define deltaTime 0.05;


@interface WayDownViewController ()
{
    double AaccelX;
    double AaccelY;
    double AaccelZ;
}
@property (weak, nonatomic) IBOutlet UILabel *accelX;
@property (weak, nonatomic) IBOutlet UILabel *accelY;
@property (weak, nonatomic) IBOutlet UILabel *accelZ;
@property (weak, nonatomic) IBOutlet UIImageView *arrowView;
@property (weak, nonatomic) IBOutlet UILabel *gravityVector;

@end

@implementation WayDownViewController

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
    //Objeto motionManager:
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = deltaTime;
    self.motionManager.deviceMotionUpdateInterval = deltaTime;
    self.motionManager.gyroUpdateInterval = deltaTime;
    self.motionManager.magnetometerUpdateInterval = deltaTime;
    [self.motionManager startDeviceMotionUpdates];
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error){
                                                 [self outputAccelertionData:accelerometerData.acceleration];if(error){NSLog(@"%@", error);}}];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)outputAccelertionData:(CMAcceleration)acceleration{
    //Etapa filtro
    AaccelX = (acceleration.x * kFilteringFactor) + (AaccelX * (1.0 - kFilteringFactor));
    AaccelY = (acceleration.y * kFilteringFactor) + (AaccelY * (1.0 - kFilteringFactor));
    AaccelZ = (acceleration.z * kFilteringFactor) + (AaccelZ * (1.0 - kFilteringFactor));

    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    float accelerationVector = sqrtf((acceleration.x*acceleration.x)+(acceleration.y*acceleration.y)+(acceleration.z*acceleration.z));
    CATransform3D rotationY = CATransform3DIdentity;
    CATransform3D rotationZ = CATransform3DIdentity;
    //Rotacion eje Y
    double filteredY;
    UIImage *flechaVectorIzquierda = [UIImage imageNamed:@"rocketIzq"];
    UIImage *flechaVectorDerecha = [UIImage imageNamed:@"rocketDer"];
    if (AaccelX < -0.1) {
        filteredY = (AaccelY * -1);
        [self.arrowView setImage:flechaVectorIzquierda];
    }else{
        filteredY = AaccelY;
        [self.arrowView setImage:flechaVectorDerecha];
    }
    rotationY.m34 = 1.0 / 1000.0;
    rotationY = CATransform3DRotate(rotationY,filteredY*-M_PI_2, 0,0,1);
    //Rotacion eje Z
    rotationZ.m34 = 1.0 / 1000.0;
    rotationZ = CATransform3DRotate(rotationZ,acceleration.z*-M_PI_2, 0,1,0);
    
    [UIView animateKeyframesWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        // specify the new `frame`, `transform`, etc. here
        self.arrowView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.arrowView.layer.transform = rotationY;
        self.arrowView.layer.transform = CATransform3DConcat(rotationY, rotationZ);
        
    } completion:^(BOOL finished){
        
        // code to be executed when flip is completed
        
    }];
    
    
    //ACCEL
    
    self.accelX.text = [NSString stringWithFormat:@"%.2f m/s",acceleration.x];
    self.accelY.text = [NSString stringWithFormat:@"%.2f m/s",acceleration.y];
    self.accelZ.text = [NSString stringWithFormat:@"%.2f m/s",acceleration.z];
    
    self.gravityVector.text = [NSString stringWithFormat:@"%.2f (%.2f m/sˆ2)",accelerationVector,accelerationVector*9.81];
    //Accelerometer Update Interval.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

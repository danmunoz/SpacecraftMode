//
//  DataComparisonViewController.m
//  SpacecraftMode
//
//  Created by Daniel Munoz on 4/12/14.
//  Copyright (c) 2014 Greencraft. All rights reserved.
//

#import "DataComparisonViewController.h"
typedef enum{
    RotationDirectionClockwise = 0,
    RotationDirectionCounterClockwise = 1
}RotationDirection;

typedef enum{
    SMAnimationStateWeight = 0,
    SMAnimationStateSpeed = 1,
    SMAnimationStateAltitude = 2,
    SMAnimationStateTemperature = 3,
}SMAnimationState;

@interface DataComparisonViewController ()
@property (weak, nonatomic) IBOutlet UIView *earthView;
@property (nonatomic, strong) NSNumber *currentEarthValue;
@property (weak, nonatomic) IBOutlet UIImageView *skinnyRocketImageView;
@property (weak, nonatomic) IBOutlet UIImageView *speedRocketImageView;
@property (nonatomic) SMAnimationState animationState;
@property (weak, nonatomic) IBOutlet UIImageView *slowCarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fatGuyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *coldTempImageView;
@property (weak, nonatomic) IBOutlet UIImageView *hotGuyImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;


@end

@implementation DataComparisonViewController

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
    self.currentEarthValue = [NSNumber numberWithInt:0];
    self.animationState = SMAnimationStateWeight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rotateEarthToDirection:(RotationDirection)direction{
    CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
    rotate.removedOnCompletion = FALSE;
    rotate.fillMode = kCAFillModeForwards;
    rotate.fromValue = self.currentEarthValue;
    if (direction == RotationDirectionCounterClockwise) {
        //Do a series of 5 quarter turns for a total of a 1.25 turns
        //(2PI is a full turn, so pi/2 is a quarter turn)
        [rotate setToValue: [NSNumber numberWithFloat: self.currentEarthValue.floatValue + M_PI / 2]];
    }
    else{
        [rotate setToValue: [NSNumber numberWithFloat: self.currentEarthValue.floatValue -M_PI / 2]];
    }
    rotate.duration = 2/2;
    rotate.beginTime = 0;
    rotate.cumulative = TRUE;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.earthView.layer addAnimation:rotate forKey:@"rotateAnimation"];
    self.currentEarthValue = rotate.toValue;
}

- (void)animationDidStart:(CAAnimation *)anim{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    self.earthView.layer.transform = CATransform3DMakeRotation(90.0 / 180.0 * M_PI, 0.0, 0.0, 1.0);
}

- (void)showImagesForCurrentAnimation{
    switch (self.animationState) {
        case SMAnimationStateWeight:
        {
            [self.slowCarImageView setHidden:YES];
            [self.speedRocketImageView setHidden:YES];
            [self.coldTempImageView setHidden:YES];
            [self.hotGuyImageView setHidden:YES];
            [self.fatGuyImageView setHidden:NO];
            [self.skinnyRocketImageView setHidden:NO];
            [self.titleLabel setText:@"WEIGHT"];
            [self.descriptionLabel setText:@"8x lighter than you!"];
        }
            break;
        case SMAnimationStateSpeed:
            //TODO: remove images for altitude
            [self.fatGuyImageView setHidden:YES];
            [self.skinnyRocketImageView setHidden:YES];
            [self.slowCarImageView setHidden:NO];
            [self.speedRocketImageView setHidden:NO];
            [self.titleLabel setText:@"SPEED"];
            [self.descriptionLabel setText:@"28x faster than you!"];
            break;
        case SMAnimationStateAltitude:
            [self.coldTempImageView setHidden:YES];
            [self.hotGuyImageView setHidden:YES];
            [self.slowCarImageView setHidden:YES];
            [self.speedRocketImageView setHidden:YES];
            //set proper images!!
            [self.fatGuyImageView setHidden:NO];
            [self.skinnyRocketImageView setHidden:NO];
            [self.titleLabel setText:@"ALTITUDE"];
            [self.descriptionLabel setText:@"396.716 m above you!"];
            break;
        case SMAnimationStateTemperature:
            [self.fatGuyImageView setHidden:YES];
            [self.skinnyRocketImageView setHidden:YES];
            [self.coldTempImageView setHidden:NO];
            [self.hotGuyImageView setHidden:NO];
            [self.titleLabel setText:@"TEMPERATURE"];
            [self.descriptionLabel setText:@"4x colder than you!"];
            //TODO: remove images for altitude
            break;
        default:
            break;
    }
}

- (IBAction)advanceRight:(id)sender {
    [self rotateEarthToDirection:RotationDirectionClockwise];
    [self incrementAnimationCount];
    [self showImagesForCurrentAnimation];
}

- (IBAction)advanceLeft:(id)sender {
    [self rotateEarthToDirection:RotationDirectionCounterClockwise];
    [self decrementAnimationCount];
    [self showImagesForCurrentAnimation];
}

- (void)incrementAnimationCount{
    if (self.animationState == SMAnimationStateTemperature) {
        self.animationState = SMAnimationStateWeight;
    }
    else{
        self.animationState ++;
    }
}

- (void)decrementAnimationCount{
    if (self.animationState == SMAnimationStateWeight) {
        self.animationState = SMAnimationStateTemperature;
    }
    else{
        self.animationState --;
    }
}
@end

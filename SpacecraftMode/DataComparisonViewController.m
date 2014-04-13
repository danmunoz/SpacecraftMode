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

@interface DataComparisonViewController ()
@property (weak, nonatomic) IBOutlet UIView *earthView;
@property (nonatomic, strong) NSNumber *currentEarthValue;
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
    // Do any additional setup after loading the view.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)advanceRight:(id)sender {
    [self rotateEarthToDirection:RotationDirectionClockwise];
}

- (IBAction)advanceLeft:(id)sender {
    [self rotateEarthToDirection:RotationDirectionCounterClockwise];
}
@end

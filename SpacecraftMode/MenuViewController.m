//
//  MenuViewController.m
//  SpacecraftMode
//
//  Created by Daniel Munoz on 4/11/14.
//  Copyright (c) 2014 Greencraft. All rights reserved.
//

#import "MenuViewController.h"
#import "SpaceTabBarController.h"

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UIButton *issButton;
@property (weak, nonatomic) IBOutlet UIButton *earthButton;
@property (weak, nonatomic) IBOutlet UILabel *spaceLabel;
@property (nonatomic, strong) SpaceTabBarController *spaceTabBarController;
@end

@implementation MenuViewController

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
    [self setUpParallax];
    [self.spaceLabel setAlpha:0.0];
//    [self.earthButton setAlpha:0.0f];
    [self animateButtons];
}

- (void)viewWillAppear:(BOOL)animated{
}


- (void)viewDidLayoutSubviews{
//    [self.earthButton setFrame:CGRectMake(0, 1000, 320, 177)];
}

- (void)animateButtons{
    [self.issButton setFrame:CGRectMake(100, -200, 281, 99)];
//    [self.earthButton setFrame:CGRectMake(0, 1000, 320, 177)];
    
    
    [self.issButton setAlpha:1.0f];
    
    float animationTime = 0.5f;
    CGPoint fromPoint = self.issButton.layer.position;
    CGPoint toPoint;
    toPoint = CGPointMake(179.5, 69.5);
    self.issButton.frame = CGRectMake(self.issButton.layer.position.x, self.issButton.layer.position.x, self.issButton.frame.size.width, self.issButton.frame.size.height);
    self.issButton.layer.position = toPoint;
    CABasicAnimation * moveLogoUpAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveLogoUpAnimation.fromValue = [NSValue valueWithCGPoint:fromPoint];
    moveLogoUpAnimation.toValue = [NSValue valueWithCGPoint:toPoint];
    moveLogoUpAnimation.duration = animationTime;
    moveLogoUpAnimation.fillMode = kCAFillModeForwards;
    moveLogoUpAnimation.removedOnCompletion = NO;
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:moveLogoUpAnimation, nil];
    animationGroup.duration = animationTime;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    [self.issButton.layer addAnimation:animationGroup forKey:@"anim"];
    
    
    
//    CGPoint fromPoint2 = self.earthButton.layer.position;
//    CGPoint toPoint2 = CGPointMake(160, 500);
//    self.earthButton.frame = CGRectMake(self.earthButton.layer.position.x, self.earthButton.layer.position.x, self.earthButton.frame.size.width, self.earthButton.frame.size.height);
//    self.earthButton.layer.position = toPoint2;
//    CABasicAnimation * moveEarthUpAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
//    moveEarthUpAnimation.fromValue = [NSValue valueWithCGPoint:fromPoint2];
//    moveEarthUpAnimation.toValue = [NSValue valueWithCGPoint:toPoint2];
//    moveEarthUpAnimation.duration = animationTime;
//    moveEarthUpAnimation.fillMode = kCAFillModeForwards;
//    moveEarthUpAnimation.removedOnCompletion = NO;
//    CAAnimationGroup *animationGroup2 = [CAAnimationGroup animation];
//    animationGroup2.animations = [NSArray arrayWithObjects:moveEarthUpAnimation, nil];
//    animationGroup2.duration = animationTime;
//    animationGroup2.fillMode = kCAFillModeForwards;
//    animationGroup2.removedOnCompletion = NO;
//    [self.earthButton setAlpha:1.0f];
//    [self.earthButton.layer addAnimation:animationGroup2 forKey:@"anim"];
    
    
    
    [UIView animateWithDuration:0.6f animations:^{
        [self.spaceLabel setAlpha:1.0];
    } completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpParallax{
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-30);
    verticalMotionEffect.maximumRelativeValue = @(30);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-30);
    horizontalMotionEffect.maximumRelativeValue = @(30);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [self.issButton addMotionEffect:group];
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

- (IBAction)goToSpaceMode:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"spaceInit"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];

}

- (IBAction)goToEarthMode:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"EarthStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"earthInit"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
}
@end

//
//  StartViewController.m
//  SpacecraftMode
//
//  Created by Daniel Munoz on 4/11/14.
//  Copyright (c) 2014 Greencraft. All rights reserved.
//

#import "StartViewController.h"
#import <PebbleKit/PebbleKit.h>
#import "MenuViewController.h"
#import <AudioToolbox/AudioServices.h>

@interface StartViewController ()
@property (weak, nonatomic) IBOutlet UIView *spacecraftView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fumesImageView;
@property (nonatomic, strong) MenuViewController *menuVC;
@property (nonatomic, strong) CALayer *textLayer;
@property (nonatomic) CGFloat firstX;
@property (nonatomic) CGFloat firstY;
@property (strong, nonatomic) PBWatch *connectedWatch;
@property (nonatomic) int testInt;
@end

@implementation StartViewController

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
    self.testInt = 0;
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [recognizer setDelegate:self];
    [[self spacecraftView] addGestureRecognizer:recognizer];
    self.connectedWatch = [[PBPebbleCentral defaultCentral] lastConnectedWatch];
    [self animateDirectionArrows];
    [self setUpParallax];
}

- (void)animateDirectionArrows{
    self.view.layer.backgroundColor = [[UIColor blackColor] CGColor];
    
    UIImage *textImage = [UIImage imageNamed:@"directionArrow.png"];
    CGFloat textWidth = textImage.size.width;
    CGFloat textHeight = textImage.size.height;
    
    self.textLayer = [CALayer layer];
    self.textLayer.contents = (id)[textImage CGImage];
    self.textLayer.frame = CGRectMake(145.0f, 280.0f, textWidth, textHeight);
    
    CALayer *maskLayer = [CALayer layer];
    
    // Mask image ends with 0.15 opacity on both sides. Set the background color of the layer
    // to the same value so the layer can extend the mask image.
    maskLayer.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f] CGColor];
    maskLayer.contents = (id)[[UIImage imageNamed:@"arrowMask.png"] CGImage];
    
    // Center the mask image on twice the width of the text layer, so it starts to the left
    // of the text layer and moves to its right when we translate it by width.
    maskLayer.contentsGravity = kCAGravityCenter;
    maskLayer.frame = CGRectMake(0.0f, 0.0f, textWidth, textHeight);
    
    // Animate the mask layer's horizontal position
    CABasicAnimation *maskAnim = [CABasicAnimation animationWithKeyPath:@"position.y"];
    maskAnim.byValue = [NSNumber numberWithFloat:textHeight-200];
    maskAnim.repeatCount = HUGE_VALF;
    maskAnim.duration = 1.5f;
    [maskLayer addAnimation:maskAnim forKey:@"slideAnim"];
    
    //    self.textLayer.mask = maskLayer;
    [self.view.layer addSublayer:self.textLayer];
    [self.view bringSubviewToFront:self.spacecraftView];
}

- (void)rotate{
    CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
    rotate.removedOnCompletion = FALSE;
    rotate.fillMode = kCAFillModeForwards;
    
    //Do a series of 5 quarter turns for a total of a 1.25 turns
    //(2PI is a full turn, so pi/2 is a quarter turn)
    [rotate setToValue: [NSNumber numberWithFloat: -M_PI / 2]];
    rotate.repeatCount = 11;
    
    rotate.duration = 2/2;
    rotate.beginTime = 0;
    rotate.cumulative = TRUE;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.spacecraftView.layer addAnimation:rotate forKey:@"rotateAnimation"];
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
    [self.logoImageView addMotionEffect:group];
}

- (void)move:(id)sender{
    //AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer*)sender;
    CGPoint translatedPoint = [panGestureRecognizer translationInView:self.view];
    CGFloat velocityY = [panGestureRecognizer velocityInView:self.view].y;
    if ([panGestureRecognizer state] == UIGestureRecognizerStateBegan) {
        self.firstX = [[sender view] center].x;
        self.firstY = [[sender view] center].y;
    }
    if (translatedPoint.y < 0) {
        float alpha = (1-fabsf(translatedPoint.y)*0.01);
        self.textLayer.opacity = alpha;
        [self.logoImageView setAlpha:alpha];
        alpha = (1-fabsf(translatedPoint.y)*0.004);
        [self.fumesImageView setAlpha:1-alpha];
    }
    translatedPoint = CGPointMake(self.firstX, self.firstY+translatedPoint.y);
    [[sender view] setCenter:translatedPoint];
    float viewTop = [[sender view] frame].origin.y;
    if ([panGestureRecognizer state] == UIGestureRecognizerStateEnded){
        if (viewTop>=self.view.frame.size.height*0.55) {
            [self slideRegistrationDown:viewTop andVelocity:velocityY sender:sender];
        }
        else if (viewTop<=self.view.frame.size.height*0.55) {
            [self slideRegistrationUp:viewTop andVelocity:velocityY sender:sender];
        }
    }
}

- (void)slideRegistrationUp:(CGFloat)viewTop andVelocity:(CGFloat)velocityY sender:(id)sender{
    CGFloat yPoints = fabsf((self.view.frame.size.height - 200) - viewTop);
    NSTimeInterval duration = yPoints / velocityY;
    duration = 0.6;
    [UIView animateWithDuration:duration animations:^{
        [[sender view] setCenter:CGPointMake(self.firstX, -200)];
        [self.fumesImageView setAlpha:0.0f];
    } completion:^(BOOL finished){
        if (finished) {
            [self.spacecraftView setHidden:YES];
            [self performSegueWithIdentifier:@"StartToSelector" sender:self];
        }
    }];
    [UIView animateWithDuration:fabsf(duration) animations:^{
        [[sender view] setCenter:CGPointMake(self.firstX, -200)];
    }];
}

- (void)slideRegistrationDown:(CGFloat)viewTop andVelocity:(CGFloat)velocityY sender:(id)sender{
    CGFloat yPoints = fabsf(self.view.frame.size.height - viewTop);
    NSTimeInterval duration = yPoints / velocityY;
    if (fabsf(duration)>1.0) {
        duration = 0.45;
    }
    if (viewTop>=self.view.frame.size.height*0.75 && fabsf(duration)<0.3) {
        duration = 0.35;
    }
    [UIView animateWithDuration:fabsf(duration) animations:^{
        [[sender view] setCenter:CGPointMake(self.firstX, self.firstY)];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)testMessagePebble:(id)sender {
    [self takePhoto];
    
    ////    NSString *testString = [NSString stringWithFormat:@"Hola %i", self.testInt];
    //    self.testInt ++;
    //    NSDictionary *update = @{ @(0):@"string one",
    //                              @(1):@"string two"};
    //    [self.connectedWatch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
    //        if (!error) {
    //            NSLog(@"Successfully sent message: %@", update);
    //        }
    //        else {
    //            NSLog(@"Error sending message: %@", error);
    //        }
    //    }];
    
    
}

- (void)takePhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"StartToSelector"]) {
        self.menuVC = segue.destinationViewController;
        NSLog(@"segueee");
    }
}

@end

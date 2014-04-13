//
//  FlightInfoViewController.m
//  SpacecraftMode
//
//  Created by Daniel Munoz on 4/11/14.
//  Copyright (c) 2014 Greencraft. All rights reserved.
//

#import "FlightInfoViewController.h"

@interface FlightInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *altitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *heartBeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *bloodPressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *glucoseLabel;

@end

@implementation FlightInfoViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)test:(id)sender {
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//    [self.tabBarController setSelectedIndex:1];
}
@end

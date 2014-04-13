//
//  SpaceSettingsViewController.m
//  SpacecraftMode
//
//  Created by Daniel Munoz on 4/12/14.
//  Copyright (c) 2014 Greencraft. All rights reserved.
//

#import "SpaceSettingsViewController.h"

@interface SpaceSettingsViewController ()

@end

@implementation SpaceSettingsViewController

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

- (IBAction)exit:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
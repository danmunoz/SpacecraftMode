//
//  EarthSettingsViewController.m
//  SpacecraftMode
//
//  Created by Daniel Munoz on 4/13/14.
//  Copyright (c) 2014 Greencraft. All rights reserved.
//

#import "EarthSettingsViewController.h"

@interface EarthSettingsViewController ()

@end

@implementation EarthSettingsViewController

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

- (IBAction)exit:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

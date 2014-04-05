//
//  RideViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/1/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RideDetailsViewController.h"
#import "BuildingsManager.h"
#import "UnimplementedActionManager.h"

@interface RideDetailsViewController ()

@end

@implementation RideDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBarHidden = YES;
    self.mainImageView.image = [UIImage imageNamed:[[[BuildingsManager sharedManager] buildingsArray] objectAtIndex:self.imageNumber]];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return  UIStatusBarStyleDefault;
}

- (IBAction)arrowLeftPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)joinButtonPressed:(id)sender {
    [[UnimplementedActionManager sharedManager] showAlertView:@"Functionality coming soon :)" title:@"Ride details"];
}

- (IBAction)contactDriverButtonPressed:(id)sender {
        [[UnimplementedActionManager sharedManager] showAlertView:@"Functionality coming soon :)" title:@"Ride details"];
}

@end

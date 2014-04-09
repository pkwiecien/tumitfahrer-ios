//
//  RideViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/1/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RideDetailsViewController.h"
#import "BuildingsManager.h"
#import "ActionManager.h"

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
    self.navigationController.navigationBarHidden = YES;
    self.mainImageView.image = [UIImage imageNamed:[[[BuildingsManager sharedManager] buildingsArray] objectAtIndex:self.imageNumber]];
    
    // Set parallax for horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-20);
    horizontalMotionEffect.maximumRelativeValue = @(20);
    
    // Add both effects to your view
    [self.mainImageView addMotionEffect:horizontalMotionEffect];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (IBAction)arrowLeftPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)joinButtonPressed:(id)sender {
    [[ActionManager sharedManager] showAlertViewWithTitle:@"Join a ride"];
}

- (IBAction)contactDriverButtonPressed:(id)sender {
    [[ActionManager sharedManager] showAlertViewWithTitle:@"Contact driver"];
}

@end

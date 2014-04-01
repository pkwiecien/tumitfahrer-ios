//
//  ActivityRidesViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/1/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "ActivityRidesViewController.h"

@interface ActivityRidesViewController ()

@end

@implementation ActivityRidesViewController

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
}

-(BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}


- (IBAction)menuButtonPressed:(id)sender {
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
}
@end

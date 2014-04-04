//
//  AnotherActivitiesViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/4/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "AnotherActivitiesViewController.h"

@interface AnotherActivitiesViewController ()

@end

@implementation AnotherActivitiesViewController

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
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AddSmallIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(aMethod)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    self.tabBar.delegate = self;
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];
    UITabBarItem *item = [self.tabBar.items objectAtIndex:0];
    self.title = item.title;
}

-(void)aMethod
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Add ride" message:@"This functionality is coming soon :)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [message show];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.title = item.title;
}

-(BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (IBAction)addIconPressed:(id)sender {
       [[SlideNavigationController sharedInstance] toggleLeftMenu];
}

@end

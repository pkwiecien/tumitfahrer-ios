//
//  MenuViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 3/29/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "SettingsViewController.h"
#import "RideRequestsViewController.h"
#import "ActivityRidesViewController.h"
#import <SlideNavigationController.h>
#import "HATransitionController.h"
#import "CampusRidesViewController.h"
#import "AnotherActivitiesViewController.h"
#import "ActionManager.h"
#import "SettingsViewController.h"
#import "ProfileViewController.h"

@interface MenuViewController ()

@property NSMutableArray *viewControllers;
@property NSMutableArray *menuItems;
@property NSMutableArray *menuIcons;
@property (nonatomic) HATransitionController *transitionController;

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        RideRequestsViewController *rideRequestsVC = [[RideRequestsViewController alloc] init];
        ActivityRidesViewController *activityRidesVC = [[ActivityRidesViewController alloc] init];
        CampusRidesViewController *campusRidesVC = [[CampusRidesViewController alloc] init];
        AnotherActivitiesViewController *anotherActivitiesVC = [[AnotherActivitiesViewController alloc] init];
        SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
        ProfileViewController *profileVC = [[ProfileViewController alloc] init];
        self.transitionController = [[HATransitionController alloc] initWithCollectionView:campusRidesVC.collectionView];
        
        self.viewControllers = [NSMutableArray arrayWithObjects:rideRequestsVC, campusRidesVC, activityRidesVC, anotherActivitiesVC, profileVC, settingsVC, nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.menuItems = [NSMutableArray arrayWithObjects:@"Requests", @"Campus Rides", @"Activities", @"Your Schedule", @"Profile", @"Settings", nil];
    self.menuIcons = [NSMutableArray arrayWithObjects:@"RequestIcon", @"CampusIcon", @"ActivityIcon", @"ScheduleIcon", @"ProfileIcon", @"SettingsIcon", nil];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gradientBackground"]];
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuTableViewCell";
    __block MenuTableViewCell *cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.menuLabel.text = self.menuItems[indexPath.row];
    UIColor *almostWhiteColor = [UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:0.8];
    UIImage *newImg = [[ActionManager sharedManager] colorImage:[UIImage imageNamed:self.menuIcons[indexPath.row]] withColor:almostWhiteColor];
    cell.iconMenuImageView.image = newImg;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:70 green:30 blue:180 alpha:0.3];
    bgColorView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < [self.viewControllers count])
        [[SlideNavigationController sharedInstance] switchToViewController:[self.viewControllers objectAtIndex:indexPath.row]  withCompletion:nil];
}

#pragma mark - Paper collection view
- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    if (animationController==self.transitionController) {
        return self.transitionController;
    }
    return nil;
}


- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if (![fromVC isKindOfClass:[UICollectionViewController class]] || ![toVC isKindOfClass:[UICollectionViewController class]])
    {
        return nil;
    }
    if (!self.transitionController.hasActiveInteraction)
    {
        return nil;
    }
    
    self.transitionController.navigationOperation = operation;
    return self.transitionController;
}


@end

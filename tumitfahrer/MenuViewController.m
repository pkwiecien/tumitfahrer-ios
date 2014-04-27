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
#import "CurrentUser.h"

@interface MenuViewController ()

@property NSMutableArray *viewControllers;
@property NSMutableArray *menuIcons;
@property (nonatomic) HATransitionController *transitionController;

@property NSArray *browseRidesSection;
@property NSArray *addRidesSection;
@property NSArray *profileSection;
@property NSArray *allMenuItems;

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        RideRequestsViewController *rideRequestsVC = [[RideRequestsViewController alloc] init];
        ActivityRidesViewController *activityRidesVC = [[ActivityRidesViewController alloc] init];
        CampusRidesViewController *campusRidesVC = [[CampusRidesViewController alloc] init];
        AnotherActivitiesViewController *anotherActivitiesVC = [[AnotherActivitiesViewController alloc] init];
        SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
        ProfileViewController *profileVC = [[ProfileViewController alloc] init];
        self.transitionController = [[HATransitionController alloc] initWithCollectionView:campusRidesVC.collectionView];
        
        self.viewControllers = [NSMutableArray arrayWithObjects:campusRidesVC, activityRidesVC, rideRequestsVC, anotherActivitiesVC, profileVC, settingsVC, nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.browseRidesSection = [NSArray arrayWithObjects:@"Campus Rides", @"Activities", @"Ride Requests", nil];
    self.addRidesSection = [NSArray arrayWithObjects:@"Add Ride", @"Add Request", nil];
    self.profileSection = [NSArray arrayWithObjects:@"Your Schedule", @"Profile", @"Messages", @"Settings", nil];
    self.allMenuItems = [NSArray arrayWithObjects:self.browseRidesSection, self.addRidesSection, self.profileSection, nil];
    
    self.menuIcons = [NSMutableArray arrayWithObjects:@"RequestIcon", @"CampusIcon", @"ActivityIcon", @"ScheduleIcon", @"ProfileIcon", @"SettingsIcon", @"", @"", @"", nil];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gradientBackground"]];
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    
    UIView *menuTopHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"MenuTopHeaderView" owner:self options:nil] firstObject];
    UILabel *initialsLabel = (UILabel *)[menuTopHeaderView viewWithTag:2];
    UILabel *usernameLabel = (UILabel *)[menuTopHeaderView viewWithTag:3];
    
    usernameLabel.text = [CurrentUser sharedInstance].user.firstName;
    initialsLabel.text = [[[CurrentUser sharedInstance].user.firstName substringToIndex:1] stringByAppendingString:[[CurrentUser sharedInstance].user.lastName substringToIndex:1]];
    
    self.tableView.tableHeaderView = menuTopHeaderView;
}

-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"Current user: %@", [CurrentUser sharedInstance].user);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.allMenuItems count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.allMenuItems objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuTableViewCell";
    __block MenuTableViewCell *cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuTableViewCell" owner:self options:nil];
        cell = [nib firstObject];
    }
    
    cell.menuLabel.text = [[self.allMenuItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UIColor *almostWhiteColor = [UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:0.8];
    UIImage *newImg = [ActionManager colorImage:[UIImage imageNamed:self.menuIcons[indexPath.row]] withColor:almostWhiteColor];
    cell.iconMenuImageView.image = newImg;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:70 green:30 blue:180 alpha:0.3];
    bgColorView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"DETAILS";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < [self.viewControllers count])
        [[SlideNavigationController sharedInstance] switchToViewController:[self.viewControllers objectAtIndex:indexPath.row]  withCompletion:nil];
}

#pragma mark - Paper collection view
- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
   
    if (animationController==self.transitionController) {
        return self.transitionController;
    }
    return nil;
}


- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
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

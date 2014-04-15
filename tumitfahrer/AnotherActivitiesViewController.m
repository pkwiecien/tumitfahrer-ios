//
//  AnotherActivitiesViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/4/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "AnotherActivitiesViewController.h"
#import "ActionManager.h"
#import "RideDetailsViewController.h"
#import "RidesStore.h"
#import "Ride.h"

@interface AnotherActivitiesViewController ()

@end

@implementation AnotherActivitiesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *cellNib = [UINib nibWithNibName:@"AnotherCollectionCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"AnotherCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width/2-1, 200)];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.collectionView.delegate = self;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flowLayout];
}

-(void)viewWillAppear:(BOOL)animated {
    [self setupNavbar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)setupNavbar {
    UIColor *navBarColor = [UIColor colorWithRed:0 green:0.361 blue:0.588 alpha:1]; /*#0e3750*/
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:navBarColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[ActionManager sharedManager] imageWithColor:navBarColor] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AddSmallIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(showUnimplementedAlertView)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    self.tabBar.delegate = self;
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];
    UITabBarItem *item = [self.tabBar.items objectAtIndex:0];
    self.title = item.title;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

-(void)showUnimplementedAlertView {
    [[ActionManager sharedManager] showAlertViewWithTitle:@"Add a ride"];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    self.title = item.title;
}

-(BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}

- (IBAction)addIconPressed:(id)sender {
       [[SlideNavigationController sharedInstance] toggleLeftMenu];
}


#pragma mark - Collection view

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[RidesStore sharedStore] allRides] count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"AnotherCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:5];
    Ride *ride = [[[RidesStore sharedStore] allRides] objectAtIndex:indexPath.row];
    if(ride.destinationImage == nil) {
        imageView.image = [UIImage imageNamed:@"PlaceholderImage"];
    } else {
        imageView.image = ride.destinationImage;
    }
    
    [imageView setClipsToBounds:YES];
    UILabel *destinationLabel = (UILabel *)[cell.contentView viewWithTag:9];
    destinationLabel.text = ride.destination;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RideDetailsViewController *rideDetailsVC = [[RideDetailsViewController alloc] init];
    rideDetailsVC.selectedRide = [[[RidesStore sharedStore] allRides] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:rideDetailsVC animated:YES];
}

#pragma mark – UICollectionViewDelegateFlowLayout


@end

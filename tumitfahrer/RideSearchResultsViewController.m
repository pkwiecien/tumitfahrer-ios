//
//  AnotherActivitiesViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/4/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RideSearchResultsViewController.h"
#import "ActionManager.h"
#import "RideDetailViewController.h"
#import "RideSearchStore.h"
#import "RideSearch.h"
#import "CvLayout.h"
#import "NavigationBarUtilities.h"
#import "RidesStore.h"

@interface RideSearchResultsViewController ()

@end

@implementation RideSearchResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *cellNib = [UINib nibWithNibName:@"RideSearchResultCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"RideSearchCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    CvLayout *cvLayout = [[CvLayout alloc] init];
    [self.collectionView setCollectionViewLayout:cvLayout];
}

-(void)viewWillAppear:(BOOL)animated {
    [self setupView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)setupView {
    self.view = [NavigationBarUtilities makeBackground:self.view];
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController];
    self.title = @"SEARCH RESULTS";
}

#pragma mark - Collection view

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[RideSearchStore sharedStore] allSearchResults] count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"RideSearchCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:5];
    RideSearch *ride = [[[RideSearchStore sharedStore] allSearchResults] objectAtIndex:indexPath.row];
    NSLog(@"currenlty ride: %d", ride.rideId);
    if(ride.destinationImage == nil) {
        imageView.image = [UIImage imageNamed:@"PlaceholderImage"];
    } else {
        imageView.image = [UIImage imageWithData:ride.destinationImage];
    }
    
    [imageView setClipsToBounds:YES];
    
    UILabel *departureLabel = (UILabel *)[cell.contentView viewWithTag:8];
    UILabel *destinationLabel = (UILabel *)[cell.contentView viewWithTag:9];
    UILabel *departureTimeLabel = (UILabel *)[cell.contentView viewWithTag:10];
    destinationLabel.text = ride.destination;
    departureLabel.text = ride.departurePlace;
    departureTimeLabel.text = [ActionManager stringFromDate:ride.departureTime];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RideSearch *rideSearch = [[[RideSearchStore sharedStore] allSearchResults] objectAtIndex:indexPath.row];
    Ride *ride = [[RidesStore sharedStore] containsRideWithId:rideSearch.rideId];
    
    if (ride != nil) {
        RideDetailViewController *rideDetailsVC = [[RideDetailViewController alloc] init];
        rideDetailsVC.ride = ride;
        [self.navigationController pushViewController:rideDetailsVC animated:YES];
    }

}

#pragma mark – UICollectionViewDelegateFlowLayout
-(void)reloadDataAtIndex:(NSInteger)index {
    [self.collectionView reloadData];
    //    NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndex:index];
    //    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
}

@end

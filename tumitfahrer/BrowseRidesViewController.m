//
//  ActivityRidesViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/1/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "BrowseRidesViewController.h"
#import "CvLayout.h"
#import "RidesStore.h"
#import "Ride.h"
#import "ActionManager.h"
#import "SearchRideViewController.h"
#import "AddRideViewController.h"
#import "CurrentUser.h"
#import "LoginViewController.h"
#import "RideDetailViewController.h"

@interface BrowseRidesViewController ()

@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) CGRect upperFrame;
@property (nonatomic, assign) CGRect departureLabelFrame;
@property (nonatomic, assign) CGRect lowerFrame;
@property (nonatomic, assign) BOOL isUpperViewSmall;

@property (nonatomic, strong) UIRefreshControl *topControl;
@property BOOL loadingNewElements;

@end

@implementation BrowseRidesViewController

-(instancetype)initWithContentType:(ContentType)contentType {
    self = [super init];
    if (self) {
        self.RideType = contentType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isUpperViewSmall = NO;
    
    UINib *cellNib = [UINib nibWithNibName:@"RideCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"RideCell"];
    self.collectionView.alwaysBounceVertical = YES;
    
    CvLayout *cvLayout = [[CvLayout alloc] init];
    [self.collectionView setCollectionViewLayout:cvLayout];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    self.departurePlaceView.clipsToBounds = YES;
    
    [self.menuButton setBackgroundImage:[ActionManager colorImage:[UIImage imageNamed:@"SettingsBlackIcon"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeViewLarge)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self.departurePlaceView addGestureRecognizer:tapGesture];
    
    self.topControl = [[UIRefreshControl alloc] init];
    self.topControl.tintColor = [UIColor grayColor];
    [self.topControl addTarget:self action:@selector(refershControlAction) forControlEvents:UIControlEventValueChanged];
    //    [self.collectionView addSubview:self.topControl];
    
    // get current user
    NSString *emailLoggedInUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"emailLoggedInUser"];
    
    if (emailLoggedInUser != nil) {
        [CurrentUser fetchUserFromCoreDataWithEmail:emailLoggedInUser];
    }
    
    [[PanoramioUtilities sharedInstance] addObserver:self];
    [[RidesStore sharedStore] addObserver:self];
    
    [self setViewTitle];
}

-(void)setViewTitle {
    switch (self.RideType) {
        case ContentTypeActivityRides:
            self.contentTitle.text = @"Activity Rides";
            break;
        case ContentTypeCampusRides:
            self.contentTitle.text = @"Campus Rides";
            break;
        case ContentTypeExistingRequests:
            self.contentTitle.text = @"Existing Request";
            break;
        default:
            break;
    }
}

-(void)refershControlAction
{
    NSLog(@"Refresh control action");
}

-(void)makeViewLarge {
    [self makeViewLargeQuickly:NO];
}

-(void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBarHidden = YES;
    
    if([CurrentUser sharedInstance].user == nil)
    {
        [self showLoginScreen:NO];
    }
    
    [self.collectionView reloadData];
    
    if(self.isUpperViewSmall) {
        [self makeViewSmallQuickly:YES];
    }
    else {
        [self makeViewLargeQuickly:YES];
    }
    [self refreshCurrentLocationImage];
    self.loadingNewElements = false;
}

-(void)showLoginScreen:(BOOL)animated
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self presentViewController:loginVC animated:animated completion:nil];
}

-(void)makeViewSmallQuickly:(BOOL)isQuickly {
    [UIView animateWithDuration:(isQuickly?0.01:1.0) animations:^{
        self.upperFrame =  CGRectMake(0, 0, self.departurePlaceView.frame.size.width, 120);
        self.departurePlaceView.frame = self.upperFrame;
        
        self.departureLabelFrame = CGRectMake(0, 85, self.departureLabelView.frame.size.width, self.departureLabelView.frame.size.height);
        self.departureLabelView.frame = self.departureLabelFrame;
        
        self.lowerFrame = CGRectMake(0, 122, self.collectionView.frame.size.width, 450);
        self.collectionView.frame = self.lowerFrame;
    }];
}

-(void)makeViewLargeQuickly:(BOOL)isQuickly {
    [UIView animateWithDuration:(isQuickly?0.01:1.0) animations:^{
        self.upperFrame =  CGRectMake(0, 0, self.departurePlaceView.frame.size.width, 242);
        self.departurePlaceView.frame = self.upperFrame;
        
        self.departureLabelFrame = CGRectMake(15, 193, self.departureLabelView.frame.size.width, self.departureLabelView.frame.size.height);
        self.departureLabelView.frame = self.departureLabelFrame;
        
        self.lowerFrame = CGRectMake(0, 243, self.collectionView.frame.size.width, 450);
        self.collectionView.frame = self.lowerFrame;
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY < -50)
    {
        // is at the top of collection view
        return;
    }
    
    if (!self.loadingNewElements && scrollView.contentSize.height > 0 && (scrollView.contentOffset.y + scrollView.frame.size.height - 70) >= scrollView.contentSize.height)
    {
        NSLog(@"Loading more elements");
        self.loadingNewElements = true;
        [self loadNewElements];
    }
    
    if (self.lastContentOffset < scrollView.contentOffset.y && scrollView.contentSize.height != 0 && offsetY > 0)
    {
        // scroll down
        [self makeViewSmallQuickly:NO];
    }
    
    self.lastContentOffset = scrollView.contentOffset.y;
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [[[RidesStore sharedStore] allRidesByType:self.RideType] count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"RideCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:5];
    Ride *ride = [[[RidesStore sharedStore] allRidesByType:self.RideType] objectAtIndex:indexPath.row];
    if(ride.destinationImage == nil) {
        imageView.image = [UIImage imageNamed:@"PlaceholderImage"];
    } else {
        imageView.image = [UIImage imageWithData:ride.destinationImage];
    }
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UILabel *destinationLabel = (UILabel *)[cell.contentView viewWithTag:9];
    destinationLabel.text = ride.destination;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RideDetailViewController *rideDetailVC = [[RideDetailViewController alloc] init];
    rideDetailVC.ride = [[[RidesStore sharedStore] allRidesByType:self.RideType] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:rideDetailVC animated:YES];
}

#pragma mark - SlideNavigation
- (IBAction)menuButtonPressed:(id)sender {
}

# pragma mark - Action buttons

- (IBAction)searchButtonPressed:(id)sender {
    SearchRideViewController *searchRideVC = [[SearchRideViewController alloc] init];
    searchRideVC.modalTransitionStyle = UIModalPresentationFullScreen;
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:searchRideVC];
    
    [self presentViewController:navBar animated:YES completion:nil];
}

- (IBAction)addButtonPressed:(id)sender {
    AddRideViewController *addRideVC = [[AddRideViewController alloc] init];
    addRideVC.RideType = self.RideType;
    addRideVC.DisplayType = ShowAsModal;
    UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:addRideVC];
    [self.navigationController presentViewController:navBar animated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    if(self.upperFrame.size.height > 200 || [[[RidesStore sharedStore] allRidesByType:self.RideType] count] == 0)
        self.isUpperViewSmall = NO;
    else
        self.isUpperViewSmall = YES;
}

-(void)didReceivePhotoForRide:(NSInteger)rideId {
    [self.collectionView reloadData];
}

-(void)didReceivePhotoForCurrentLocation:(UIImage *)image
{
    [LocationController sharedInstance].currentLocationImage = image;
    [self refreshCurrentLocationImage];
}

-(void)refreshCurrentLocationImage {
    if([LocationController sharedInstance].currentLocationImage) {
        self.currentLocationImageView.image = [LocationController sharedInstance].currentLocationImage;
    } else {
        self.currentLocationImageView.image = [UIImage imageNamed:@"PlaceholderImage"];
    }
}

-(void)didRecieveRidesFromWebService:(NSArray *)rides
{
    for (Ride *ride in rides) {
        NSLog(@"Ride: %@", ride);
    }
}


-(void)loadNewElements {
    [[RidesStore sharedStore] fetchNextRides:^(BOOL fetched) {
        if (fetched) {
            for (Ride *ride in [[RidesStore sharedStore] allRides]) {
                NSLog(@"ride with id: %d", ride.rideId);
                //[self.collectionView reloadData];
            }
        }
    }];
}


@end

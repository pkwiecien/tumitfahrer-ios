//
//  RideRequestsViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 3/29/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RideRequestsViewController.h"
#import "RideDetailsViewController.h"
#import "LoginViewController.h"
#import "CustomTextField.h"
#import "MenuViewController.h"
#import "HATransitionLayout.h"
#import "HACollectionViewLargeLayout.h"
#import "HACollectionViewSmallLayout.h"
#import "ActionManager.h"
#import "User.h"
#import "CurrentUser.h"
#import "Ride.h"

@interface RideRequestsViewController ()

@property NSMutableArray *viewControllers;
@property (nonatomic, strong) UIView *mainView;

@end

@implementation RideRequestsViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *cellNib = [UINib nibWithNibName:@"NibCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"rideCell"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(250, 320)];
    self.collectionView.delegate = self;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    MenuViewController *menuController = [[MenuViewController alloc] init];
    menuController.preferredContentSize = CGSizeMake(180, 0);
    
    [self.settingsButton setImage:[UIImage imageNamed:@"SettingsGreyIcon"] forState:UIControlStateHighlighted];
    
    UISwipeGestureRecognizer *swipeRightLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightLeft)];
    swipeRightLeft.numberOfTouchesRequired = 1;
    swipeRightLeft.delegate = self;
    [swipeRightLeft setDirection:UISwipeGestureRecognizerDirectionRight|UISwipeGestureRecognizerDirectionLeft];
    [self.departureView addGestureRecognizer:swipeRightLeft];
        
    // get current user
    NSString *emailLoggedInUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"emailLoggedInUser"];
    
    if (emailLoggedInUser != nil) {
        [CurrentUser fetchUserWithEmail:emailLoggedInUser];
    }
    
    [[PanoramioUtilities sharedInstance] addObserver:self];
    [[RidesStore sharedStore] addObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    if([CurrentUser sharedInstance].user == nil)
    {
        [self showLoginScreen:YES];
    }
    
    self.navigationController.navigationBarHidden = YES;
    
    // Adjust scrollView decelerationRate
    self.collectionView.decelerationRate = self.class != [RideRequestsViewController class] ? UIScrollViewDecelerationRateNormal : UIScrollViewDecelerationRateFast;
    
    if([LocationController sharedInstance].locationImage !=nil) {
        self.upperImage.image = [LocationController sharedInstance].locationImage;
    } else {
        [[LocationController sharedInstance] startUpdatingLocation];
    }
    /*
    if([LocationController sharedInstance].locationImage !=nil) {
        self.upperImage.image = [LocationController sharedInstance].locationImage;
    } else if ([[LocationController sharedInstance] currentLocation] != nil){
        [[LocationController sharedInstance] startUpdatingLocation];
        [[PanoramioUtilities sharedInstance] fetchPhotoForCurrentLocation:[[LocationController sharedInstance] currentLocation]];
    } else {
        [[LocationController sharedInstance] startUpdatingLocation];
    }*/
    
}

- (void)myMethod:(UIView *)exampleView completion:(void (^)(BOOL finished))completion {
    if (completion) {
        [self.upperImage setImage:[LocationController sharedInstance].locationImage];
    }
}

-(void)handleSwipeRightLeft
{
    [[ActionManager sharedManager] showAlertViewWithTitle:@"Filter will be used to specify departure place"];
}

-(void)enlarge {
    self.upperImage.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        self.upperImage.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
}


-(void)showLoginScreen:(BOOL)animated
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma mark - IBActions -
- (IBAction)menuButtonPressed:(id)sender {
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
}


- (IBAction)filterRidesButtonPressed:(id)sender {
    [[ActionManager sharedManager] showAlertViewWithTitle:@"Filter rides"];
}

#pragma mark - Collections
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[RidesStore sharedStore] allRides] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"rideCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RideDetailsViewController *rideDetailsVC = [[RideDetailsViewController alloc] init];
    rideDetailsVC.selectedRide = [[[RidesStore sharedStore] allRides] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:rideDetailsVC animated:YES];
}

-(UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
{
    HATransitionLayout *transitionLayout = [[HATransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout];
    return transitionLayout;
}

- (IBAction)addRideButtonPressed:(id)sender {
    [[ActionManager sharedManager] showAlertViewWithTitle:@"Add a ride"];
}

-(void)didReceivePhotoForRide:(NSInteger)rideId {
    [self.collectionView reloadData];
}


-(void)didRecieveRidesFromWebService:(NSArray *)rides
{
    for (Ride *ride in rides) {
        NSLog(@"Ride: %@", ride);
    }
}

-(void)didReceivePhotoForCurrentLocation:(UIImage *)image {
    self.upperImage.image = image;
}

-(void)dealloc {
    [[PanoramioUtilities sharedInstance] removeObserver:self];
}

@end

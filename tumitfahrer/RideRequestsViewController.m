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

#define MAX_COUNT 20

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
    [self setNeedsStatusBarAppearanceUpdate];
    UINib *cellNib = [UINib nibWithNibName:@"NibCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"rideCell"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(250, 350)];
    self.collectionView.delegate = self;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    MenuViewController *menuController = [[MenuViewController alloc] init];
    menuController.preferredContentSize = CGSizeMake(180, 0);
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
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

-(void)aMethod
{
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
}

-(void)viewDidAppear:(BOOL)animated
{
   // BOOL isUserLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];

//    if (!isUserLoggedIn) {
//        [self showLoginScreen:YES];
//  }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    // Adjust scrollView decelerationRate
    self.collectionView.decelerationRate = self.class != [RideRequestsViewController class] ? UIScrollViewDecelerationRateNormal : UIScrollViewDecelerationRateFast;
}

-(void)showLoginScreen:(BOOL)animated
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma mark - IBActions -
- (IBAction)menuButtonPressed:(id)sender {
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
}

#pragma mark - Collections
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  MAX_COUNT;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"rideCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RideDetailsViewController *rideDetailsVC = [[RideDetailsViewController alloc] init];
    [self.navigationController pushViewController:rideDetailsVC animated:YES];
}

-(UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
{
    HATransitionLayout *transitionLayout = [[HATransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout];
    return transitionLayout;
}

- (IBAction)addRideButtonPressed:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Add a ride"
                                                      message:@"This functionality is coming soon :)"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
}

@end

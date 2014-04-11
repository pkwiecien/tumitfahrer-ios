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
#import "BuildingsManager.h"
#import "ActionManager.h"
#import "User.h"
#import "CurrentUser.h"

@interface RideRequestsViewController ()

@property NSMutableArray *viewControllers;
@property (nonatomic, strong) UIView *mainView;

@end

@implementation RideRequestsViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        //        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
    
    [LocationController sharedInstance].delegate = self;
    [[LocationController sharedInstance] startUpdatingLocation];
    
    // get current user
    NSString *emailLoggedInUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"emailLoggedInUser"];
    
    if (emailLoggedInUser != nil) {
        [CurrentUser fetchUserWithEmail:emailLoggedInUser];
    }
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
    
    if([LocationController sharedInstance].locationImage)
    {
        self.upperImage.image = [LocationController sharedInstance].locationImage;
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


- (IBAction)filterRidesButtonPressed:(id)sender {
    [[ActionManager sharedManager] showAlertViewWithTitle:@"Filter rides"];
}

#pragma mark - Collections
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  [[[BuildingsManager sharedManager] buildingsArray] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"rideCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
    imageView.image = [UIImage imageNamed:[[[BuildingsManager sharedManager] buildingsArray] objectAtIndex:indexPath.row]];
    [imageView setClipsToBounds:YES];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{    
    RideDetailsViewController *rideDetailsVC = [[RideDetailsViewController alloc] init];
    rideDetailsVC.imageNumber = indexPath.row;
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

-(void)didReceiveLocation:(CLLocation *)location {
    
    NSLog(@"Current location: %f %f", location.coordinate.latitude, location.coordinate.longitude);
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.panoramio.com/map/get_panoramas.php?set=public&from=0&to=1&minx=%f&miny=%f&maxx=%f&maxy=%f&size=medium&mapfilter=true", location.coordinate.longitude, location.coordinate.latitude, location.coordinate.longitude+0.02, location.coordinate.latitude+0.02];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError)
        {
            NSLog(@"Error connecting data from server: %@", connectionError.localizedDescription);
        } else {
            NSLog(@"Response data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            
            NSError *localError = nil;
            if (localError) {
                return;
            }
            
            // parse json
            NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            NSLog(@"photo url: %@", parsedObject[@"photos"][0][@"photo_file_url"]);
            NSURL *url = [[NSURL alloc] initWithString:parsedObject[@"photos"][0][@"photo_file_url"]];
            
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
            [self.upperImage setImage:image];
            [LocationController sharedInstance].locationImage = image;
        }
    }];
}

@end

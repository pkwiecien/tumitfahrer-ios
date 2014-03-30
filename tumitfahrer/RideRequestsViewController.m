//
//  RideRequestsViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 3/29/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RideRequestsViewController.h"
#import "LoginViewController.h"
#import "CustomTextField.h"
#import "ForgotPasswordViewController.h"
#import "RegisterViewController.h"
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

-(id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout])
    {
//        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        NSLog(@"%f", self.collectionView.frame.size.height);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:@"NibCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];
    
    MenuViewController *menuController = [[MenuViewController alloc] init];
    menuController.preferredContentSize = CGSizeMake(180, 0);
    
    
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    _mainView.clipsToBounds = YES;
    _mainView.layer.cornerRadius = 4;
    // Label logo
    UILabel *logo = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 290, 0)];
    logo.backgroundColor = [UIColor clearColor];
    logo.textColor = [UIColor whiteColor];
    logo.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    logo.text = @"Paper";
    [logo sizeToFit];
    // Label Shadow
    [logo setClipsToBounds:NO];
    [logo.layer setShadowOffset:CGSizeMake(0, 0)];
    [logo.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [logo.layer setShadowRadius:1.0];
    [logo.layer setShadowOpacity:0.6];
    [_mainView addSubview:logo];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(aMethod)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Show View" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [_mainView addSubview:button];
    
//    [self.view insertSubview:_mainView belowSubview:self.collectionView];
}

-(void)aMethod
{
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.view insertSubview:_mainView aboveSubview:self.collectionView];

    self.collectionView.decelerationRate = self.class != [RideRequestsViewController class] ? UIScrollViewDecelerationRateNormal : UIScrollViewDecelerationRateFast;
}
-(void)viewDidAppear:(BOOL)animated
{
    BOOL isUserLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];

//    if (!isUserLoggedIn) {
//        [self showLoginScreen:YES];
//  }
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [self nextViewControllerAtPoint:CGPointZero];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionViewController *)nextViewControllerAtPoint:(CGPoint)point
{
    // We could have multiple section stacks and find the right one,
    HACollectionViewLargeLayout *largeLayout = [[HACollectionViewLargeLayout alloc] init];
    HAPaperCollectionViewController *nextCollectionViewController = [[HAPaperCollectionViewController alloc] initWithCollectionViewLayout:largeLayout];
    
    nextCollectionViewController.useLayoutToLayoutNavigationTransitions = YES;
    return nextCollectionViewController;
}

@end

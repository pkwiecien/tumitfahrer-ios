//
//  ActivityRidesViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/1/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "ActivityRidesViewController.h"
#import "RideDetailsViewController.h"
#import "BalancedColumnLayout.h"
#import <QuartzCore/QuartzCore.h>

@interface ActivityRidesViewController () <BalancedColumnLayoutDelegate>

@property (nonatomic, strong) NSMutableDictionary * cellHeights;
@property (nonatomic, strong) NSArray * imageHeights;
@property (nonatomic, strong) NSArray * dataKeys;
@property (nonatomic, strong) NSDictionary * data;
@property (nonatomic, strong) NSCache * imageCache;
@property (nonatomic, assign) CGFloat lastContentOffset;

@end

@implementation ActivityRidesViewController

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
    
    UINib *cellNib = [UINib nibWithNibName:@"BalancedColumnCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"BalancedCell"];
    
    UISwipeGestureRecognizer* swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
    swipeUpGestureRecognizer.delegate = self;
    swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    
    UISwipeGestureRecognizer *swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    swipeDownGestureRecognizer.delegate = self;
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
    swipeRight.numberOfTouchesRequired = 1;
    swipeRight.delegate = self;
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.collectionView addGestureRecognizer:swipeRight];
    
    [self.collectionView addGestureRecognizer:swipeUpGestureRecognizer];
    [self.collectionView addGestureRecognizer:swipeDownGestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Gesture recognizers
- (void)handleSwipeUpFrom:(UIGestureRecognizer*)recognizer {

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (self.lastContentOffset > scrollView.contentOffset.y)
        NSLog(@"scroll up");
    else if (self.lastContentOffset < scrollView.contentOffset.y)
        NSLog(@"scroll down!");
    
    self.lastContentOffset = scrollView.contentOffset.y;
}

- (void)handleSwipeDown:(UIGestureRecognizer*)recognizer {
    CGRect frame = self.departurePlaceView.frame;
    frame.size.height -= 100;
    self.departurePlaceView.frame = frame;
    
    frame = self.collectionView.frame;
    frame.size.height += 100;
    self.collectionView.frame = frame;
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(BalancedColumnLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"BalancedCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RideDetailsViewController *rideDetailsVC = [[RideDetailsViewController alloc] init];
    [self.navigationController pushViewController:rideDetailsVC animated:YES];
}

#pragma mark - SlideNavigation

-(BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}


- (IBAction)menuButtonPressed:(id)sender {
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
}


@end

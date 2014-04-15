//
//  ActivityRidesViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/1/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "ActivityRidesViewController.h"
#import "RideDetailsViewController.h"
#import "CvLayout.h"
#import "RidesStore.h"
#import "Ride.h"
#import <QuartzCore/QuartzCore.h>

@interface ActivityRidesViewController ()

@property (nonatomic, strong) NSMutableDictionary * cellHeights;
@property (nonatomic, strong) NSArray * imageHeights;
@property (nonatomic, strong) NSArray * dataKeys;
@property (nonatomic, strong) NSDictionary * data;
@property (nonatomic, strong) NSCache * imageCache;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) CGRect upperFrame;
@property (nonatomic, assign) CGRect departureLabelFrame;
@property (nonatomic, assign) CGRect lowerFrame;
@property (nonatomic, assign) BOOL isUpperViewSmall;

@end

@implementation ActivityRidesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isUpperViewSmall = NO;
    
    UINib *cellNib = [UINib nibWithNibName:@"AnotherCollectionCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"AnotherCell"];
    
    CvLayout *cvLayout = [[CvLayout alloc] init];
    [self.collectionView setCollectionViewLayout:cvLayout];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    self.departurePlaceView.clipsToBounds = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeViewLarge)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self.departurePlaceView addGestureRecognizer:tapGesture];
}

-(void)makeViewLarge {
    [self makeViewLargeQuickly:NO];
}

-(void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBarHidden = YES;

    if(self.isUpperViewSmall) {
        [self makeViewSmallQuickly:YES];
    }
    else {
        [self makeViewLargeQuickly:YES];
    }
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
    if (self.lastContentOffset < scrollView.contentOffset.y)
    {
        // scroll down
        [self makeViewSmallQuickly:NO];
    }
    
    self.lastContentOffset = scrollView.contentOffset.y;
}

#pragma mark - UICollectionViewDelegate

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

#pragma mark - SlideNavigation

-(BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}

- (IBAction)menuButtonPressed:(id)sender {
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    if(self.upperFrame.size.height > 200)
        self.isUpperViewSmall = NO;
    else
        self.isUpperViewSmall = YES;
}

@end

//
//  ActivityRidesViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/1/14.
//  Animations created by Heberti Almeida on 03/02/14.
//

#import "CampusRidesViewController.h"
#import "HACollectionViewSmallLayout.h"
#import "HACollectionViewLargeLayout.h"
#import "BuildingsManager.h"

#define kTransitionSpeed 0.02f
#define kLargeLayoutScale 2.5F

@interface CampusRidesViewController ()

@property (nonatomic, assign) NSInteger slide;
@property (nonatomic, strong) UIImageView *reflected;
@property (nonatomic, strong) HACollectionViewLargeLayout *largeLayout;
@property (nonatomic, strong) HACollectionViewSmallLayout *smallLayout;
@property (nonatomic, getter=isFullscreen) BOOL fullscreen;
@property (nonatomic, getter=isTransitioning) BOOL transitioning;
@property (nonatomic, assign) BOOL isZooming;
@property (nonatomic, assign) CGFloat lastScale;
@property (weak) UIButton *button2;

//@property (strong, nonatomic) TLTransitionLayout *transitionLayout;
@property (strong, nonatomic) UIPinchGestureRecognizer *pinch;
@property (nonatomic) CGFloat initialScale;


@end

@implementation CampusRidesViewController

@synthesize collectionView = _collectionView;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;

    _slide = 0;
    
    // Custom layouts
    _smallLayout = [[HACollectionViewSmallLayout alloc] init];
    _largeLayout = [[HACollectionViewLargeLayout alloc] init];
    
    _collectionView.collectionViewLayout = _smallLayout;
    

    UINib *cellNib = [UINib nibWithNibName:@"CollectionCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"Cell"];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.collectionViewLayout = _smallLayout;
    _collectionView.clipsToBounds = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    
    // Shadow on collection
    [_collectionView setClipsToBounds:NO];
    [_collectionView.layer setShadowOffset:CGSizeMake(0, 0)];
    [_collectionView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [_collectionView.layer setShadowRadius:6.0];
    [_collectionView.layer setShadowOpacity:0.5];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[BuildingsManager sharedManager] buildingsArray] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 4;
    
    UIImageView *imageLargeCell = (UIImageView *)[cell.contentView viewWithTag:11];
    imageLargeCell.image = [UIImage imageNamed:[[[BuildingsManager sharedManager] buildingsArray] objectAtIndex:indexPath.row]];
    [imageLargeCell setClipsToBounds:YES];
    
    UIImageView *imageSmallCell = (UIImageView *)[cell.contentView viewWithTag:21];
    imageSmallCell.image = [UIImage imageNamed:[[[BuildingsManager sharedManager] buildingsArray] objectAtIndex:indexPath.row]];
    [imageSmallCell setClipsToBounds:YES];
    
    UIView *largeCellView = (UIView *)[cell.contentView viewWithTag:10];
    UIView *smallCellView = (UIView *)[cell.contentView viewWithTag:20];
    
    if (_fullscreen) {
        smallCellView.hidden = YES;
        largeCellView.hidden = NO;
    }
    else
    {
        smallCellView.hidden = NO;
        largeCellView.hidden = YES;
    }
     
    UIButton *joinButton = (UIButton *)[cell.contentView viewWithTag:2];
    joinButton.hidden = !_fullscreen;
    
    UIButton *driverButton = (UIButton *)[cell.contentView viewWithTag:3];
    driverButton.hidden = !_fullscreen;

    [self.view setNeedsDisplay];
    [self.collectionView setNeedsDisplay];
    return cell;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.view sendSubviewToBack:self.collectionView];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Start transition
    _transitioning = YES;
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UIView *largeCellView = (UIView *)[cell.contentView viewWithTag:10];
    UIView *smallCellView = (UIView *)[cell.contentView viewWithTag:20];
    
    if (_fullscreen) {
        // change color of status bar
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

        _fullscreen = NO;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
        
        // [self.button removeFromSuperview];
        
        //[_collectionView snapshotViewAfterScreenUpdates:YES];
        
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // Change flow layout
            [_collectionView setCollectionViewLayout:_smallLayout animated:YES];
            _collectionView.backgroundColor = [UIColor clearColor];
            // Reset scale
//            _mainView.transform = CGAffineTransformMakeScale(1, 1);
       } completion:^(BOOL finished) {
            _transitioning = NO;
            [self.view sendSubviewToBack:self.collectionView];
           
           smallCellView.hidden = NO;
           largeCellView.hidden = YES;
           NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
           [self.collectionView reloadItemsAtIndexPaths:indexPaths];
        }];
    }
    else {
        // change color of status bar
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

        [self.view bringSubviewToFront:self.collectionView];
        [self setNeedsStatusBarAppearanceUpdate];
        
        _fullscreen = YES;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            // Change flow layout
            [_collectionView setCollectionViewLayout:_largeLayout animated:YES];
            _collectionView.backgroundColor = [UIColor blackColor];
            
        } completion:^(BOOL finished) {
            _transitioning = NO;
            
            smallCellView.hidden = YES;
            largeCellView.hidden = NO;
            
            NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
            [self.collectionView reloadItemsAtIndexPaths:indexPaths];
        }];
    }
}

- (CGFloat)transitionRange:(CGFloat)range
{
    return MAX(MIN((range), 1.0), 0.0);
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

# pragma mark - display left menu
-(BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

@end

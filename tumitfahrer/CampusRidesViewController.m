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
    
    UIPinchGestureRecognizer *gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didReceivePinchGesture:)];
    [_collectionView addGestureRecognizer:gesture];
    
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


#pragma mark - Hide StatusBar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark - UIPinchGestureRecognizer
- (void)didReceivePinchGesture:(UIPinchGestureRecognizer*)gesture
{
    NSLog(@"scale %f", gesture.scale);
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 4;

    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Start transition
    _transitioning = YES;
    
    if (_fullscreen) {

        _fullscreen = NO;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
        
        // [self.button removeFromSuperview];
        
        [_collectionView snapshotViewAfterScreenUpdates:YES];
        
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            // Change flow layout
            [_collectionView setCollectionViewLayout:_smallLayout animated:YES];
            _collectionView.backgroundColor = [UIColor clearColor];
            
            // Reset scale
//            _mainView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            _transitioning = NO;
            [self.view sendSubviewToBack:self.collectionView];

        }];
    }
    else {
        [self.view bringSubviewToFront:self.collectionView];
        
        UICollectionViewCell *theCell = [self.collectionView cellForItemAtIndexPath:indexPath];
        self.button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.button2 setTitle:@"Press Me" forState:UIControlStateNormal];
        [self.button2 sizeToFit];
        [theCell addSubview:self.button2];
        [theCell bringSubviewToFront:self.button2];
        [self.button2 setHidden:NO];
        
        _fullscreen = YES;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            // Change flow layout
            [_collectionView setCollectionViewLayout:_largeLayout animated:YES];
            _collectionView.backgroundColor = [UIColor blackColor];
            
        } completion:^(BOOL finished) {
            _transitioning = NO;
        }];
    }
}

-(void)aMethod
{
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

#pragma mark - Gesture Interactions
- (void)doubleFingerTap:(UITapGestureRecognizer *)pinchGestureRecognizer
{
    NSLog(@"tap 2 fingers");
    
    if ([pinchGestureRecognizer state] == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // Transform to zoom in effect
//            _mainView.transform = CGAffineTransformScale(_mainView.transform, 0.96, 0.96);
        } completion:^(BOOL finished) {
            _transitioning = NO;
        }];
    } else if ([pinchGestureRecognizer state] == UIGestureRecognizerStateEnded) {
        // Reset scale
//        _mainView.transform = CGAffineTransformMakeScale(1, 1);
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.view sendSubviewToBack:self.collectionView];
}


- (CGFloat)transitionRange:(CGFloat)range
{
    return MAX(MIN((range), 1.0), 0.0);
}


#pragma mark - UIViewControllerTransitioningDelegate
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

- (IBAction)buttonPressed:(id)sender {
}
- (IBAction)menuButtonPressed:(id)sender {
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
}

# pragma mark - display left menu
-(BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}
@end

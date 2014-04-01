//
//  ActivityRidesViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/1/14.
//  Animations created by Heberti Almeida on 03/02/14.
//

@import UIKit;
#import <SlideNavigationController.h>

@interface CampusRidesViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UIViewControllerTransitioningDelegate, SlideNavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, readonly, getter=isFullscreen) BOOL fullscreen;
@property (nonatomic, readonly, getter=isTransitioning) BOOL transitioning;
@property (weak, nonatomic) IBOutlet UIView *myView;

- (IBAction)buttonPressed:(id)sender;
- (IBAction)menuButtonPressed:(id)sender;

@end

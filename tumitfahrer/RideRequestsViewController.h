//
//  RideRequestsViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 3/29/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SlideNavigationController.h"
#import "HAPaperCollectionViewController.h"
#import "LocationController.h"
#import "RidesStore.h"
#import "PanoramioUtilities.h"

@interface RideRequestsViewController : UIViewController<SlideNavigationControllerDelegate, UICollectionViewDelegate, UIGestureRecognizerDelegate, NSFetchedResultsControllerDelegate, LocationControllerDelegate, RideStoreDelegate, PanoramioUtilitiesDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *upperImage;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIView *departureView;

// RESTkit and core date
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (IBAction)addRideButtonPressed:(id)sender;
- (IBAction)filterRidesButtonPressed:(id)sender;
- (IBAction)menuButtonPressed:(id)sender;

@end

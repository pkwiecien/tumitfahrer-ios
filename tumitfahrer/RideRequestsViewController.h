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

@interface RideRequestsViewController : UIViewController<SlideNavigationControllerDelegate, UICollectionViewDelegate, UIGestureRecognizerDelegate, NSFetchedResultsControllerDelegate, LocationControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *upperImage;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIView *departureView;

// RESTkit and core date
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)addRideButtonPressed:(id)sender;
- (IBAction)filterRidesButtonPressed:(id)sender;
- (IBAction)menuButtonPressed:(id)sender;

@end

//
//  ActivityRidesViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/1/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanoramioUtilities.h"
#import "RidesStore.h"

@interface BrowseRidesViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, PanoramioUtilitiesDelegate, RideStoreDelegate>

@property (nonatomic, strong) NSArray *searchResults;

@property (nonatomic, assign) ContentType RideType;
@property (weak, nonatomic) IBOutlet UIImageView *currentLocationImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentTitle;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *departurePlaceView;
@property (weak, nonatomic) IBOutlet UIView *departureLabelView;

- (instancetype)initWithContentType:(ContentType)contentType;
- (IBAction)menuButtonPressed:(id)sender;
- (IBAction)searchButtonPressed:(id)sender;
- (IBAction)addButtonPressed:(id)sender;


@end

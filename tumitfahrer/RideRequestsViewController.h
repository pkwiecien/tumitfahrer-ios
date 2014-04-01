//
//  RideRequestsViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 3/29/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "HAPaperCollectionViewController.h"

@interface RideRequestsViewController : UIViewController<SlideNavigationControllerDelegate, UICollectionViewDelegate>

- (IBAction)menuButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *upperImage;

@end

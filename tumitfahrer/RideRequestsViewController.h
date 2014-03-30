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

@interface RideRequestsViewController : HAPaperCollectionViewController<SlideNavigationControllerDelegate>

- (IBAction)menuButtonPressed:(id)sender;

- (UICollectionViewController*)nextViewControllerAtPoint:(CGPoint)point;

- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)layout;

@end

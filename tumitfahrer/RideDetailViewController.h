//
//  RideDetailViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ride.h"

@class HeaderContentView;

@interface RideDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>

typedef enum {
    GoBackNormally = 0,
    GoBackToList
} ShouldGoBackEnum;

@property (nonatomic, assign) ShouldDisplayEnum displayEnum;
@property (nonatomic, assign) ShouldGoBackEnum shouldGoBackEnum;
@property (nonatomic, assign) SpecifcRideTypeEnum rideTypeEnum;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerViewLabel;
@property (nonatomic, strong) HeaderContentView *rideDetail;

@property (nonatomic, strong) Ride* ride;

@end

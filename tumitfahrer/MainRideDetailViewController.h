//
//  MainRideDetailViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/14/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeaderContentView, Ride;

@interface MainRideDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) HeaderContentView *rideDetail;
@property (nonatomic, assign) ShouldDisplayEnum displayEnum;
@property (nonatomic, assign) ShouldGoBackEnum shouldGoBackEnum;
@property (strong, nonatomic) NSArray *headerTitles;
@property (nonatomic, strong) Ride* ride;


@end

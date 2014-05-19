//
//  RideDetailViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "RideActionCell.h"
#import "Ride.h"

@class HeaderContentView;

@interface RideDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, DetailsMessagesChoiceCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerViewLabel;
@property (nonatomic, strong) HeaderContentView *rideDetail;

@property (nonatomic, strong) MKMapView *map;
@property (nonatomic, strong) Ride* ride;

@end

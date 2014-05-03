//
//  RideDetailViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "RideDetailView.h"
#import "RideActionCell.h"
#import "Ride.h"

@class RideDetailView;

@interface RideDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, DetailsMessagesChoiceCellDelegate>

@property (nonatomic, strong) RideDetailView *rideDetail;
@property (nonatomic, strong) MKMapView *map;
@property (nonatomic, strong) Ride* ride;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerViewLabel;

@end

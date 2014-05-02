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

@class RideDetailView;

@interface RideDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>

@property (nonatomic, strong) RideDetailView *rideDetail;
@property (nonatomic, strong) MKMapView *map;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerViewLabel;

@end

//
//  RideDetailMapViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/20/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class Ride;

@interface RideDetailMapViewController : UIViewController<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) Ride *selectedRide;

@end

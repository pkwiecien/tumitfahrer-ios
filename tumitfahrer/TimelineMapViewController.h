//
//  TimlineMapViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/14/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GAITrackedViewController.h"

@interface TimelineMapViewController : GAITrackedViewController<MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) TimelineContentType contentType;

@end

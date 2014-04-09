//
//  LocationController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/9/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationControllerDelegate <NSObject>

- (void)didReceiveLocation: (CLLocation*)location;

@end

@interface LocationController : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* location;
@property (nonatomic, weak) id<LocationControllerDelegate> delegate;

+ (LocationController*)sharedInstance; // Singleton method

- (void)startUpdatingLocation;

@end

//
//  PanoramioUtilities.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationController.h"

@protocol PanoramioUtilitiesDelegate <NSObject>

@optional
-(void)didReceivePhotoForCurrentLocation:(UIImage *)image;
-(void)didReceivePhotoForLocation:(UIImage *)image rideId:(NSInteger)rideId;

@end

@interface PanoramioUtilities : NSObject <LocationControllerDelegate>

@property (nonatomic, weak) id<PanoramioUtilitiesDelegate> delegate;

+ (PanoramioUtilities*)sharedInstance; // Singleton method

- (void)addObserver:(id<PanoramioUtilitiesDelegate>) observer;
- (void)notifyWithImage:(UIImage*)image;
- (void)removeObserver:(id<PanoramioUtilitiesDelegate>)observer;

- (void)fetchPhotoForCurrentLocation:(CLLocation*)location;
- (void)fetchPhotoForLocation:(CLLocation*)location rideId:(NSInteger)rideId;

@end

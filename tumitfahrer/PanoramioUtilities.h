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

@class Photo;

/**
 *  Protocol for notyfing about fetching a photo
 */
@protocol PanoramioUtilitiesDelegate <NSObject>

@optional
/**
 *  Notifies about fetching an image for current location
 *
 *  @param image Image for current location.
 */
-(void)didReceivePhotoForCurrentLocation:(UIImage *)image;
/**
 *  Notifies about fetching an image for the destination of the given ride.
 *
 *  @param image  Fetched image.
 *  @param rideId Id of the ride.
 */
-(void)didReceivePhotoForLocation:(UIImage *)image rideId:(NSNumber *)rideId;

@end

/**
 *  Handles fetching photos from the Panoramio API.
 */
@interface PanoramioUtilities : NSObject <LocationControllerDelegate>

@property (nonatomic, weak) id<PanoramioUtilitiesDelegate> delegate;

typedef void(^photoCompletionHandler)(Photo *);

+ (PanoramioUtilities*)sharedInstance; // Singleton method

/**
 *  Adds observer to the Panoramio Utilities.
 *
 *  @param observer The Observer object
 */
- (void)addObserver:(id<PanoramioUtilitiesDelegate>) observer;
/**
 *  Notifies observers about fetching an image for the location.
 *
 *  @param image Image of the location.
 */
- (void)notifyWithImage:(UIImage*)image;
/**
 *  Notifies observers about fetching an image for the destination of the given ride.
 *
 *  @param image  Image object.
 *  @param rideId Id of the ride.
 */
- (void)notifyAllAboutNewImage:(UIImage *)image rideId:(NSNumber *)rideId;
/**
 *  Removes obserers from the Panoramio Utilities
 *
 *  @param observer The Observer object.
 */
- (void)removeObserver:(id<PanoramioUtilitiesDelegate>)observer;

/**
 *  Asynchronously fetches a photo for the given location.
 *
 *  @param location Location for which the photo should be fetched.
 *  @param block    The completion handler with the photo 
 */
- (void)fetchPhotoForLocation:(CLLocation *)location completionHandler:(photoCompletionHandler)block;

@end

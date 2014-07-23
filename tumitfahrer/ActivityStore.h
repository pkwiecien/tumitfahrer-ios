//
//  ActivityStore.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationController.h"

@class Ride, Request;

/**
 *  The protocol that informs the delegates when new activities are received from the webservice.
 */
@protocol ActivityStoreDelegate <NSObject>

@optional

/**
 *  Inform a delegate that activities were received from the webservice.
 */
- (void)didRecieveActivitiesFromWebService;

@end

/**
 *  ActivityStore is responsible for handling all activities that are displayed in the Timelines. Specifically, the class fetches activities from the webservice, can update and delete specific activities from the local store and can load the activities from the core data.
 */
@interface ActivityStore : NSObject <LocationControllerDelegate>

+ (instancetype)sharedStore;

@property (nonatomic, strong) id <ActivityStoreDelegate> delegate;

/**
 *  Fetches activities from the webservice.
 *
 *  @param block completion handler to notify a requestor once the fetch is completed
 */
- (void)fetchActivitiesFromWebservice:(boolCompletionHandler)block;

/**
 *  Returns all timeline activities filtered by the given type.
 *
 *  @param contentType The type of timeline acitvities, such as nearby or user's activities
 *
 *  @return all activities filter by the contentType
 */
- (NSArray *)recentActivitiesByType:(TimelineContentType)contentType;

/**
 *  Read all activities from the core data.
 */
- (void)initAllActivitiesFromCoreData;

/**
 *  Deletes a specific ride from the timeline activities.
 *
 *  @param ride The ride object.
 */
- (void)deleteRideFromActivites:(Ride *)ride;

/**
 *  Deletes a specific request from the timeline activities.
 *
 *  @param request The request object.
 */
- (void)deleteRequestFromActivites:(Request *)request;

/**
 *  Updates timeline activities by fetching them from webservice.
 */
- (void)updateActivities;

@end

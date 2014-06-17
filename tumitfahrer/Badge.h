//
//  Badge.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/17/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Badge : NSManagedObject

@property (nonatomic, retain) NSNumber * timelineBadge;
@property (nonatomic, retain) NSNumber * campusBadge;
@property (nonatomic, retain) NSNumber * badgeId;
@property (nonatomic, retain) NSNumber * activityBadge;
@property (nonatomic, retain) NSNumber * myRidesBadge;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * activityUpdatedAt;
@property (nonatomic, retain) NSDate * campusUpdatedAt;
@property (nonatomic, retain) NSDate * myRidesUpdatedAt;
@property (nonatomic, retain) NSDate * timelineUpdatedAt;

@end

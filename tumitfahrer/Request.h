//
//  Request.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/25/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ride;

@interface Request : NSManagedObject

@property (nonatomic, retain) NSNumber * requestId;
@property (nonatomic, retain) NSNumber * passengerId;
@property (nonatomic, retain) NSString * requestedFrom;
@property (nonatomic, retain) NSString * requestedTo;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) Ride *requestedRide;

@end

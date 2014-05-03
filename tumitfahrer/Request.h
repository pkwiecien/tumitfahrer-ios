//
//  Request.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/26/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ride;

@interface Request : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic) int32_t passengerId;
@property (nonatomic, retain) NSString * requestedFrom;
@property (nonatomic, retain) NSString * requestedTo;
@property (nonatomic) int32_t requestId;
@property (nonatomic, retain) NSDate *updatedAt;
@property (nonatomic, retain) Ride *requestedRide;

@end

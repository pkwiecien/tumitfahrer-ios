//
//  RecentPlace.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/18/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RecentPlace : NSManagedObject

@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) NSNumber * placeId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * placeLatitude;
@property (nonatomic, retain) NSNumber * placeLongitude;

@end

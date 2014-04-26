//
//  User.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/25/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FriendRequest, Message, Rating, Ride, User;

@interface User : NSManagedObject


@property (nonatomic, retain) NSString * apiKey;
@property (nonatomic, retain) NSString * car;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * department;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic) BOOL isStudent;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic) int userId;
@property (nonatomic, retain) NSSet *ridesAsDriver;
@property (nonatomic, retain) NSSet *ridesAsPassenger;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addRidesAsDriverObject:(Ride *)value;
- (void)removeRidesAsDriverObject:(Ride *)value;
- (void)addRidesAsDriver:(NSSet *)values;
- (void)removeRidesAsDriver:(NSSet *)values;

- (void)addRidesAsPassengerObject:(Ride *)value;
- (void)removeRidesAsPassengerObject:(Ride *)value;
- (void)addRidesAsPassenger:(NSSet *)values;
- (void)removeRidesAsPassenger:(NSSet *)values;


@end

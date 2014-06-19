//
//  User.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/19/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ride;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * apiKey;
@property (nonatomic, retain) NSString * car;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * department;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * isStudent;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSData * profileImageData;
@property (nonatomic, retain) NSNumber * ratingAvg;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSSet *ridesAsOwner;
@property (nonatomic, retain) NSSet *ridesAsPassenger;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addRidesAsOwnerObject:(Ride *)value;
- (void)removeRidesAsOwnerObject:(Ride *)value;
- (void)addRidesAsOwner:(NSSet *)values;
- (void)removeRidesAsOwner:(NSSet *)values;

- (void)addRidesAsPassengerObject:(Ride *)value;
- (void)removeRidesAsPassengerObject:(Ride *)value;
- (void)addRidesAsPassenger:(NSSet *)values;
- (void)removeRidesAsPassenger:(NSSet *)values;

@end

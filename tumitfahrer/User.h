//
//  User.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/26/14.
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
@property (nonatomic, retain) NSSet *friendRequestsReceived;
@property (nonatomic, retain) FriendRequest *friendRequestsSent;
@property (nonatomic, retain) NSSet *friends;
@property (nonatomic, retain) NSSet *messagesReceived;
@property (nonatomic, retain) NSSet *messagesSent;
@property (nonatomic, retain) NSSet *ratingsGiven;
@property (nonatomic, retain) NSSet *ratingsReceived;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addFriendRequestsReceivedObject:(FriendRequest *)value;
- (void)removeFriendRequestsReceivedObject:(FriendRequest *)value;
- (void)addFriendRequestsReceived:(NSSet *)values;
- (void)removeFriendRequestsReceived:(NSSet *)values;

- (void)addFriendsObject:(User *)value;
- (void)removeFriendsObject:(User *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;

- (void)addMessagesReceivedObject:(Message *)value;
- (void)removeMessagesReceivedObject:(Message *)value;
- (void)addMessagesReceived:(NSSet *)values;
- (void)removeMessagesReceived:(NSSet *)values;

- (void)addMessagesSentObject:(Message *)value;
- (void)removeMessagesSentObject:(Message *)value;
- (void)addMessagesSent:(NSSet *)values;
- (void)removeMessagesSent:(NSSet *)values;

- (void)addRatingsGivenObject:(Rating *)value;
- (void)removeRatingsGivenObject:(Rating *)value;
- (void)addRatingsGiven:(NSSet *)values;
- (void)removeRatingsGiven:(NSSet *)values;

- (void)addRatingsReceivedObject:(Rating *)value;
- (void)removeRatingsReceivedObject:(Rating *)value;
- (void)addRatingsReceived:(NSSet *)values;
- (void)removeRatingsReceived:(NSSet *)values;

- (void)addRidesAsDriverObject:(Ride *)value;
- (void)removeRidesAsDriverObject:(Ride *)value;
- (void)addRidesAsDriver:(NSSet *)values;
- (void)removeRidesAsDriver:(NSSet *)values;

- (void)addRidesAsPassengerObject:(Ride *)value;
- (void)removeRidesAsPassengerObject:(Ride *)value;
- (void)addRidesAsPassenger:(NSSet *)values;
- (void)removeRidesAsPassenger:(NSSet *)values;

@end

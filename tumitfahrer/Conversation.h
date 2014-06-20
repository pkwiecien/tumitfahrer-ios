//
//  Conversation.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/20/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Message, Ride;

@interface Conversation : NSManagedObject

@property (nonatomic, retain) NSNumber * conversationId;
@property (nonatomic, retain) NSNumber * otherUserId;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * rideId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *messages;
@property (nonatomic, retain) Ride *ride;
@end

@interface Conversation (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(Message *)value;
- (void)removeMessagesObject:(Message *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

@end

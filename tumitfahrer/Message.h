//
//  Message.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/21/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Conversation;

@interface Message : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * isSeen;
@property (nonatomic, retain) NSNumber * messageId;
@property (nonatomic, retain) NSNumber * receiverId;
@property (nonatomic, retain) NSNumber * senderId;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) Conversation *conversation;

@end

//
//  Message.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/26/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Message : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic) BOOL isSeen;
@property (nonatomic) int32_t messageId;
@property (nonatomic) NSTimeInterval updatedAt;
@property (nonatomic, retain) User *receivedMessage;
@property (nonatomic, retain) User *sentMessage;

@end

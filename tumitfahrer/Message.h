//
//  Message.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/25/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Message : NSManagedObject

@property (nonatomic, retain) NSNumber * messageId;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * isSeen;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) User *sentMessage;
@property (nonatomic, retain) User *receivedMessage;

@end

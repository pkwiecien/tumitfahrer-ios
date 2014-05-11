//
//  Message.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Message : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * isSeen;
@property (nonatomic, retain) NSNumber * messageId;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) User *receivedMessage;
@property (nonatomic, retain) User *sentMessage;

@end

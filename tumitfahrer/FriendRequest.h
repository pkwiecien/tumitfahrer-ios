//
//  FriendRequest.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/26/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface FriendRequest : NSManagedObject

@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic) int32_t requestId;
@property (nonatomic) NSTimeInterval updatedAt;
@property (nonatomic, retain) User *receivedFriendRequest;
@property (nonatomic, retain) User *sentFriendRequest;

@end

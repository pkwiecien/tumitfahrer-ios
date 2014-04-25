//
//  FriendRequest.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/25/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface FriendRequest : NSManagedObject

@property (nonatomic, retain) NSNumber * requestId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) User *receivedFriendRequest;
@property (nonatomic, retain) User *sentFriendRequest;

@end

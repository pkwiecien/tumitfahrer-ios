//
//  WebserviceRequest.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Conversation, Message;

@interface WebserviceRequest : NSObject

+(void)getConversationsForRideId:(NSInteger)rideId block:(boolCompletionHandler)block;

typedef void(^messageCompletionHandler)(Message *);

+(void)postMessageForConversation:(Conversation *)conversation message:(NSString *)message senderId:(NSNumber *)senderId receiverId:(NSNumber *)receiverId rideId:(NSNumber *)rideId block:(messageCompletionHandler)block;

+(void)getPastRidesForCurrentUserWithBlock:(arrayCompletionHandler)block;

@end

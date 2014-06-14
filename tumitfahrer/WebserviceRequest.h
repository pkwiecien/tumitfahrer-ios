//
//  WebserviceRequest.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Conversation, Message, User, Request;

@interface WebserviceRequest : NSObject

+(void)getConversationsForRideId:(NSInteger)rideId block:(boolCompletionHandler)block;

typedef void(^messageCompletionHandler)(Message *);
typedef void(^userCompletionHandler)(User *);


+(void)postMessageForConversation:(Conversation *)conversation message:(NSString *)message senderId:(NSNumber *)senderId receiverId:(NSNumber *)receiverId rideId:(NSNumber *)rideId block:(messageCompletionHandler)block;

+(void)getPastRidesForCurrentUserWithBlock:(arrayCompletionHandler)block;
+(void)getUserWithId:(NSNumber *)userId block:(userCompletionHandler)block;
+(void)acceptRideRequest:(Request *)request isConfirmed:(BOOL)isConfirmed block:(boolCompletionHandler)block;
+(void)removePassengerWithId:(NSNumber *)passengerId rideId:(NSNumber *)rideId block:(boolCompletionHandler)block;
+(void)removeRequestForRideId:(NSNumber *)rideId request:(Request *)request block:(boolCompletionHandler)block;
+(void)getUserWithIdFromWebService:(NSNumber *)userId block:(userCompletionHandler)block;

@end

//
//  WebserviceRequest.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Conversation, Message, User, Request, Badge;

@interface WebserviceRequest : NSObject


typedef void(^messageCompletionHandler)(Message *);
typedef void(^userCompletionHandler)(User *);
typedef void(^badgeCompletionHandler)(Badge *);
typedef void(^conversationCompletionHandler)(Conversation *);

+(void)getConversationsForRideId:(NSInteger)rideId block:(boolCompletionHandler)block;
+(void)getConversationForRideId:(NSNumber *)rideId conversationId:(NSNumber *)conversationId block:(boolCompletionHandler)block;
+(void)createConversationsForRideId:(NSNumber *)rideId userId:(NSNumber *)userId otherUserId:(NSNumber *)otherUserId block:(conversationCompletionHandler)block;

+(void)postMessageForConversation:(Conversation *)conversation message:(NSString *)message senderId:(NSNumber *)senderId receiverId:(NSNumber *)receiverId rideId:(NSNumber *)rideId block:(messageCompletionHandler)block;

+(void)getPastRidesForCurrentUserWithBlock:(arrayCompletionHandler)block;
+(void)getUserWithId:(NSNumber *)userId block:(userCompletionHandler)block;
+(void)acceptRideRequest:(Request *)request isConfirmed:(BOOL)isConfirmed block:(boolCompletionHandler)block;
+(void)removePassengerWithId:(NSNumber *)passengerId rideId:(NSNumber *)rideId block:(boolCompletionHandler)block;
+(void)removeRequestForRideId:(NSNumber *)rideId request:(Request *)request block:(boolCompletionHandler)block;
+(void)getUserWithIdFromWebService:(NSNumber *)userId block:(userCompletionHandler)block;

+(void)getBadgeCounterForUserId:(NSNumber *)userId block:(badgeCompletionHandler)block;

+(void)giveRatingToUserWithId:(NSNumber *)otherUserId rideId:(NSNumber *)rideId ratingType:(BOOL)ratingType block:(boolCompletionHandler)block;

@end

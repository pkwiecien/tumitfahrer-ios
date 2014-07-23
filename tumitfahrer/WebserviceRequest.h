//
//  WebserviceRequest.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Conversation, Message, User, Request, Badge, Ride;

/**
 *  Class that handles requests to the webservice.
 */
@interface WebserviceRequest : NSObject

typedef void(^messageCompletionHandler)(Message *);
typedef void(^userCompletionHandler)(User *);
typedef void(^badgeCompletionHandler)(Badge *);
typedef void(^conversationCompletionHandler)(Conversation *);
typedef void(^requestCompletionHandler)(Request *);

/**
 *  Asynchronously fetches conversations for the given ride.
 *
 *  @param rideId Id of the ride.
 *  @param block  The completion handler. YES if fetched successfully.
 */
+(void)getConversationsForRideId:(NSInteger)rideId block:(boolCompletionHandler)block;
/**
 *  Asynchronously fetches single conversation for the given ride.
 *
 *  @param rideId Id of the ride.
 *  @param conversationId Id of the conversation
 *  @param block  The completion handler. YES if fetched successfully.
 */
+(void)getConversationForRideId:(NSNumber *)rideId conversationId:(NSNumber *)conversationId block:(boolCompletionHandler)block;
/**
 *  Create on the server a conversation for the given ride.
 *
 *  @param rideId      Id of the ride.
 *  @param userId      Id of first user.
 *  @param otherUserId If of the other user.
 *  @param block       The completion handler with the conversation object.
 */
+(void)createConversationsForRideId:(NSNumber *)rideId userId:(NSNumber *)userId otherUserId:(NSNumber *)otherUserId block:(conversationCompletionHandler)block;
/**
 *  Creates a message for the given conversation.
 *
 *  @param conversation The Conversation object
 *  @param message      String with message
 *  @param senderId     Id of sender
 *  @param receiverId   Id of receiver
 *  @param rideId       Id of the ride
 *  @param block        The completion handler with the message.
 */
+(void)postMessageForConversation:(Conversation *)conversation message:(NSString *)message senderId:(NSNumber *)senderId receiverId:(NSNumber *)receiverId rideId:(NSNumber *)rideId block:(messageCompletionHandler)block;

/**
 *  Gets past ride for the current user
 *
 *  @param block The completion handler with array of past rides.
 */
+(void)getPastRidesForCurrentUserWithBlock:(arrayCompletionHandler)block;
/**
 *  Gets user with the given id. Checks if he's in core data, if not then fetches from webservice.
 *
 *  @param userId Id of the requested user
 *  @param block  The completion handler with the user object.
 */
+(void)getUserWithId:(NSNumber *)userId block:(userCompletionHandler)block;
/**
 *  Accepts/declines ride request on the server.
 *
 *  @param request     The request object
 *  @param isConfirmed Status (true if confirmed).
 *  @param block       The completion handler. YES if successfully completed action.
 */
+(void)acceptRideRequest:(Request *)request isConfirmed:(BOOL)isConfirmed block:(boolCompletionHandler)block;
/**
 *  Removes passenger from the ride.
 *
 *  @param passengerId Id of the passenger
 *  @param rideId      Id of the ride
 *  @param block       The completion handler. YES if successfully completed action.
 */
+(void)removePassengerWithId:(NSNumber *)passengerId rideId:(NSNumber *)rideId block:(boolCompletionHandler)block;
/**
 *  Adds passenger to the ride.
 *
 *  @param passengerId Id of the passenger
 *  @param rideId      Id of the ride
 *  @param block       The completion handler. YES if successfully completed action.
 */
+(void)addPassengerWithId:(NSNumber *)passengerId rideId:(NSNumber *)rideId block:(boolCompletionHandler)block;
/**
 *  Removes a request for the given ride.
 *
 *  @param rideId  Id of the ride.
 *  @param request The request object
 *  @param block The completion handler. YES if successfully completed action.
 */
+(void)removeRequestForRideId:(NSNumber *)rideId request:(Request *)request block:(boolCompletionHandler)block;
/**
 *  Gets user with the given id from webservice.
 *
 *  @param userId Id of the user
 *  @param block The completion handler with the user object.
 */
+(void)getUserWithIdFromWebService:(NSNumber *)userId block:(userCompletionHandler)block;

/**
 *  Gets counter in badges for the given user.
 *
 *  @param userId Id of the
 *  @param block The completion handler with the badge counter object.
 */
+(void)getBadgeCounterForUserId:(NSNumber *)userId block:(badgeCompletionHandler)block;

/**
 *  Gives rating to the other user.
 *
 *  @param otherUserId Id of the other user.
 *  @param rideId      Id of the ride.
 *  @param ratingType  Type of rating
 *  @param block       The completion handler. True if rating successfully given.
 */
+(void)giveRatingToUserWithId:(NSNumber *)otherUserId rideId:(NSNumber *)rideId ratingType:(BOOL)ratingType block:(boolCompletionHandler)block;
/**
 *  Delete a ride from webservice.
 *
 *  @param ride  The ride object
 *  @param block The completion handler. True if deleted.
 */
+(void)deleteRideFromWebservice:(Ride *)ride block:(boolCompletionHandler)block;
/**
 *  Gets a specific ride request for the given ride.
 *
 *  @param rideId    Id of the ride.
 *  @param requestId Id of the specific request
 *  @param block     The completion handler with the request object.
 */
+(void)getRequestForRideId:(NSNumber *)rideId requestId:(NSNumber *)requestId block:(requestCompletionHandler)block;
@end

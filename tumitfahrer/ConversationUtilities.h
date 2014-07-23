//
//  ConversationUtilities.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/20/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User, Conversation;

/**
 *  Class that handles and manages conversations of the ride.
 */
@interface ConversationUtilities : NSObject

/**
 *  Finds a conversation in the array of conversation between user and ohter user.
 *
 *  @param user          The User object.
 *  @param otherUser     The other User object.
 *  @param conversations Array with conversation.
 *
 *  @return The specific conversation.
 */
+(Conversation *)findConversationBetweenUser:(User *)user otherUser:(User *)otherUser conversationArray:(NSArray *)conversations;
/**
 *  Fetches a conversation from the core data.
 *
 *  @param conversationId Id of the conversation.
 *
 *  @return Fetched conversation.
 */
+ (Conversation *)fetchConversationFromCoreDataWithId:(NSNumber *)conversationId;

/**
 *  Fetches conversation from core data between two users for a give ride.
 *
 *  @param userId      Id of first user.
 *  @param otherUserId Id of the other user.
 *  @param rideId      Id of the ride.
 *
 *  @return The specific conversation.
 */
+ (Conversation *)fetchConversationFromCoreDataBetweenUserId:(NSNumber *)userId otherUserId:(NSNumber *)otherUserId rideId:(NSNumber *)rideId;

/**
 *  Checks whether the conversation has any unseen messages.
 *
 *  @param conversation The conversation object.
 *
 *  @return True if conversation has any unseen message.
 */
+ (BOOL)conversationHasUnseenMessages:(Conversation *)conversation;

/**
 *  Updated time when the conversation was last seen.
 *
 *  @param conversation The Conversation object.
 */
+ (void)updateSeenTimeForConversation:(Conversation *)conversation;

/**
 *  Saves updated conversation in the core data.
 *
 *  @param conversation The conversation object.
 */
+ (void)saveConversationToPersistentStore:(Conversation *)conversation;

@end

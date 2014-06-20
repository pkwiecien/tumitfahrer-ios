//
//  ConversationUtilities.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/20/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User, Conversation;

@interface ConversationUtilities : NSObject

+(Conversation *)findConversationBetweenUser:(User *)user otherUser:(User *)otherUser conversationArray:(NSArray *)conversations;
+ (Conversation *)fetchConversationFromCoreDataWithId:(NSNumber *)conversationId;

@end

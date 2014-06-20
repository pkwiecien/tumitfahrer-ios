//
//  ConversationUtilities.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/20/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "ConversationUtilities.h"
#import "Conversation.h"
#import "User.h"

@implementation ConversationUtilities

+(Conversation *)findConversationBetweenUser:(User *)user otherUser:(User *)otherUser conversationArray:(NSArray *)conversations {
    
    for (Conversation *conversation in conversations) {
        if (([conversation.userId isEqualToNumber:user.userId] && [conversation.otherUserId isEqualToNumber:otherUser.userId]) || ([conversation.userId isEqualToNumber:otherUser.userId] && [conversation.otherUserId isEqualToNumber:user.userId])) {
            return conversation;
        }
    }
    return nil;
}


+ (Conversation *)fetchConversationFromCoreDataWithId:(NSNumber *)conversationId {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Conversation"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"conversationId = %@", conversationId];
    [request setPredicate:predicate];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES];
    request.sortDescriptors = @[descriptor];
    
    request.entity = e;
    
    NSError *error;
    NSArray *fetchedObjects = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!fetchedObjects) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    return [fetchedObjects firstObject];
}

@end

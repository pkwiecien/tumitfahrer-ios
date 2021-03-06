//
//  ConversationMapping.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConversationMapping : NSObject

+(RKEntityMapping *)conversationMapping;
+(RKEntityMapping *)simpleConversationMapping;
+(RKResponseDescriptor *)getConversationsResponseDescriptorWithMapping:(RKEntityMapping *)mapping;
+(RKResponseDescriptor *)getConversationResponseDescriptorWithMapping:(RKEntityMapping *)mapping;
+(RKResponseDescriptor *)postConversationResponseDescriptorWithMapping:(RKEntityMapping *)mapping;

@end

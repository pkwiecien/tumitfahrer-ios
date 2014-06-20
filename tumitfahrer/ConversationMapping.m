//
//  ConversationMapping.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "ConversationMapping.h"
#import "MessageMapping.h"
#import "RideMapping.h"

@implementation ConversationMapping

+(RKEntityMapping *)conversationMapping {
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Conversation" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    mapping.identificationAttributes = @[@"conversationId"];
    [mapping addAttributeMappingsFromDictionary:@{    @"id": @"conversationId",
                                                      @"user_id": @"userId",
                                                      @"ride_id": @"rideId",
                                                      @"other_user_id": @"otherUserId",
                                                      @"created_at": @"createdAt",
                                                      @"updated_at": @"updatedAt"
                                                      }];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"messages" toKeyPath:@"messages" withMapping:[MessageMapping messageMapping]]];
    
    return mapping;
}

+(RKResponseDescriptor *)getConversationsResponseDescriptorWithMapping:(RKEntityMapping *)mapping {
    // create response description for rides
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodGET pathPattern:API_RIDES_CONVERSATIONS keyPath:@"conversations"                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

+(RKResponseDescriptor *)getConversationResponseDescriptorWithMapping:(RKEntityMapping *)mapping {
    // create response description for rides
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodGET pathPattern:API_RIDES_CONVERSATION keyPath:@"conversation"                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

@end

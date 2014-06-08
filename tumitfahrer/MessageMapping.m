//
//  MessageMapping.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "MessageMapping.h"

@implementation MessageMapping

+(RKEntityMapping *)messageMapping {
    
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Message" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    mapping.identificationAttributes = @[@"messageId"];
    [mapping addAttributeMappingsFromDictionary:@{      @"id": @"messageId",
                                                        @"content":@"content",
                                                        @"is_seen":@"isSeen",
                                                        @"receiver_id": @"receiverId",
                                                        @"sender_id": @"senderId",
                                                        @"created_at": @"createdAt",
                                                        @"updated_at": @"updatedAt"
                                                        }];

    return mapping;
}

+ (RKResponseDescriptor *)postMessageResponseDescriptorWithMapping:(RKEntityMapping*)mapping {
    // create response description for user's session
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodPOST                                                                                       pathPattern:API_RIDES_CONVERSATIONS_MES                                                                                           keyPath:@"message"                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

@end

//
//  StomtMapping.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 7/26/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "StomtMapping.h"

@implementation StomtMapping


+(RKEntityMapping *)stomtMapping {
    
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Stomt" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    mapping.identificationAttributes = @[@"stomtId"];
    [mapping addAttributeMappingsFromDictionary:@{    @"id": @"stomtId",
                                                      @"text":@"text",
                                                      @"lang":@"language",
                                                      @"negative":@"isNegative",
                                                      @"counter":@"counter",
                                                      @"creator": @"creator",
                                                      @"created_at":@"createdAt",
                                                      }];
    return mapping;
}

+(RKResponseDescriptor *)getStomtsResponseDescriptorWithMapping:(RKEntityMapping *)mapping {
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return responseDescriptor;
}


+(RKResponseDescriptor *)postStomtResponseDescriptorWithMapping:(RKObjectMapping *)mapping {
    // create response description for user's session
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodPOST                                                                                       pathPattern:@"/stomt"                                                                                           keyPath:nil                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

@end

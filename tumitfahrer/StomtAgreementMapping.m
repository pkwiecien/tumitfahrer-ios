//
//  StomtAgreementMapping.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 7/30/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "StomtAgreementMapping.h"
#import "StatusMapping.h"

@implementation StomtAgreementMapping

+(RKEntityMapping *)agreementMapping {
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"StomtAgreement" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    mapping.identificationAttributes = @[@"agreementId"];
    [mapping addAttributeMappingsFromDictionary:@{    @"id": @"agreementId",
                                                      @"negative":@"isNegative",
                                                      @"creator": @"creator",
                                                      }];
    
    return mapping;

}

+(RKResponseDescriptor *)postAgreementResponseDescriptorWithMapping:(RKObjectMapping *)mapping {
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodPOST                                                                                       pathPattern:@"/agreement"                                                                                           keyPath:@"data"                                                                                      statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

+(RKObjectMapping *)deleteStomtAgreementMapping {
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[StatusMapping class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"data":@"data"}];
    return responseMapping;
}

+(RKResponseDescriptor *)deleteStomtAgreementResponseDescriptorWithMapping:(RKObjectMapping *)mapping {
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodDELETE                                                                                   pathPattern:@"/agreement/:agreementId"                                                                                           keyPath:@"meta"                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

@end

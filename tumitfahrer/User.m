//
//  User.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "User.h"
#import "Ride.h"
#import "StatusResponse.h"


@implementation User

@dynamic apiKey;
@dynamic car;
@dynamic createdAt;
@dynamic department;
@dynamic email;
@dynamic firstName;
@dynamic isStudent;
@dynamic lastName;
@dynamic password;
@dynamic phoneNumber;
@dynamic updatedAt;
@dynamic userId;
@dynamic ridesAsDriver;
@dynamic ridesAsPassenger;

+ (RKEntityMapping *)postSessionMapping {
    RKEntityMapping *sessionMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    //    sessionMapping.identificationAttributes = @[ @"userId" ];
    [sessionMapping addAttributeMappingsFromDictionary:@{
                                                         @"id":             @"userId",
                                                         @"first_name":     @"firstName",
                                                         @"last_name":      @"lastName",
                                                         @"email":          @"email",
                                                         @"is_student":     @"isStudent",
                                                         @"phone_number":   @"phoneNumber",
                                                         @"car":            @"car",
                                                         @"department":     @"department",
                                                         @"api_key":        @"apiKey",
                                                         @"created_at":     @"createdAt",
                                                         @"updated_at":     @"updatedAt"}];
    
    return sessionMapping;
}

+ (RKResponseDescriptor *)postSessionResponseDescriptorWithMapping:(RKEntityMapping*)mapping {
    // create response description for user's session
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodPOST                                                                                       pathPattern:@"/api/v2/sessions"                                                                                           keyPath:@"user"                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

+(RKObjectMapping *)postUserMapping {
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[StatusResponse class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"message":@"message"}];
    
    return responseMapping;
}

+(RKResponseDescriptor *)postUserResponseDescriptorWithMapping:(RKObjectMapping *)mapping {
    // create response description for user's session
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodPOST                                                                                       pathPattern:@"/api/v2/users"                                                                                           keyPath:nil                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

@end

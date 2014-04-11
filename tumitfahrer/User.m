//
//  User.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "User.h"
#import "Ride.h"
#import "StatusMapping.h"


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

-(NSString *)description {
    return [NSString stringWithFormat:@"%@ %@, email: %@, id: %d", self.firstName, self.lastName, self.email, self.userId];
}

@end

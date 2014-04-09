//
//  CurrentUser.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "CurrentUser.h"

@implementation CurrentUser

-(instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

+(instancetype)sharedInstance {
    static CurrentUser *currentUser = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        currentUser = [[self alloc] init];
    });
    
    return currentUser;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"Name: %@ %@, email: %@, registered at: %@", self.user.firstName, self.user.lastName, self.user.email, self.user.createdAt];
}

@end
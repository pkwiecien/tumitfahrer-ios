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

+ (BOOL)fetchUserWithEmail:(NSString *)email {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"User"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(email = %@)", email];
    [request setPredicate:predicate];
    request.entity = e;
    
    NSError *error;
    NSArray *result = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    
    User *user = (User *)[result firstObject];
    if(user) {
        [CurrentUser sharedInstance].user = user;
        return true;
    }
    return false;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"Name: %@ %@, email: %@, registered at: %@", self.user.firstName, self.user.lastName, self.user.email, self.user.createdAt];
}

@end
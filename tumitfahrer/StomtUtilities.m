//
//  StomtUtilities.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 7/26/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "StomtUtilities.h"
#import "AppDelegate.h"
#import "CurrentUser.h"
#import "Stomt.h"

@implementation StomtUtilities

+(void)getAllStomtsWithCompletionHandler:(boolCompletionHandler)block {
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [delegate.stomtObjectManager.HTTPClient setDefaultHeader:@"thirdpartyid" value:@"changeme"];
    [delegate.stomtObjectManager.HTTPClient setDefaultHeader:@"thirdpartysecret" value:@"changeme"];
    [delegate.stomtObjectManager.HTTPClient setDefaultHeader:@"userid" value:[[CurrentUser sharedInstance].user.userId stringValue]];
    
    [delegate.stomtObjectManager getObjectsAtPath:@"/target/57a85f3d7fc19d09790533aa1" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        NSArray *stomts = [mappingResult array];
        for (Stomt *stomt in stomts) {
            NSLog(@"stomt with id: %@ and text %@, created at: %@", stomt.stomtId, stomt.text, stomt.createdAt);
        }
        block(YES);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Could not received photo with error: %@", error);
        block(NO);
    }];
}

+(void)postStomtWithText:(NSString *)text isNegative:(NSNumber *)isNegative boolCompletionHandler:(boolCompletionHandler)block {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSDictionary *queryParams = @{@"target_hashid": @"57a85f3d7fc19d09790533aa1", @"negative" : isNegative, @"text":text, @"lang" : @"en", @"anonym" : [NSNumber numberWithInt:1]};
    
    [delegate.stomtObjectManager postObject:nil path:@"/stomt" parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        Stomt *stomt = [mappingResult firstObject];
        block(YES);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        block(NO);
    }];
}

+(NSArray *)fetchStomtsFromCoreData {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Stomt"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    request.sortDescriptors = @[descriptor];
    request.entity = e;
    
    NSError *error;
    NSArray *fetchedObjects = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!fetchedObjects) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    return [[NSMutableArray alloc] initWithArray:fetchedObjects];
}

@end

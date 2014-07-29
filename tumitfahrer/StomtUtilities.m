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
#import "Constants.h"
#import "StatusMapping.h"

@implementation StomtUtilities

+(void)getAllStomtsWithCompletionHandler:(boolCompletionHandler)block {
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [delegate.stomtObjectManager.HTTPClient setDefaultHeader:@"thirdpartyid" value:thirdpartyid];
    [delegate.stomtObjectManager.HTTPClient setDefaultHeader:@"thirdpartysecret" value:thirdpartysecret];
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
    
    NSError *error;
    NSString *jsonString = @"";
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:queryParams options:NSJSONWritingPrettyPrinted error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *restkitRequest = [delegate.stomtObjectManager requestWithObject:nil method:RKRequestMethodGET path:@"/stomt" parameters:queryParams];
    [restkitRequest setValue:thirdpartysecret forHTTPHeaderField:@"thirdpartysecret"];
    [restkitRequest setValue:thirdpartyid forHTTPHeaderField:@"thirdpartyid"];
    [restkitRequest setValue:[[CurrentUser sharedInstance].user.userId stringValue] forHTTPHeaderField:@"userid"];
    [restkitRequest setHTTPBody:data];
    [restkitRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [restkitRequest setHTTPMethod:@"POST"];

    RKManagedObjectRequestOperation *postOperation = [delegate.stomtObjectManager managedObjectRequestOperationWithRequest:restkitRequest managedObjectContext:delegate.stomtObjectManager.managedObjectStore.persistentStoreManagedObjectContext success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        Stomt *stomt = [mappingResult firstObject];
        NSLog(@"stomt with id: %@ and text %@, created at: %@", stomt.stomtId, stomt.text, stomt.createdAt);
        block(YES);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Could not post a stomt because of the error: %@", error);
        block(NO);
    }];
    [delegate.stomtObjectManager enqueueObjectRequestOperation:postOperation];
}

+(void)deleteStomt:(Stomt *)stomt block:(boolCompletionHandler)block {
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [delegate.stomtObjectManager.HTTPClient setDefaultHeader:@"thirdpartyid" value:thirdpartyid];
    [delegate.stomtObjectManager.HTTPClient setDefaultHeader:@"thirdpartysecret" value:thirdpartysecret];
    [delegate.stomtObjectManager.HTTPClient setDefaultHeader:@"userid" value:stomt.creator];
    
    [delegate.stomtObjectManager deleteObject:stomt path:[NSString stringWithFormat:@"/stomt/%@", stomt.stomtId] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        block(YES);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        block(NO);
        RKLogError(@"Load failed with error: %@", error);
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

+(void)deleteStomtFromCoreData:(Stomt *)stomt {
    
    NSManagedObjectContext *context = stomt.managedObjectContext;
    [context deleteObject:stomt];
    NSError *error;
    if (![context saveToPersistentStore:&error]) {
        NSLog(@"delete error %@", [error localizedDescription]);
    }
}

@end

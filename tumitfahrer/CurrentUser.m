//
//  CurrentUser.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "CurrentUser.h"
#import "LocationController.h"
#import "JsonParser.h"
#import "Device.h"
#import "Ride.h"
#import "RidesStore.h"

@interface CurrentUser ()

@property (nonatomic, strong) NSMutableArray *privateUserRides;

@end

@implementation CurrentUser

-(instancetype)init {
    self = [super init];
    if (self) {
        [[LocationController sharedInstance] startUpdatingLocation];
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

+ (BOOL)fetchUserFromCoreDataWithEmail:(NSString *)email {
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
+ (BOOL)fetchUserFromCoreDataWithEmail:(NSString *)email encryptedPassword:(NSString *)encryptedPassword{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"User"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(email = %@ && password= %@)", email, encryptedPassword];
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

-(void)deleteRide:(Ride *)ride forUserId:(NSInteger)userId {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"User"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userId = %d)", userId];
    [request setPredicate:predicate];
    request.entity = e;
    
    NSError *error;
    NSArray *result = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    
    User *user = (User *)[result firstObject];
    NSLog(@"user with id: %d", user.userId);
    [user removeRidesAsDriverObject:ride];
    
}


#pragma mark - Device token methods

- (void)hasDeviceTokenInWebservice:(boolCompletionHandler)block {
    
    [NSURLConnection sendAsynchronousRequest:[self buildGetDeviceTokenRequest] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError) {
            NSLog(@"Could not retrieve device token");
            block(NO);
        } else {
            NSError *error;
            NSArray *deviceTokens = [JsonParser  devicesFromJson:data error:error];
            if (!error) {
                for (NSString *deviceToken in deviceTokens) {
                    if ([deviceToken isEqualToString:[Device sharedInstance].deviceToken]) {
                        block(YES);
                        return;
                    }
                }
            }
            block(NO);
        }}];
}

- (NSURLRequest *)buildGetDeviceTokenRequest {
    NSString *urlString = [API_ADDRESS stringByAppendingString:[NSString stringWithFormat:@"/api/v2/users/%d/devices", [CurrentUser sharedInstance].user.userId]];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    return urlRequest;
}

- (void)sendDeviceTokenToWebservice {
    if([[Device sharedInstance] deviceToken]) {
        NSDictionary *queryParams;
        // add enum
        queryParams = @{@"platform": @"ios", @"token": [[Device sharedInstance] deviceToken], @"enabled":@"true"};
        NSDictionary *deviceParams = @{@"device": queryParams};
        
        NSString *pathString = [NSString stringWithFormat:@"/api/v2/users/%d/devices", [CurrentUser sharedInstance].user.userId];
        [[RKObjectManager sharedManager] postObject:nil path:pathString parameters:deviceParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"success");
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"Could not send device token to DB. Error connecting data from server: %@", error.localizedDescription);
        }];
    }
}

- (void)refreshUserRides {
    self.privateUserRides = [NSMutableArray arrayWithArray:[self.user.ridesAsDriver allObjects]];
    [self.privateUserRides addObjectsFromArray:[self.user.ridesAsPassenger allObjects]];
    [self.privateUserRides addObjectsFromArray:[[RidesStore sharedStore] rideRequestForUserWithId:self.user.userId]];
}

- (NSMutableArray *)userRides {
    if(self.privateUserRides == nil) {
        [self refreshUserRides];
    }
    return  self.privateUserRides;
}

-(void)saveToPersisentStore {
    
    NSManagedObjectContext *context = self.user.managedObjectContext;
    [context deleteObject:self.user];
    NSError *error;
    if (![context saveToPersistentStore:&error]) {
        NSLog(@"delete error %@", [error localizedDescription]);
    }
}

# pragma mark - Object to string

-(NSString *)description {
    return [NSString stringWithFormat:@"Name: %@ %@, email: %@, registered at: %@", self.user.firstName, self.user.lastName, self.user.email, self.user.createdAt];
}

@end
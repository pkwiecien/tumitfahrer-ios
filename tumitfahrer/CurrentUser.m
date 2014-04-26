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

- (void)hasDeviceToken:(myCompletion)block {
    
    [NSURLConnection sendAsynchronousRequest:[self buildGetDeviceTokenRequest] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError) {
            NSLog(@"Could not retrieve device token");
            block(nil);
        } else {
            NSLog(@"response: %@", response);
            NSLog(@"data: %@", data);
            
            NSError *testError;
            NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&testError];
            
            NSLog(@"parsed: %@", parsedObject);
            
            NSMutableArray *devices1 = [[NSMutableArray alloc] initWithObjects:@"one", @"two", nil];
            NSLog(@"devs: %@", devices1);
            NSArray *devices = [parsedObject valueForKey:@"devices"];
            NSString *status = parsedObject[@"status"];
            NSLog(@"status: %@", status);
            NSLog(@"devices: %@", devices);
            block(devices);

            /*
            //NSArray *deviceTokens = [JsonParser devicesFromJson:data error:&error];
            for (NSString *deviceToken in deviceTokens) {
                if ([deviceToken isEqualToString:[Device sharedInstance].deviceToken]) {
                    block(YES);
                }
                NSLog(@"%@", deviceToken);
            }*/
//            block(nil);
        }}];
}

- (NSURLRequest *)buildGetDeviceTokenRequest {
    NSString *urlString = [API_ADDRESS stringByAppendingString:[NSString stringWithFormat:@"/api/v2/users/%d/devices", [CurrentUser sharedInstance].user.userId]];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    return urlRequest;
}

- (void)sendDeviceToken {
    
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

-(NSString *)description {
    return [NSString stringWithFormat:@"Name: %@ %@, email: %@, registered at: %@", self.user.firstName, self.user.lastName, self.user.email, self.user.createdAt];
}

@end
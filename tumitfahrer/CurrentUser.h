//
//  CurrentUser.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface CurrentUser : NSObject

+(instancetype)sharedInstance;

@property (nonatomic, strong) User *user;

+ (BOOL)fetchUserFromCoreDataWithEmail:(NSString *)email;

- (void)hasDeviceTokenInWebservice:(boolCompletionHandler)block;
- (void)sendDeviceTokenToWebservice;
- (NSMutableArray *)userRides;
- (void)refreshUserRides;
-(void)deleteRide:(Ride *)ride forUserId:(NSInteger)userId;

@end

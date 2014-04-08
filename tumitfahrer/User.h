//
//  User.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSNumber * department;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * car;
@property (nonatomic, retain) NSNumber * isStudent;
@property (nonatomic, retain) NSString * apiKey;
@property (nonatomic, retain) NSString * password;

@end

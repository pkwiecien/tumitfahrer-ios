//
//  UserMapping.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserMapping : NSObject

+(RKEntityMapping *)userMapping;
+(RKObjectMapping *)postUserMapping;
+(RKResponseDescriptor *)postUserResponseDescriptorWithMapping:(RKObjectMapping *)mapping;

@end

//
//  BadgeMapping.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/17/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BadgeMapping : NSObject

+(RKEntityMapping *)badgeMapping;
+(RKResponseDescriptor *)getBadgesResponseDescriptorWithMapping:(RKEntityMapping *)mapping;

@end

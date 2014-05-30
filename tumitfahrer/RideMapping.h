//
//  RideMapping.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RideMapping : NSObject

+(RKEntityMapping *)generalRideMapping;
+(RKResponseDescriptor *)getRidesResponseDescriptorWithMapping:(RKEntityMapping *)mapping;

+(RKObjectMapping*)getRideSearchesMapping;
+(RKResponseDescriptor *)getRideSearchesResponseDescriptorWithMapping:(RKObjectMapping *)mapping;

+(RKEntityMapping *)postRideMapping;
+(RKResponseDescriptor *)postRideResponseDescriptorWithMapping:(RKEntityMapping *)mapping;

+(RKResponseDescriptor *)getSingleRideResponseDescriptorWithMapping:(RKEntityMapping *)mapping;

@end

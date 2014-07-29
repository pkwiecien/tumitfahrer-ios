//
//  StomtMapping.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 7/26/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StomtMapping : NSObject

+(RKEntityMapping *)stomtMapping;
+(RKObjectMapping *)deleteStomtMapping;
+(RKResponseDescriptor *)getStomtsResponseDescriptorWithMapping:(RKEntityMapping *)mapping;
+(RKResponseDescriptor *)postStomtResponseDescriptorWithMapping:(RKObjectMapping *)mapping;
+(RKResponseDescriptor *)deleteStomtResponseDescriptorWithMapping:(RKObjectMapping *)mapping;

@end

//
//  MessageMapping.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageMapping : NSObject

+(RKEntityMapping *)messageMapping;
+ (RKResponseDescriptor *)postMessageResponseDescriptorWithMapping:(RKEntityMapping*)mapping;

@end

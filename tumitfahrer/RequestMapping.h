//
//  RequestMapping.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/3/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestMapping : NSObject

+(RKEntityMapping*)requestMapping;
+(RKResponseDescriptor *)postRequestResponseDescriptorWithMapping:(RKEntityMapping *)mapping;

@end

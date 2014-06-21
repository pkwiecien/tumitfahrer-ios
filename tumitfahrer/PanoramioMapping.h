//
//  PanoramioMapping.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/21/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PanoramioMapping : NSObject

+(RKEntityMapping *)panoramioMapping;
+(RKResponseDescriptor *)getPhotoResponseDescriptorWithMapping:(RKEntityMapping *)mapping;

@end

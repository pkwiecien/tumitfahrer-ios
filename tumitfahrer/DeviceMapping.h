//
//  DeviceMapping.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/26/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceMapping : NSObject

+(RKObjectMapping *)postDeviceMapping;
+(RKResponseDescriptor *)postDeviceResponseDescriptorWithMapping:(RKObjectMapping *)mapping;

@end

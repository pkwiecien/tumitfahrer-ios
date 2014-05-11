//
//  TimelineMapping.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivitiesMapping : NSObject

+(RKEntityMapping *)generalActivityMapping;
+(RKResponseDescriptor *)getActivityResponseDescriptorWithMapping:(RKEntityMapping *)mapping;

@end

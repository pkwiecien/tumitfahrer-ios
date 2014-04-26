//
//  Device.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/25/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "Device.h"

@interface Device ()

@end

@implementation Device

+(instancetype)sharedInstance {
    static Device *currentDevice = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentDevice = [[super alloc] init];
    });
    
    return currentDevice;
}

-(instancetype)init {
    self = [super init];
    return self;
}

@end

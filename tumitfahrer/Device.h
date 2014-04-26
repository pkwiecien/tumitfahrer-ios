//
//  Device.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/25/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Device : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSString* deviceToken;

@end

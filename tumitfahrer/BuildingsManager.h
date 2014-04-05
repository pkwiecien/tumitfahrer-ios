//
//  Buildings.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/5/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuildingsManager : NSObject

@property (nonatomic, retain) NSArray *buildingsArray;

+ (instancetype)sharedManager;

@end

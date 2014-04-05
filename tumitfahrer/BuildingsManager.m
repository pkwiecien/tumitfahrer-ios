//
//  Buildings.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/5/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "BuildingsManager.h"

@implementation BuildingsManager

@synthesize buildingsArray;

+(instancetype)sharedManager
{
    static BuildingsManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
        buildingsArray = [NSArray arrayWithObjects:@"building0", @"building1", @"building2", @"building3", @"building4", @"building5", @"building6", @"building7", @"building8", @"building9", @"building10", nil];
    }
    return self;
}


@end

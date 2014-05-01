//
//  RideSearchStore.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/1/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RideSearch;

@interface RideSearchStore : NSObject

+ (instancetype)sharedStore;

- (void)addSearchResult:(RideSearch *)searchResult;
- (NSArray *)allSearchResults;
- (RideSearch *)rideWithId:(NSInteger)rideId;

@end

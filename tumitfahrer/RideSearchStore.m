//
//  RideSearchStore.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/1/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RideSearchStore.h"
#import "RideSearch.h"
@interface RideSearchStore ()

@property (nonatomic) NSMutableArray *searchResults;

@end

@implementation RideSearchStore

-(instancetype)init {
    self = [super init];
    if (self) {
        self.searchResults = [[NSMutableArray alloc] init];
    }
    return self;
}

+(instancetype)sharedStore {
    static RideSearchStore *ridesSearchStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ridesSearchStore = [[self alloc] init];
    });
    return ridesSearchStore;
}

-(void)addSearchResult:(RideSearch *)searchResult {
    [self.searchResults addObject:searchResult];
}

-(NSArray *)allSearchResults {
    return self.searchResults;
}

-(RideSearch *)rideWithId:(NSInteger)rideId {
    for (RideSearch *ride in self.searchResults) {
        if (ride.rideId == rideId) {
            return ride;
        }
    }
    return nil;
}

@end

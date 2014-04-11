//
//  RidesStore.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RideStoreDelegate <NSObject>

- (void)didRecieveRidesFromWebService: (NSArray*)rides;

@end

@interface RidesStore : NSObject

@property (nonatomic, readonly) NSArray *allRides;
@property (nonatomic, weak) id<RideStoreDelegate> delegate;

+ (instancetype)sharedStore;

-(NSArray*)allRides;
-(void)loadRides;

@end

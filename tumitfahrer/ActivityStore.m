//
//  ActivityStore.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "ActivityStore.h"
#import "Activity.h"
#import "Ride.h"
#import "RideSearch.h"
#import "Request.h"
#import "LocationController.h"
#import "CurrentUser.h"
#import "RidesStore.h"
#import "ActionManager.h"
#import <RestKit/RestKit.h>

@interface ActivityStore () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSMutableArray *privateActivityArray;
@property (nonatomic, strong) NSMutableArray *privateAllRecentActivities;
@property (nonatomic, strong) NSMutableArray *privateActivitiesNearby;
@property (nonatomic, strong) NSMutableArray *privateMyRecentActivities;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) CLLocation *lastLocation;

@end

@implementation ActivityStore

static int activity_id = 0;

+(instancetype)sharedStore {
    static ActivityStore *activityStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        activityStore = [[self alloc] init];
    });
    return activityStore;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        [self initAllActivitiesFromCoreData];
        
        [self fetchActivitiesFromWebservice:^(BOOL resultsFetched) {
            if(resultsFetched) {
                [self initAllActivitiesFromCoreData];
            }
        }];
    }
    return self;
}

-(void)initAllActivitiesFromCoreData {
    [self fetchActivitiesFromCoreData];
    self.privateAllRecentActivities = [self getSortedActivities];
    [self filterAllActivities];
    
    self.privateActivitiesNearby = [self sortActivitiesWithArray:self.privateActivitiesNearby];
    self.privateMyRecentActivities = [self sortActivitiesWithArray:self.privateMyRecentActivities];
    if ([self.privateAllRecentActivities count] > 0) {
        [self.delegate didRecieveActivitiesFromWebService];
    }
}

-(void)filterAllActivities {
    [self filterNearbyActivities];
    [self filterMyActivities];
}

-(NSMutableArray *)sortActivitiesWithArray:(NSMutableArray *)array {
    NSArray *sortedArray;
    sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [a createdAt];
        NSDate *second = [b createdAt];
        return [first compare:second] == NSOrderedAscending;
    }];
    return [[NSMutableArray alloc] initWithArray:sortedArray];
}

-(NSMutableArray *)getSortedActivities {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSDate *now = [ActionManager currentDate];
    
    for (Activity *activity in self.privateActivityArray) {
        for (Ride *ride in activity.rides) {
            if ([now compare:ride.departureTime] == NSOrderedAscending && ![array containsObject:ride]) {
                [array addObject:ride];
                [[RidesStore sharedStore] addRideToStore:ride];
            }
        }
        for (Request *request in activity.requests) {
            if ([now compare:request.requestedRide.departureTime] == NSOrderedAscending && ![array containsObject:request])  {
                [array addObject:request];
                [[RidesStore sharedStore] addRideRequestToStore:request];
            }
        }
        for (RideSearch *rideSearch in activity.rideSearches) {
            if (![array containsObject:rideSearch]) {
                [array addObject:rideSearch];
            }
        }
    }
    
    return [self sortActivitiesWithArray:array];
}

# pragma mark - filter nearby activities

-(void)filterNearbyActivities {
    CLLocation *currentLocation = [LocationController sharedInstance].currentLocation;
    if (currentLocation == nil) {
        return;
    }
    
    for (id activity in [self allRecentActivities]) {
        Ride *ride = nil;
        RideSearch *rideSearch = nil;
        if ([activity isKindOfClass:[Ride class]]) {
            ride = (Ride *)activity;
        } else if([activity isKindOfClass:[Request class]]) {
            ride = ((Request *)activity).requestedRide;
        } else if([activity isKindOfClass:[RideSearch class]]) {
            rideSearch = (RideSearch *)rideSearch;
        }
        
        if(ride != nil) {
            [RidesStore initRide:ride block:^(BOOL fetched) {
                CLLocation *departureLocation = [LocationController locationFromLongitude:[ride.departureLongitude doubleValue] latitude:[ride.departureLatitude doubleValue]];
                CLLocation *destinationLocation = [LocationController locationFromLongitude:[ride.destinationLongitude doubleValue] latitude:[ride.destinationLatitude doubleValue]];
                
                if([LocationController isLocation:currentLocation nearbyAnotherLocation:departureLocation thresholdInMeters:1000] || [LocationController isLocation:currentLocation nearbyAnotherLocation:destinationLocation thresholdInMeters:1000])
                {
                    [self addNearbyActivity:activity];
                }
            }];
            
        } else if(rideSearch != nil) {
            [[LocationController sharedInstance] fetchLocationForAddress:rideSearch.departurePlace completionHandler:^(CLLocation *location) {
                if (location!=nil) {
                    if([LocationController isLocation:currentLocation nearbyAnotherLocation:location thresholdInMeters:1000])
                    {
                        
                        [self addNearbyActivity:activity];
                    }
                }
            }];
            
            [[LocationController sharedInstance] fetchLocationForAddress:rideSearch.destination completionHandler:^(CLLocation *location) {
                if (location!=nil) {
                    if([LocationController isLocation:currentLocation nearbyAnotherLocation:location thresholdInMeters:1000])
                    {
                        [self addNearbyActivity:activity];
                    }
                }
            }];
        }
    }
}

-(void)addNearbyActivity:(id)activity {
    if (![[self activitiesNearby] containsObject:activity]) {
        [[self activitiesNearby] addObject:activity];
    }
}

# pragma mark - filter my activities

-(void)filterMyActivities {
    
    if ([CurrentUser sharedInstance].user == nil) {
        return;
    }
    
    for (id activity in [self allRecentActivities]) {
        if ([activity isKindOfClass:[Ride class]]) {
            Ride *ride = (Ride *)activity;
            if([[CurrentUser sharedInstance].user.ridesAsPassenger containsObject:ride] || [[CurrentUser sharedInstance].user.ridesAsOwner containsObject:ride]) {
                [self addMyActivity:activity];
            }
        } else if([activity isKindOfClass:[Request class]]) {
            Request *request = ((Request *)activity);
            if ([request.passengerId isEqualToNumber:[CurrentUser sharedInstance].user.userId]|| [request.requestedRide.rideOwner.userId isEqualToNumber:[CurrentUser sharedInstance].user.userId]) {
                [self addMyActivity:activity];
            }
        } else if([activity isKindOfClass:[RideSearch class]]) {
            RideSearch *rideSearch = (RideSearch *)activity;
            if ([rideSearch.userId isEqualToNumber:[CurrentUser sharedInstance].user.userId]) {
                [self addMyActivity:activity];
            }
        }
    }
}

-(void)addMyActivity:(id)activity {
    if (![[self myRecentActivities] containsObject:activity]) {
        [[self myRecentActivities] addObject:activity];
    }
}

#pragma mark - fetch methods

-(void)fetchActivitiesFromWebservice:(boolCompletionHandler)block {
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"/api/v2/activities?activity_id=%d", activity_id] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        Activity *activity = [mappingResult firstObject];
        if (activity != nil && (activity.rides.count > 0 || activity.rideSearches.count > 0 || activity.requests.count > 0)) {
            activity_id++;
        }
        block(YES);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Load failed with error: %@", error);
        block(NO);
    }];
}

-(void)fetchActivitiesFromCoreData {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Activity"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    request.entity = e;
    
    NSError *error;
    NSArray *fetchedObjects = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!fetchedObjects) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    
    self.privateActivityArray = [[NSMutableArray alloc] init];
    for (int i = 0; i <= activity_id; i++) {
        if (i < [fetchedObjects count] && [fetchedObjects objectAtIndex:i] != nil) {
            [self.privateActivityArray addObject:[fetchedObjects objectAtIndex:i]];
        }
    }
}

-(NSFetchedResultsController *)fetchedResultsController {
    if (self.fetchedResultsController != nil) {
        return self.fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Activity"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    fetchRequest.sortDescriptors = @[descriptor];
    NSError *error = nil;
    
    // Setup fetched results
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fetchRequest
                                     managedObjectContext:[RKManagedObjectStore defaultStore].
                                     mainQueueManagedObjectContext
                                     sectionNameKeyPath:nil cacheName:@"Activity"];
    self.fetchedResultsController.delegate = self;
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Error fetching from db: %@", [error localizedDescription]);
    }
    
    return self.fetchedResultsController;
}

# pragma mark - helper functions

- (NSArray*)recentActivitiesByType:(TimelineContentType)contentType {
    switch (contentType) {
        case AllActivity:
            return [self allRecentActivities];
        case NearbyActivity:
            return [self activitiesNearby];
        case UserActivity:
            return [self myRecentActivities];
    }
}

-(void)didReceiveCurrentLocation:(CLLocation *)location {
    if (self.lastLocation == nil) {
        self.lastLocation = location;
    }
    
    // check here if previous location is away from current location more than 10km
    if(![LocationController isLocation:location nearbyAnotherLocation:self.lastLocation thresholdInMeters:10*1000]) {
        self.lastLocation = location;
        [self filterNearbyActivities];
    }
}

#pragma mark - getters with initializers

-(NSMutableArray *)myRecentActivities {
    if (self.privateMyRecentActivities == nil) {
        self.privateMyRecentActivities = [[NSMutableArray alloc] init];
    }
    return self.privateMyRecentActivities;
}

-(NSMutableArray *)activitiesNearby {
    if (self.privateActivitiesNearby == nil) {
        self.privateActivitiesNearby = [[NSMutableArray alloc] init];
    }
    return self.privateActivitiesNearby;
}

-(NSMutableArray *)allRecentActivities {
    if (self.privateAllRecentActivities == nil) {
        self.privateAllRecentActivities = [[NSMutableArray alloc] init];
    }
    return self.privateAllRecentActivities;
}


@end

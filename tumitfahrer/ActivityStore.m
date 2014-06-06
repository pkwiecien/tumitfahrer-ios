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

@interface ActivityStore () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) Activity *privateActivity;
@property (nonatomic, strong) NSMutableArray *privateAllRecentActivities;
@property (nonatomic, strong) NSMutableArray *privateActivitiesNearby;
@property (nonatomic, strong) NSMutableArray *privateMyRecentActivities;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ActivityStore

static int page = 0;

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
    [self sortActivities];
    [self filterAllActivities];
}

-(void)filterAllActivities {
    [self filterNearbyActivities];
    [self filterMyActivities];
}

-(void)sortActivities {
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[self.privateActivity.rides allObjects]];
    if ([self.privateActivity.rideSearches count] > 0) {
        [array addObjectsFromArray:[self.privateActivity.rideSearches allObjects]];
    }
    if ([self.privateActivity.requests count] > 0) {
        [array addObjectsFromArray:[self.privateActivity.requests allObjects]];
    }
    
    NSArray *sortedArray;
    sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [a createdAt];
        NSDate *second = [b createdAt];
        return [first compare:second] == NSOrderedDescending;
    }];
    self.privateAllRecentActivities = [[NSMutableArray alloc] initWithArray:sortedArray];
}


-(void)filterNearbyActivities {
    CLLocation *currentLocation = [LocationController sharedInstance].currentLocation;
    
    for (id activity in self.privateAllRecentActivities) {
        Ride *ride = nil;
        if ([activity isKindOfClass:[Ride class]]) {
            ride = (Ride *)activity;
        } else if([activity isKindOfClass:[Request class]]) {
            ride = ((Request *)activity).requestedRide;
        }
        
        if(ride != nil) {
            CLLocation *departureLocation = [LocationController locationFromLongitude:[ride.departureLongitude doubleValue] latitude:[ride.departureLatitude doubleValue]];
            CLLocation *destinationLocation = [LocationController locationFromLongitude:[ride.destinationLongitude doubleValue] latitude:[ride.destinationLatitude doubleValue]];
            NSLog(@"Departure location: %f %f, destination: %f %f, ride: %f %f", departureLocation.coordinate.latitude, departureLocation.coordinate.longitude, destinationLocation.coordinate.latitude, departureLocation.coordinate.longitude, currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
            if([LocationController isLocation:currentLocation nearbyAnotherLocation:departureLocation thresholdInMeters:1000] || [LocationController isLocation:currentLocation nearbyAnotherLocation:destinationLocation thresholdInMeters:1000])
            {
                [self.privateActivitiesNearby addObject:activity];
            }
        }
    }
}

-(void)filterMyActivities {
    self.privateMyRecentActivities = [[NSMutableArray alloc] init];
    for (id activity in self.privateAllRecentActivities) {
        if ([activity isKindOfClass:[Ride class]]) {
            Ride *ride = (Ride *)activity;
            if([[CurrentUser sharedInstance].user.ridesAsPassenger containsObject:ride] || [[CurrentUser sharedInstance].user.ridesAsOwner containsObject:ride]) {
                [self.privateMyRecentActivities addObject:activity];
            }
        } else if([activity isKindOfClass:[Request class]]) {
            Request *request = ((Request *)activity);
            if ([request.passengerId isEqualToNumber:[CurrentUser sharedInstance].user.userId ]|| [request.requestedRide.rideOwner.userId isEqualToNumber:[CurrentUser sharedInstance].user.userId]) {
                [self.privateMyRecentActivities addObject:activity];
            }
        }
    }
}

#pragma mark - fetch methods

-(void)fetchActivitiesFromWebservice:(boolCompletionHandler)block {
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"/api/v2/activities?page=%d", page] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        Activity *activity = [mappingResult firstObject];
        if (activity != nil && (activity.rides.count > 0 || activity.rideSearches.count > 0 || activity.requests.count > 0)) {
            page++;
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
    self.privateActivity = [fetchedObjects firstObject];
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
        case UserActivity:
            return [self myRecentActivities];
        case NearbyActivity:
            return [self activitiesNearby];
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

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
#import "Rating.h"
#import "Request.h"
#import "LocationController.h"
#import "CurrentUser.h"

@interface ActivityStore () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) Activity *activitiesResult;
@property (nonatomic, strong) NSMutableArray *privateRecentActivities;
@property (nonatomic, strong) NSMutableArray *privateActivitiesNearby;
@property (nonatomic, strong) NSMutableArray *privateMyRecentActivities;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ActivityStore

static int page = 0;

-(instancetype)init {
    self = [super init];
    if (self) {
        [self loadAllActivitiesFromCoreData];
        
        [self fetchActivitiesFromWebservice:^(BOOL resultsFetched) {
            if(resultsFetched) {
                [self loadAllActivitiesFromCoreData];
            }
        }];
    }
    return self;
}

+(instancetype)sharedStore {
    static ActivityStore *activityStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        activityStore = [[self alloc] init];
    });
    return activityStore;
}

-(void)loadAllActivitiesFromCoreData {
    [self fetchActivitiesFromCoreData];
    [self sortRecentActivities];
}

-(void)sortRecentActivities {
    self.privateRecentActivities = [[NSMutableArray alloc] init];
    int rideIndex = 0;
    int ratingIndex = 0;
    int requestsIndex = 0;
    
    NSArray *rides = [NSArray arrayWithArray:[self.activitiesResult.rides allObjects]];
    NSArray *requests = [NSArray arrayWithArray:[self.activitiesResult.requests allObjects]];
    NSArray *ratings = [NSArray arrayWithArray:[self.activitiesResult.ratings allObjects]];
    while(rideIndex < [self.activitiesResult.rides count] || ratingIndex < [self.activitiesResult.ratings count] || requestsIndex < [self.activitiesResult.requests count]) {
        // find the latest event from three arrays
        NSMutableArray *comparedObjects = [[NSMutableArray alloc] init];
        if(rideIndex < [rides count])
            [comparedObjects addObject:[rides objectAtIndex:rideIndex]];
        else if(requestsIndex < [requests count])
            [comparedObjects addObject:[requests objectAtIndex:requestsIndex]];
        else if(ratingIndex < [ratings count])
            [comparedObjects addObject:[ratings objectAtIndex:ratingIndex]];
        
        id result = [self compareThree:comparedObjects];
        
        if([result isKindOfClass:[Ride class]]) {
            rideIndex++;
        } else if([result isKindOfClass:[Rating class]]) {
            ratingIndex++;
        } else if([result isKindOfClass:[Request class]]){
            requestsIndex++;
        }
        [self.privateRecentActivities addObject:result];
    }
}

- (void)reloadNearbyActivities {
    self.privateActivitiesNearby = [[NSMutableArray alloc] init];
    CLLocation *currentLocation = [LocationController sharedInstance].currentLocation;
    
    for (id activity in self.privateRecentActivities) {
        Ride *ride = nil;
        if ([activity isKindOfClass:[Ride class]]) {
            ride = (Ride *)activity;
        } else if([activity isKindOfClass:[Request class]]) {
            ride = ((Request *)activity).requestedRide;
        }
        
        if(ride != nil) {
            CLLocation *departureLocation = [LocationController locationFromLongitude:ride.departureLongitude latitude:ride.departureLatitude];
            CLLocation *destinationLocation = [LocationController locationFromLongitude:ride.destinationLongitude latitude:ride.destinationLatitude];
            if([LocationController isLocation:currentLocation nearbyAnotherLocation:departureLocation] || [LocationController isLocation:currentLocation nearbyAnotherLocation:destinationLocation])
            {
                [self.privateActivitiesNearby addObject:activity];
            }
        }
    }
}


- (void)reloadMyActivities {
    self.privateMyRecentActivities = [[NSMutableArray alloc] init];
    for (id activity in self.privateRecentActivities) {
        if ([activity isKindOfClass:[Ride class]]) {
            Ride *ride = (Ride *)activity;
            if([[CurrentUser sharedInstance].user.ridesAsPassenger containsObject:ride]) {
                [self.privateMyRecentActivities addObject:activity];
            }
        } else if([activity isKindOfClass:[Request class]]) {
            Request *request = ((Request *)activity);
            if (request.passengerId == [CurrentUser sharedInstance].user.userId || (request.requestedRide.driver != nil && request.requestedRide.driver.userId == [CurrentUser sharedInstance].user.userId)) {
                [self.privateMyRecentActivities addObject:activity];
            }
        }
    }
}


#pragma mark - fetch methods

-(void)fetchActivitiesFromWebservice:(boolCompletionHandler)block {
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"/api/v2/activities?page=%d", page] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSArray *array = [mappingResult array];
        if ([array count] > 1) {
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
    self.activitiesResult = [fetchedObjects firstObject];
}

-(NSFetchedResultsController *)fetchedResultsController
{
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
            return self.privateRecentActivities;
        case UserActivity:
            if (self.privateMyRecentActivities == nil) {
                [self reloadMyActivities];
            }
            return self.privateMyRecentActivities;
        case NearbyActivity:
            if (self.privateActivitiesNearby == nil) {
                [self reloadNearbyActivities];
            }
            return self.privateActivitiesNearby;
    }
}

-(id)compareThree:(NSArray *)elements {
    id result = nil;
    
    if([elements count] == 1)
        return [elements objectAtIndex:0];
    else if([elements count] == 2) {
        result = [[elements objectAtIndex:0] updatedAt] < [[elements objectAtIndex:1] updatedAt] ? [[elements objectAtIndex:0] updatedAt] : [[elements objectAtIndex:1] updatedAt];
        return  result;
    } else if([elements count] == 3){
        
        if([[elements objectAtIndex:0] updatedAt] < [[elements objectAtIndex:1] updatedAt])
            result = [elements objectAtIndex:0];
        
        if ([result updatedAt] < [[elements objectAtIndex:2] updatedAt]) {
            result = [elements objectAtIndex:2];
        }
    }
    return result;
    
}


@end

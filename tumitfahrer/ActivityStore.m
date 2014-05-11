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

@interface ActivityStore () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) Activity *activitiesResult;
@property (nonatomic, strong) NSMutableArray *privateRecentActivities;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ActivityStore

-(instancetype)init {
    self = [super init];
    if (self) {
        [self fetchActivitiesFromCoreData];
        
        [self fetchActivitiesFromWebservice:^(BOOL resultsFetched) {
            if(resultsFetched) {
                [self loadAllActivities];
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

-(void)loadAllActivities {
    [self fetchActivitiesFromCoreData];
}

-(void)fetchActivitiesFromWebservice:(boolCompletionHandler)block {
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    [objectManager getObjectsAtPath:API_ACTIVITIES parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSArray *array = [mappingResult array];
        NSLog(@"returned %d", [array count]);
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

-(NSArray *)recentActivities {
    if(self.privateRecentActivities == nil) {
        [self fetchActivitiesFromCoreData];
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
            } else {
                requestsIndex++;
            }
            [self.privateRecentActivities addObject:result];
        }
    }
    return self.privateRecentActivities;
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

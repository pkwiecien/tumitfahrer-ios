//
//  RidesStore.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RidesStore.h"
#import "Ride.h"
#import "User.h"
#import "Request.h"
#import "CurrentUser.h"

@interface RidesStore () <NSFetchedResultsControllerDelegate>

@property (nonatomic) NSMutableArray *campusRides;
@property (nonatomic) NSMutableArray *activityRides;
@property (nonatomic) NSMutableArray *userRideRequests;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSMutableArray *observers;

@end

@implementation RidesStore

static int page = 0;

-(instancetype)init {
    self = [super init];
    if (self) {
        
        self.observers = [[NSMutableArray alloc] init];
        [self loadAllRides];
        [self fetchLocationForUpdatedRides];
        
        [self fetchRidesFromWebservice:^(BOOL ridesFetched) {
            if(ridesFetched) {
                [self loadAllRides];
                [self fetchLocationForUpdatedRides];
            }
        }];
    }
    return self;
}

-(void)loadAllRides {
    [self fetchRidesFromCoreDataByType:ContentTypeActivityRides];
    [self fetchRidesFromCoreDataByType:ContentTypeCampusRides];
}

+(instancetype)sharedStore {
    static RidesStore *ridesStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ridesStore = [[self alloc] init];
    });
    return ridesStore;
}

#pragma mark - core data/webservice fetch methods

-(void)fetchRidesFromCoreDataByType:(ContentType)contentType {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Ride"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(rideType = %d)", contentType];
    
    [request setPredicate:predicate];
    [request setReturnsObjectsAsFaults:NO];
    
    request.entity = e;
    
    NSError *error;
    NSArray *fetchedObjects = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!fetchedObjects) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }

    if(contentType == ContentTypeCampusRides){
        self.campusRides =[[NSMutableArray alloc] initWithArray:fetchedObjects];
    }
    else if(contentType == ContentTypeActivityRides) {
        self.activityRides = [[NSMutableArray alloc] initWithArray:fetchedObjects];
    }
}

- (void)fetchUserRequestedRidesFromCoreData:(NSInteger)userId {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Ride"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY self.requests.passengerId = %d", userId];
    
    [request setPredicate:predicate];

    request.entity = e;
    
    NSError *error;
    NSArray *fetchedObjects = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!fetchedObjects) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    self.userRideRequests = [NSMutableArray arrayWithArray:fetchedObjects];
    
}

-(NSArray *)rideRequestForUserWithId:(NSInteger)userId {
    [self fetchUserRequestedRidesFromCoreData:userId];
    return self.userRideRequests;
}

-(void)fetchNextRides:(boolCompletionHandler)block {
    [self fetchRidesFromWebservice:^(BOOL ridesFetched) {
        if(ridesFetched) {
            [self loadAllRides];
            block(YES);
            [self fetchLocationForUpdatedRides];
        }
    }];
}

-(void)fetchRidesFromWebservice:(boolCompletionHandler)block {
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    //    [objectManager.HTTPClient setDefaultHeader:@"Authorization: Basic" value:[self encryptCredentialsWithEmail:self.emailTextField.text password:self.passwordTextField.text]];
    
    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"/api/v2/rides?page=%d", page] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        block(YES);
        if ([[mappingResult array] count] > 0) {
            page++;
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Load failed with error: %@", error);
        block(NO);
    }];
}

-(NSFetchedResultsController *)fetchedResultsController
{
    if (self.fetchedResultsController != nil) {
        return self.fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Ride"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    fetchRequest.sortDescriptors = @[descriptor];
    NSError *error = nil;
    
    // Setup fetched results
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fetchRequest
                                     managedObjectContext:[RKManagedObjectStore defaultStore].
                                     mainQueueManagedObjectContext
                                     sectionNameKeyPath:nil cacheName:@"Ride"];
    self.fetchedResultsController.delegate = self;
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Error fetching from db: %@", [error localizedDescription]);
    }
    
    return self.fetchedResultsController;
}

-(void)fetchLocationForUpdatedRides {
    for(Ride *ride in [self allRides]) {
        if (ride.destinationLatitude == 0.0 || ride.destinationImage == nil) {
            [self fetchLocationForRide:ride];
        }
        if(ride.departureLatitude == 0.0) {
            [[LocationController sharedInstance] fetchLocationForAddress:ride.departurePlace completionHandler:^(CLLocation *location) {
                if (location != nil) {
                    ride.departureLatitude = location.coordinate.latitude;
                    ride.departureLongitude = location.coordinate.longitude;
                }
            }];
        }
    }
}

-(Ride *)containsRideWithId:(NSInteger)rideId {
    for (Ride *ride in [self allRides]) {
        if (ride.rideId == rideId) {
            return ride;
        }
    }
    return nil;
}

-(void)fetchLocationForRide:(Ride *)ride {
    [[LocationController sharedInstance] fetchLocationForAddress:ride.destination rideId:ride.rideId];
}

-(void)addRideToStore:(Ride *)ride {
    switch (ride.rideType) {
        case ContentTypeActivityRides:
            [self.activityRides addObject:ride];
            break;
        case ContentTypeCampusRides:
            [self.campusRides addObject:ride];
            break;
        default:
            break;
    }
}

-(void)deleteRideFromCoreData:(Ride *)ride {
    NSManagedObjectContext *context = ride.managedObjectContext;
    [context deleteObject:ride];
    NSError *error;
    if (![context saveToPersistentStore:&error]) {
        NSLog(@"delete error %@", [error localizedDescription]);
    }
}

-(void)deleteRideRequestFromCoreData:(Request *)request {
    NSManagedObjectContext *context = request.managedObjectContext;
    [context deleteObject:request];
    NSError *error;
    if (![context saveToPersistentStore:&error]) {
        NSLog(@"delete error %@", [error localizedDescription]);
    }
}

# pragma mark - delegate methods

-(void)didReceiveLocationForAddress:(CLLocation *)location rideId:(NSInteger)rideId {
    Ride *ride = [self getRideWithId:rideId];
    NSLog(@"ride id is: %d and fetched location lat: %f and destination was: %@", ride.rideId, location.coordinate.latitude, ride.destination);
    
    ride.destinationLatitude = location.coordinate.latitude;
    ride.destinationLongitude = location.coordinate.longitude;
    [[PanoramioUtilities sharedInstance] fetchPhotoForLocation:location rideId:rideId];
}

-(void)didReceivePhotoForLocation:(UIImage *)image rideId:(NSInteger)rideId{
    Ride *ride = [self getRideWithId:rideId];
    ride.destinationImage = UIImagePNGRepresentation(image);
    [self notifyAllAboutNewImageForRideId:rideId];
}

#pragma mark - utility funtioncs

-(NSArray *)allRides {
    NSMutableArray *rides = nil;
    rides = [[NSMutableArray alloc] init];
    if([[self allActivityRides] count] >0 )
        [rides addObjectsFromArray:[self allActivityRides]];
    if([[self allCampusRides] count] > 0)
        [rides addObjectsFromArray:[self allCampusRides]];
    return rides;
}

-(NSArray *)allRidesByType:(ContentType)contentType {
    switch (contentType) {
        case ContentTypeActivityRides:
            return self.allActivityRides;
        case ContentTypeCampusRides:
            return self.campusRides;
        default:
            return nil;
    }
}

-(NSArray *)allCampusRides {
    if(!self.campusRides) {
        [self fetchRidesFromCoreDataByType:ContentTypeCampusRides];
    }
    return self.campusRides;
}

-(NSArray *)allActivityRides {
    if(!self.activityRides) {
        [self fetchRidesFromCoreDataByType:ContentTypeActivityRides];
    }
    return self.activityRides;
}

- (Ride *)getRideWithId:(NSInteger)rideId {
    
    for (Ride *ride in [self allRides]) {
        NSLog(@"Ride is %@", ride);
        NSLog(@"ride id: %ld", (long)rideId);
        if (ride.rideId == (int16_t)rideId) {
            return ride;
        }
    }
    return nil;
}

- (void)printAllRides {
    for (Ride *ride in [self allRides]) {
        NSLog(@"Ride: %@", ride);
        NSLog(@"Driver: %d %@", ride.driver.userId, ride.driver.firstName);
        NSLog(@"ride: %@", ride);
        NSLog(@"Number of passengers: %d", (int)[ride.passengers count]);
        for (User *user in [ride passengers]) {
            NSLog(@"User: %d", user.userId);
        }
        
        NSLog(@"Number of requests: %d", (int)[ride.requests count]);
        for (Request *reques in [ride requests]) {
            NSLog(@"Request: %d %@", [reques.requestId intValue], reques.requestedFrom);
        }
    }
}

# pragma mark - observer methods

-(void)addObserver:(id<RideStoreDelegate>)observer {
    [self.observers addObject:observer];
}

-(void)notifyAllAboutNewImageForRideId:(NSInteger)rideId {
    for (id<RideStoreDelegate> observer in self.observers) {
        if ([observer respondsToSelector:@selector(didReceivePhotoForRide:)]) {
            [observer didReceivePhotoForRide:rideId];
        }
    }
}

-(void)removeObserver:(id<RideStoreDelegate>)observer {
    [self.observers removeObject:observer];
}

@end

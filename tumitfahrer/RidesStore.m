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

@property (nonatomic) NSMutableArray *privateCampusRides;
@property (nonatomic) NSMutableArray *privateActivityRides;
@property (nonatomic) NSMutableArray *userRideRequests;

@property (nonatomic) NSMutableArray *privateCampusRidesNearby;
@property (nonatomic) NSMutableArray *privateActivityRidesNearby;
@property (nonatomic) NSMutableArray *privateActivityRidesFavorites;
@property (nonatomic) NSMutableArray *privateCampusRidesFavorites;

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
        [self filterAllRides]; // categorize rides to rides around me and my rides
        [self fetchLocationForAllRides];
        
        [self fetchNewRides:nil];
        
        // check if the ride was removed from the database, and then remove it from core data as well
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

// fetch all upcoming rides
-(void)fetchRidesFromCoreDataByType:(ContentType)contentType {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Ride"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    NSPredicate *predicate;
    NSDate *now = [NSDate date];
    predicate = [NSPredicate predicateWithFormat:@"(rideType = %d) AND (departureTime > %@))", contentType, now];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"departureTime" ascending:YES];
    request.sortDescriptors = @[descriptor];
    
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
        self.privateCampusRides =[[NSMutableArray alloc] initWithArray:fetchedObjects];
    }
    else if(contentType == ContentTypeActivityRides) {
        self.privateActivityRides = [[NSMutableArray alloc] initWithArray:fetchedObjects];
    }
}

//TODO: add method for fetching all past rides
-(void)fetchPastRidesFromCoreDataByType:(ContentType)contentType {
    
}

- (void)fetchUserRequestedRidesFromCoreData:(NSNumber *)userId {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Ride"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY self.requests.passengerId = %@", userId];
    
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

- (Ride *)fetchRideFromCoreDataWithId:(NSNumber *)rideId {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Ride"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"rideId = %@", rideId];
    [request setPredicate:predicate];
    
    request.entity = e;
    
    NSError *error;
    NSArray *fetchedObjects = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!fetchedObjects) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    return [fetchedObjects firstObject];
}

-(NSArray *)rideRequestForUserWithId:(NSNumber *)userId {
    [self fetchUserRequestedRidesFromCoreData:userId];
    return self.userRideRequests;
}

-(void)fetchNewRides:(boolCompletionHandler)block {
    [self fetchNewRidesFromWebservice:^(NSMutableArray *rides) {
        if(rides != nil && [rides count] > 0) {
            for (Ride *ride in rides) {
                [self addRideToStore:ride];
            }
            block(YES);
        }
    }];
}

- (void)fetchNewRidesFromWebservice:(mutableArrayCompletionHandler)block {
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    //    [objectManager.HTTPClient setDefaultHeader:@"Authorization: Basic" value:[self encryptCredentialsWithEmail:self.emailTextField.text password:self.passwordTextField.text]];
    
    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"/api/v2/rides?page=%d", page] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSMutableArray *rides = [NSMutableArray arrayWithArray:[mappingResult array]];
        block(rides);
        if ([[mappingResult array] count] > 0) {
            page++;
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Load failed with error: %@", error);
        block(NO);
    }];
}

-(void)fetchSingleRideFromWebserviceWithId:(NSNumber *)rideId block:(boolCompletionHandler)block {
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    //    [objectManager.HTTPClient setDefaultHeader:@"Authorization: Basic" value:[self encryptCredentialsWithEmail:self.emailTextField.text password:self.passwordTextField.text]];
    
    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"/api/v2/rides/%@", rideId] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        block(YES);
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

-(Ride *)containsRideWithId:(NSNumber *)rideId {
    for (Ride *ride in [self allRides]) {
        if ([ride.rideId isEqualToNumber:rideId]) {
            return ride;
        }
    }
    return nil;
}


# pragma mark - add and delete methods

-(void)addRideToStore:(Ride *)ride {
    
    if ([ride.rideType intValue] == ContentTypeCampusRides) {
        [self.privateCampusRides addObject:ride];
        if ([self checkIfRideNearby:ride]) {
            [self.privateCampusRidesNearby addObject:ride];
        }
        if ([self checkIfRideFavourite:ride]) {
            [self.privateCampusRidesFavorites addObject:ride];
        }
    } else {
        [self.privateActivityRides addObject:ride];
        if ([self checkIfRideFavourite:ride]) {
            [self.privateActivityRidesFavorites addObject:ride];
        }
        if ([self checkIfRideNearby:ride]) {
            [self.privateActivityRidesNearby addObject:ride];
        }
    }
    
    [self fetchLocationForRide:ride];
}

-(void)deleteRideFromCoreData:(Ride *)ride {
    NSManagedObjectContext *context = ride.managedObjectContext;
    [context deleteObject:ride];
    NSError *error;
    if (![context saveToPersistentStore:&error]) {
        NSLog(@"delete error %@", [error localizedDescription]);
    } else {
        [self deleteRideFromLocalStore:ride];
    }
}

-(void)deleteRideFromLocalStore:(Ride *)ride {
    if ([ride.rideType intValue] == ContentTypeCampusRides) {
        [self.privateCampusRides removeObject:ride];
        [self.privateCampusRidesFavorites removeObject:ride];
        [self.privateCampusRidesNearby removeObject:ride];
    } else {
        [self.privateActivityRides removeObject:ride];
        [self.privateActivityRidesFavorites removeObject:ride];
        [self.privateActivityRidesNearby removeObject:ride];
    }
}

-(void)deleteRideRequestFromCoreData:(Request *)request {
    NSManagedObjectContext *context = request.managedObjectContext;
    [context deleteObject:request];
    NSError *error;
    if (![context saveToPersistentStore:&error]) {
        NSLog(@"delete error %@", [error localizedDescription]);
    } else {
        [self deleteRideRequestFromLocalStore:request];
    }
}

-(void)deleteRideRequestFromLocalStore:(Request *)request {
    [self.userRideRequests removeObject:request];
}

# pragma mark - location and delegate methods

-(void)fetchLocationForAllRides {
    for(Ride *ride in [self allRides]) {
        [self fetchLocationForRide:ride];
    }
}

-(void)fetchLocationForRide:(Ride *)ride {
    if (ride.destinationLatitude ==nil || ride.destinationLongitude == nil) {
        [[LocationController sharedInstance] fetchLocationForAddress:ride.destination rideId:ride.rideId];
    }
    
    if (ride.departureLatitude == nil || ride.departureLongitude == nil) {
        [[LocationController sharedInstance] fetchLocationForAddress:ride.departurePlace completionHandler:^(CLLocation *location) {
            if (location != nil) {
                ride.departureLatitude = [NSNumber numberWithDouble:location.coordinate.latitude];
                ride.departureLongitude = [NSNumber numberWithDouble:location.coordinate.longitude];
            }
        }];
    }
}

-(void)didReceiveLocationForAddress:(CLLocation *)location rideId:(NSNumber *)rideId {
    Ride *ride = [self getRideWithId:rideId];
    NSLog(@"ride id is: %@ and fetched location lat: %f and destination was: %@", ride.rideId, location.coordinate.latitude, ride.destination);
    
    ride.destinationLatitude = [NSNumber numberWithDouble:location.coordinate.latitude];
    ride.destinationLongitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    [[PanoramioUtilities sharedInstance] fetchPhotoForLocation:location rideId:rideId];
}

-(void)didReceivePhotoForLocation:(UIImage *)image rideId:(NSNumber *)rideId{
    Ride *ride = [self getRideWithId:rideId];
    ride.destinationImage = UIImagePNGRepresentation(image);
    [self notifyAllAboutNewImageForRideId:rideId];
}

#pragma mark - utility functions

-(NSArray *)allRides {
    NSMutableArray *rides = [[NSMutableArray alloc] init];
    if([self.privateActivityRides count] >0 )
        [rides addObjectsFromArray:self.privateActivityRides];
    if([self.privateCampusRides count] > 0)
        [rides addObjectsFromArray:self.privateCampusRides];
    return rides;
}

#pragma mark - favorite rides

- (void)filterFavoriteRidesByType:(ContentType)rideType {
    // TODO: implement
}

- (void)addFavoriteRide:(Ride*)ride {
    if ([ride.rideType intValue] == ContentTypeActivityRides) {
        [self.privateActivityRidesFavorites addObject:ride];
    } else if([ride.rideType intValue] == ContentTypeCampusRides) {
        [self.privateCampusRidesFavorites addObject:ride];
    }
}

-(NSArray *)favoriteRidesByType:(ContentType)contentType {
    if (contentType == ContentTypeActivityRides) {
        return self.privateActivityRidesFavorites;
    } else if(contentType == ContentTypeCampusRides) {
        return self.privateCampusRidesFavorites;
    }
    return nil;
}

-(BOOL)checkIfRideFavourite:(Ride*)ride {
    // TODO: implement
    return NO;
}

#pragma mark - nearby rides
- (void)filterNearbyRidesByType:(ContentType)rideType {
    
    for (Ride *ride in [self allRidesByType:rideType]) {
        if ([self checkIfRideNearby:ride]) {
            [self addNearbyRide:ride];
        }
    }
}

- (void)addNearbyRide:(Ride*)ride{
    if ([ride.rideType intValue] == ContentTypeActivityRides) {
        [self.privateActivityRidesNearby addObject:ride];
    } else if([ride.rideType intValue] == ContentTypeCampusRides) {
        [self.privateCampusRidesNearby addObject:ride];
    }
}

-(NSArray *)ridesNearbyByType:(ContentType)contentType {
    if (contentType == ContentTypeActivityRides) {
        return self.privateActivityRidesNearby;
    } else if(contentType == ContentTypeCampusRides) {
        return self.privateCampusRidesNearby;
    }
    return nil;
}

-(BOOL)checkIfRideNearby:(Ride *)ride {
    CLLocation *currentLocation = [LocationController sharedInstance].currentLocation;

    CLLocation *departureLocation = [LocationController locationFromLongitude:[ride.departureLongitude doubleValue] latitude:[ride.departureLatitude doubleValue]];
    CLLocation *destinationLocation = [LocationController locationFromLongitude:[ride.destinationLongitude doubleValue] latitude:[ride.destinationLatitude doubleValue]];
    
    if ([LocationController isLocation:currentLocation nearbyAnotherLocation:departureLocation] || [LocationController isLocation:currentLocation nearbyAnotherLocation:destinationLocation]) {
        return YES;
    }
    return NO;
}

# pragma mark - filter functions

-(void)filterAllRides {
    [self filterRidesByType:ContentTypeActivityRides];
    [self filterRidesByType:ContentTypeCampusRides];
}

-(void)filterRidesByType:(ContentType)contentType {
    [self filterFavoriteRidesByType:contentType];
    [self filterNearbyRidesByType:contentType];
}

-(NSArray *)allRidesByType:(ContentType)contentType {
    switch (contentType) {
        case ContentTypeActivityRides:
            return self.privateActivityRides;
        case ContentTypeCampusRides:
            return self.privateCampusRides;
        default:
            return nil;
    }
}

- (Ride *)getRideWithId:(NSNumber *)rideId {
    
    for (Ride *ride in [self allRides]) {
        if ([ride.rideId isEqualToNumber:rideId]) {
            return ride;
        }
    }
    return nil;
}

- (void)printAllRides {
    for (Ride *ride in [self allRides]) {
        NSLog(@"Ride: %@", ride);
        NSLog(@"ride: %@", ride);
        NSLog(@"Number of passengers: %d", (int)[ride.passengers count]);
        for (User *user in [ride passengers]) {
            NSLog(@"User: %d", [user.userId intValue]);
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

-(void)notifyAllAboutNewImageForRideId:(NSNumber *)rideId {
    for (id<RideStoreDelegate> observer in self.observers) {
        if ([observer respondsToSelector:@selector(didReceivePhotoForRide:)]) {
            [observer didReceivePhotoForRide:rideId];
        }
    }
}

-(void)removeObserver:(id<RideStoreDelegate>)observer {
    [self.observers removeObject:observer];
}


#pragma mark - getters with initializers

-(NSMutableArray *)privateActivityRides {
    if (self.privateActivityRides == nil) {
        self.privateActivityRides = [[NSMutableArray alloc] init];
    }
    return self.privateActivityRides;
}

-(NSMutableArray *)privateCampusRides {
    
    if (self.privateCampusRides == nil) {
        self.privateCampusRides = [[NSMutableArray alloc] init];
    }
    return self.privateCampusRides;
}

-(NSMutableArray *)privateActivityRidesNearby {
    if (self.privateActivityRidesNearby == nil) {
        self.privateActivityRidesNearby = [[NSMutableArray alloc] init];
    }
    return self.privateActivityRidesNearby;
}

-(NSMutableArray *)privateActivityRidesFavorites {
    if (self.privateActivityRidesFavorites == nil) {
        self.privateActivityRidesFavorites = [[NSMutableArray alloc] init];
    }
    return self.privateActivityRidesFavorites;
}

-(NSMutableArray *)privateCampusRidesFavorites {
    if (self.privateCampusRidesFavorites == nil) {
        self.privateCampusRidesFavorites = [[NSMutableArray alloc] init];
    }
    return self.privateCampusRidesFavorites;
}

-(NSMutableArray *)privateCampusRidesNearby {
    if (self.privateCampusRidesNearby == nil) {
        self.privateCampusRidesNearby = [[NSMutableArray alloc] init];
    }
    return self.privateCampusRidesNearby;
    
}

@end

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
@property (nonatomic) NSMutableArray *privatePastRides;
@property (nonatomic) NSMutableArray *userRideRequests;

@property (nonatomic) NSMutableArray *privateCampusRidesNearby;
@property (nonatomic) NSMutableArray *privateActivityRidesNearby;
@property (nonatomic) NSMutableArray *privateActivityRidesFavorites;
@property (nonatomic) NSMutableArray *privateCampusRidesFavorites;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSMutableArray *observers;

@property (nonatomic, strong) CLLocation *lastLocation;

@end

@implementation RidesStore

static int page = 0;

-(instancetype)init {
    self = [super init];
    if (self) {
        self.observers = [[NSMutableArray alloc] init];
        [self initAllRidesFromCoreData];
        
        [self fetchNewRides:^(BOOL fetched) {
            if (fetched) {
                [self initAllRidesFromCoreData];
            }
        }];
        
        // check asynchronously if the ride was removed from the database, and then remove it from core data as well
        // add a method that will send a list of id of rides in the db, and in return will get a list of rides that need to be deleted
    }
    return self;
}

-(void)initAllRidesFromCoreData {
    [self loadAllRidesFromCoreData];
    [self fetchLocationForAllRides];
    [self filterAllRides]; // categorize rides to rides around me and my rides
}

-(void)loadAllRidesFromCoreData {
    [self loadRidesFromCoreDataByType:ContentTypeActivityRides];
    [self loadRidesFromCoreDataByType:ContentTypeCampusRides];
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
-(void)loadRidesFromCoreDataByType:(ContentType)contentType {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Ride"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    NSPredicate *predicate;
    NSDate *now = [NSDate date];
    predicate = [NSPredicate predicateWithFormat:@"(rideType = %d) AND (departureTime > %@)", contentType, now];
    
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

// fetch all past rides
-(void)fetchPastRidesFromCoreDataByType {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Ride"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    NSPredicate *predicate;
    NSDate *now = [NSDate date];
    predicate = [NSPredicate predicateWithFormat:@"departureTime <= %@", now];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"departureTime" ascending:NO];
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
    self.privatePastRides = [[NSMutableArray alloc] initWithArray:fetchedObjects];
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
    self.privatePastRides = [[NSMutableArray alloc] initWithArray:fetchedObjects];
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
    return [self rideRequests];
}

-(void)fetchNewRides:(boolCompletionHandler)block {
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    //    [objectManager.HTTPClient setDefaultHeader:@"Authorization: Basic" value:[self encryptCredentialsWithEmail:self.emailTextField.text password:self.passwordTextField.text]];
    
    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"/api/v2/rides?page=%d", page] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if ([[mappingResult array] count] > 0) {
            page++;
        }
        block(YES);
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
    
    if ([[RidesStore sharedStore].allRides containsObject:ride]) {
        return;
    }
    
    int index = 0;
    if ([ride.rideType intValue] == ContentTypeCampusRides) {
        for (Ride *existingRide in [self campusRides]) {
            if ([ride.departureTime compare:existingRide.departureTime] == NSOrderedAscending) {
                break;
            } else {
                index++;
            }
        }
        [[self campusRides] insertObject:ride atIndex:index];
    } else {
        for (Ride *existingRide in [self activityRides]) {
            if (ride.departureTime < existingRide.departureTime) {
                break;
            } else {
                index++;
            }
        }
        [[self activityRides] insertObject:ride atIndex:index];
    }
    
    if ([self checkIfRideFavourite:ride]) {
        [self addFavoriteRide:ride];
    }
    
    [self checkIfRideNearby:ride block:^(BOOL isNearby) {
        if (isNearby) {
            [self addNearbyRide:ride];
        }
    }];
}


-(void)saveToPersistentStore:(Ride *)ride {
    NSManagedObjectContext *context = ride.managedObjectContext;
    NSError *error;
    if (![context saveToPersistentStore:&error]) {
        NSLog(@"delete error %@", [error localizedDescription]);
    }
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
        [[self campusRides] removeObject:ride];
        [[self campusRidesFavorites] removeObject:ride];
        [[self campusRidesNearby] removeObject:ride];
    } else {
        [[self activityRides] removeObject:ride];
        [[self activityRidesFavorites] removeObject:ride];
        [[self activityRidesNearby] removeObject:ride];
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
    [[self rideRequests] removeObject:request];
}

# pragma mark - location and delegate methods

-(void)fetchLocationForAllRides {
    for(Ride *ride in [self allRides]) {
        [self fetchLocationForRide:ride block:^(BOOL fetched) {}];
    }
}

-(void)fetchLocationForRide:(Ride *)ride  block:(boolCompletionHandler)block {
    if ([ride.destinationLatitude doubleValue] != 0 && [ride.departureLatitude doubleValue] != 0) {
        block(YES);
    }
    else if ([ride.destinationLatitude doubleValue] == 0 || [ride.destinationLongitude doubleValue] == 0) {
        [[LocationController sharedInstance] fetchLocationForAddress:ride.destination completionHandler:^(CLLocation *location) {
            
            // todo: refactor and make it easier
            if (location != nil) {
                ride.destinationLatitude = [NSNumber numberWithDouble:location.coordinate.latitude];
                ride.destinationLongitude = [NSNumber numberWithDouble:location.coordinate.longitude];
                
                if (ride.destinationImage == nil) {
                    [self fetchImageForCurrentRide:ride];
                }
            }
            
            if ([ride.departureLatitude doubleValue] == 0 || [ride.departureLongitude doubleValue] == 0) {
                [[LocationController sharedInstance] fetchLocationForAddress:ride.departurePlace completionHandler:^(CLLocation *location) {
                    if (location != nil) {
                        ride.departureLatitude = [NSNumber numberWithDouble:location.coordinate.latitude];
                        ride.departureLongitude = [NSNumber numberWithDouble:location.coordinate.longitude];
                    }
                    block(YES);
                }];
            } else {
                block(YES);
            }
        }];
    } else {
        if ([ride.departureLatitude doubleValue] == 0 || [ride.departureLongitude doubleValue] == 0) {
            [[LocationController sharedInstance] fetchLocationForAddress:ride.departurePlace completionHandler:^(CLLocation *location) {
                if (location != nil) {
                    ride.departureLatitude = [NSNumber numberWithDouble:location.coordinate.latitude];
                    ride.departureLongitude = [NSNumber numberWithDouble:location.coordinate.longitude];
                }
                block(YES);
            }];
        } else {
            block(YES);
        }
    }
}


-(void)fetchImageForCurrentRide:(Ride *)ride {
    CLLocation *location = [LocationController locationFromLongitude:[ride.destinationLongitude doubleValue] latitude:[ride.destinationLatitude doubleValue]];
    [[PanoramioUtilities sharedInstance] fetchPhotoForLocation:location completionHandler:^(NSURL *imageUrl) {
        UIImage *retrievedImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:imageUrl]];
        ride.destinationImage = UIImagePNGRepresentation(retrievedImage);
        [self saveToPersistentStore:ride];
        [self notifyAllAboutNewImageForRideId:ride.rideId];
    }];
}
#pragma mark - utility functions

-(NSArray *)allRides {
    NSMutableArray *rides = [[NSMutableArray alloc] init];
    if([[self activityRides] count] >0 )
        [rides addObjectsFromArray:[self activityRides]];
    if([[self campusRides] count] > 0)
        [rides addObjectsFromArray:[self campusRides]];
    return rides;
}

#pragma mark - favorite rides

- (void)filterFavoriteRidesByType:(ContentType)rideType {
    // TODO: implement
}

- (NSInteger)addFavoriteRide:(Ride*)ride {
    int index = 0;
    if ([ride.rideType intValue] == ContentTypeActivityRides) {
        for (Ride *existingRide in [self activityRidesFavorites]) {
            if ([ride.departureTime compare:existingRide.departureTime] == NSOrderedAscending) {
                break;
            } else {
                index++;
            }
        }
        [[self activityRidesFavorites] insertObject:ride atIndex:index];
    } else if([ride.rideType intValue] == ContentTypeCampusRides) {
        for (Ride *existingRide in [self campusRidesFavorites]) {
            if ([ride.departureTime compare:existingRide.departureTime] == NSOrderedAscending) {
                break;
            } else {
                index++;
            }
        }
        [[self campusRidesFavorites] insertObject:ride atIndex:index];
    }
    return index;
}

-(NSArray *)favoriteRidesByType:(ContentType)contentType {
    if (contentType == ContentTypeActivityRides) {
        return [self activityRidesFavorites];
    } else if(contentType == ContentTypeCampusRides) {
        return [self campusRidesFavorites];
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
        [self checkIfRideNearby:ride block:^(BOOL isNearby) {
            if (isNearby) {
                [self addNearbyRide:ride];
            }
        }];
    }
}

- (void)addNearbyRide:(Ride*)ride{
    int index = 0;
    if ([ride.rideType intValue] == ContentTypeActivityRides) {
        if ([[self activityRidesNearby] containsObject:ride]) {
            return;
        }
        for (Ride *existingRide in [self activityRidesNearby]) {
            if ([ride.departureTime compare:existingRide.departureTime] == NSOrderedAscending) {
                break;
            } else {
                index++;
            }
        }
        [[self activityRidesNearby] insertObject:ride atIndex:index];
    } else if([ride.rideType intValue] == ContentTypeCampusRides) {
        if ([[self campusRidesNearby] containsObject:ride]) {
            return;
        }
        for (Ride *existingRide in [self campusRidesNearby]) {
            if ([ride.departureTime compare:existingRide.departureTime] == NSOrderedAscending) {
                break;
            } else {
                index++;
            }
        }
        [[self campusRidesNearby] insertObject:ride atIndex:index];
    }
}

-(NSArray *)ridesNearbyByType:(ContentType)contentType {
    if (contentType == ContentTypeActivityRides) {
        return [self activityRidesNearby];
    } else if(contentType == ContentTypeCampusRides) {
        return [self campusRidesNearby];
    }
    return nil;
}

-(BOOL)locationExists:(Ride *)ride {
    if ([ride.destinationLatitude doubleValue] == 0 || [ride.departureLatitude doubleValue] == 0) {
        return NO;
    }
    return YES;
}

-(void)checkIfRideNearby:(Ride *)ride block:(boolCompletionHandler)block{
    [self fetchLocationForRide:ride block:^(BOOL fetched) {
        if ([self locationsNearbyForRide:ride]) {
            block(YES);
        } else {
            block(NO);
        }
    }];
    
}

-(BOOL)locationsNearbyForRide:(Ride *)ride {
    CLLocation *currentLocation = [LocationController sharedInstance].currentLocation;
    if (currentLocation == nil) {
        return NO;
    }
    
    CLLocation *departureLocation = [LocationController locationFromLongitude:[ride.departureLongitude doubleValue] latitude:[ride.departureLatitude doubleValue]];
    CLLocation *destinationLocation = [LocationController locationFromLongitude:[ride.destinationLongitude doubleValue] latitude:[ride.destinationLatitude doubleValue]];
    
    if ([LocationController isLocation:currentLocation nearbyAnotherLocation:departureLocation thresholdInMeters:1000] || [LocationController isLocation:currentLocation nearbyAnotherLocation:destinationLocation thresholdInMeters:1000]) {
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
            return [self activityRides];
        case ContentTypeCampusRides:
            return [self campusRides];
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

-(void)didReceiveCurrentLocation:(CLLocation *)location {
    if (self.lastLocation == nil) {
        self.lastLocation = location;
    }
    
    // check here if previous location is away from current location more than 10km
    if(![LocationController isLocation:location nearbyAnotherLocation:self.lastLocation thresholdInMeters:10*1000]) {
        self.lastLocation = location;
        [self filterAllRides];
    }
}

-(void)removeObserver:(id<RideStoreDelegate>)observer {
    [self.observers removeObject:observer];
}


#pragma mark - getters with initializers

-(NSMutableArray *)activityRides {
    if (self.privateActivityRides == nil) {
        self.privateActivityRides = [[NSMutableArray alloc] init];
    }
    return self.privateActivityRides;
}

-(NSMutableArray *)campusRides {
    if (self.privateCampusRides == nil) {
        self.privateCampusRides = [[NSMutableArray alloc] init];
    }
    return self.privateCampusRides;
}

-(NSMutableArray *)pastRides {
    if (self.privatePastRides == nil) {
        self.privatePastRides = [[NSMutableArray alloc] init];
    }
    return self.privatePastRides;
}

-(NSMutableArray *)rideRequests {
    if (self.userRideRequests == nil) {
        self.userRideRequests = [[NSMutableArray alloc] init];
    }
    return self.userRideRequests;
}

-(NSMutableArray *)activityRidesNearby {
    if (self.privateActivityRidesNearby == nil) {
        self.privateActivityRidesNearby = [[NSMutableArray alloc] init];
    }
    return self.privateActivityRidesNearby;
}

-(NSMutableArray *)activityRidesFavorites {
    if (self.privateActivityRidesFavorites == nil) {
        self.privateActivityRidesFavorites = [[NSMutableArray alloc] init];
    }
    return self.privateActivityRidesFavorites;
}

-(NSMutableArray *)campusRidesFavorites {
    if (self.privateCampusRidesFavorites == nil) {
        self.privateCampusRidesFavorites = [[NSMutableArray alloc] init];
    }
    return self.privateCampusRidesFavorites;
}

-(NSMutableArray *)campusRidesNearby {
    if (self.privateCampusRidesNearby == nil) {
        self.privateCampusRidesNearby = [[NSMutableArray alloc] init];
    }
    return self.privateCampusRidesNearby;
    
}

@end

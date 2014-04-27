//
//  RidesStore.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RidesStore.h"
#import "Ride.h"

@interface RidesStore () <NSFetchedResultsControllerDelegate>

@property (nonatomic) NSMutableArray *campusRides;
@property (nonatomic) NSMutableArray *activityRides;
@property (nonatomic) NSMutableArray *rideRequests;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSMutableArray *observers;

@end

@implementation RidesStore

-(instancetype)init {
    self = [super init];
    if (self) {
        self.observers = [[NSMutableArray alloc] init];
        [self loadAllRides];
        
        //        if ([[self allRides] count] == 0) {
        
        [self fetchRidesFromWebservice:^(BOOL ridesFetched) {
            if(ridesFetched) {
                //[self loadAllRides];
                [self loadRidesByType:ContentTypeActivityRides];
                [self loadRidesByType:ContentTypeCampusRides];
                [self loadRidesByType:ContentTypeExistingRequests];
                //                    [self loadCampusRides];
                //                    [self loadAllRides];
                [self fetchLocationForAllRides];
            }
        }];
        //        }
    }
    return self;
}

-(void)loadAllRides {
    [self loadRidesByType:ContentTypeActivityRides];
    [self loadRidesByType:ContentTypeCampusRides];
    [self loadRidesByType:ContentTypeExistingRequests];
}

-(void)fetchLocationForAllRides {
    for(Ride *ride in self.allActivityRides) {
        NSLog(@"ri: %@", ride);
        NSLog(@"id: %d", ride.rideId);
        [self fetchLocationForRide:ride];
    }
    for(Ride *ride in [self allCampusRides]) {
        NSLog(@"id: %d", ride.rideId);
        [self fetchLocationForRide:ride];
    }
}
+(instancetype)sharedStore {
    static RidesStore *ridesStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ridesStore = [[self alloc] init];
    });
    return ridesStore;
}

-(void)loadRidesByType:(ContentType)contentType {
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
    NSArray *result = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    
    if(contentType == 0){
        self.campusRides =[[NSMutableArray alloc] initWithArray:result];
    }
    else if(contentType == 1) {
        self.activityRides = [[NSMutableArray alloc] initWithArray:result];
    }
    else if(contentType == 2) {
        self.rideRequests = [[NSMutableArray alloc] initWithArray:result];
    }
}

-(void)loadActivityRides {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Ride"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(rideType = %d)", 1];
    [request setPredicate:predicate];
    request.entity = e;
    
    NSError *error;
    NSArray *result = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    
    self.activityRides = [[NSMutableArray alloc] initWithArray:result];
    for (Ride *ride in self.activityRides) {
        NSLog(@"ride id is: %d", ride.rideId);
    }
}

-(void)loadCampusRides {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Ride"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(rideType = %d)", 0];
    [request setPredicate:predicate];
    request.entity = e;
    
    NSError *error;
    NSArray *result = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    
    self.campusRides = [[NSMutableArray alloc] initWithArray:result];
    for (Ride *ride in self.campusRides) {
        NSLog(@"ride id is: %d", ride.rideId);
    }
}


-(void)fetchRidesFromWebservice:(boolCompletionHandler)block {
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    //    [objectManager.HTTPClient setDefaultHeader:@"Authorization: Basic" value:[self encryptCredentialsWithEmail:self.emailTextField.text password:self.passwordTextField.text]];
    
    [objectManager getObjectsAtPath:API_RIDES parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"Successfully fetched rides.");
        block(YES);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Load failed with error: %@", error);
        block(NO);
    }];
}

-(void)addRideToStore:(Ride *)ride {
    switch (ride.rideType) {
        case ContentTypeActivityRides:
            [self.activityRides addObject:ride];
            break;
        case ContentTypeCampusRides:
            [self.campusRides addObject:ride];
            break;
        case ContentTypeExistingRequests:
            [self.rideRequests addObject:ride];
            break;
        default:
            break;
    }
}

-(void)fetchLocationForRide:(Ride *)ride {
    NSLog(@"Ride is: %@", ride);
    [[LocationController sharedInstance] fetchLocationForAddress:ride.destination rideId:ride.rideId];
}

-(NSArray *)allRidesByType:(ContentType)contentType {
    switch (contentType) {
        case ContentTypeActivityRides:
            return self.allActivityRides;
            break;
        case ContentTypeCampusRides:
            return self.campusRides;
            break;
        case ContentTypeExistingRequests:
            return self.activityRides;
            break;
    }
}

-(NSArray *)allCampusRides {
    if(!self.campusRides) {
        [self loadRidesByType:ContentTypeCampusRides];
    }
    return self.campusRides;
}

-(NSArray *)allActivityRides {
    if(!self.activityRides) {
        [self loadRidesByType:ContentTypeActivityRides];
    }
    return self.activityRides;
}

-(NSArray *)allRideRequests {
    if(!self.rideRequests) {
        [self loadRidesByType:ContentTypeExistingRequests];
    }
    return self.rideRequests;
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

-(void)didReceiveLocationForAddress:(CLLocation *)location rideId:(NSInteger)rideId{
    Ride *ride = [self getRideWithId:rideId];
    ride.destinationLatitude = location.coordinate.latitude;
    ride.destinationLongitude = location.coordinate.longitude;
    
    [self printAllRides];
    [[PanoramioUtilities sharedInstance] fetchPhotoForLocation:location rideId:rideId];
}

-(void)didReceivePhotoForLocation:(UIImage *)image rideId:(NSInteger)rideId{
    Ride *ride = [self getRideWithId:rideId];
    ride.destinationImage = image;
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
    if([[self allRideRequests] count] > 0)
        [rides addObjectsFromArray:[self allRideRequests]];
    return rides;
}

- (Ride *)getRideWithId:(NSInteger)rideId {
    
    for (Ride *ride in [self allRides]) {
        NSLog(@"Ride is %@", ride);
        NSLog(@"ride id: %d", rideId);
        if (ride.rideId == (int16_t)rideId) {
            return ride;
        }
    }
    return nil;
}

- (void)printAllRides {
    for (Ride *ride in [self allRides]) {
        NSLog(@"Ride: %@", ride);
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

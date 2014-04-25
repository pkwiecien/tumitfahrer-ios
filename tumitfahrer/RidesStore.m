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

@property (nonatomic) NSMutableArray *privateRides;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSMutableArray *observers;

@end

@implementation RidesStore

-(instancetype)init {
    self = [super init];
    if (self) {
        self.observers = [[NSMutableArray alloc] init];
        [self loadRides];
//        if ([self.privateRides count] == 0) {
            // TODO: introduce something like fetchNewRidesFromWebservic
        [self fetchRidesFromWebservice];
       /* } else {
            for (Ride *ride in self.privateRides) {
                [[LocationController sharedInstance] fetchLocationForAddress:ride.destination rideId:ride.rideId];
            }
        }*/
    }
    return self;
}

+(instancetype)sharedStore {
    static RidesStore *ridesStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ridesStore = [[self alloc] init];
    });
    return ridesStore;
}

-(void)loadRides {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Ride"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    request.entity = e;
    
    NSError *error;
    NSArray *result = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    
    self.privateRides = [[NSMutableArray alloc] initWithArray:result];
}

-(void)fetchRidesFromWebservice {
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
//    [objectManager.HTTPClient setDefaultHeader:@"Authorization: Basic" value:[self encryptCredentialsWithEmail:self.emailTextField.text password:self.passwordTextField.text]];
    
    [objectManager getObjectsAtPath:@"/api/v2/rides" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.privateRides = [NSMutableArray arrayWithArray:[mappingResult array]];
        
        for (Ride *ride in self.privateRides) {
            [[LocationController sharedInstance] fetchLocationForAddress:ride.destination rideId:ride.rideId];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Load failed with error: %@", error);
    }];
}

-(NSArray *)allRides {
    return self.privateRides;
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

- (Ride *)getRideWithId:(NSInteger)rideId {
    for (Ride *ride in self.allRides) {
        if (ride.rideId == rideId) {
            return ride;
        }
    }
    return nil;
}

- (void)printAllRides {
    for (Ride *ride in self.allRides) {
        NSLog(@"Ride: %@", ride);
    }
}

-(void)addRideToStore:(Ride *)ride {
    [self.privateRides addObject:ride];
    [[LocationController sharedInstance] fetchLocationForAddress:ride.destination rideId:ride.rideId];
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

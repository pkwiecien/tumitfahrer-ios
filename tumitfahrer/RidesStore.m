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
#import "IdsMapping.h"
#import "ActionManager.h"
#import "ActivityStore.h"
#import "BadgeUtilities.h"
#import "RecentPlaceUtilities.h"
#import "RecentPlace.h"
#import "Photo.h"

@interface RidesStore ()

@property (nonatomic) NSMutableArray *privateCampusRides;
@property (nonatomic) NSMutableArray *privateActivityRides;
@property (nonatomic) NSMutableArray *privatePastRides;
@property (nonatomic) NSMutableArray *privateUserPastRides;
@property (nonatomic) NSMutableArray *privateRideRequests;

@property (nonatomic) NSMutableArray *privateCampusRidesNearby;
@property (nonatomic) NSMutableArray *privateActivityRidesNearby;
@property (nonatomic) NSMutableArray *privateActivityRidesFavorites;
@property (nonatomic) NSMutableArray *privateCampusRidesFavorites;

@property (nonatomic, strong) NSMutableArray *observers;

@property (nonatomic, strong) CLLocation *lastLocation;

@end

@implementation RidesStore

static int activity_id = 0;

+(instancetype)sharedStore {
    static RidesStore *ridesStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ridesStore = [[self alloc] init];
    });
    return ridesStore;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        self.observers = [[NSMutableArray alloc] init];
        [self initAllRidesFromCoreData]; // load rides from core data
        
        [self fetchNewRides:^(BOOL fetched) { // try to load latest rides from webservice
            if (fetched) {
                [self initAllRidesFromCoreData];
            }
        }];
        
        // check if the ride was removed from the database, and then remove it from core data as well
        [self checkIfRidesExistInWebservice];
    }
    return self;
}

-(void)initAllRidesFromCoreData {
    [self loadAllRidesFromCoreData];
    [self filterAllRides]; // categorize rides to rides around me and my rides
    [self checkPhotoForEachRide];
}

-(void)initRidesByType:(NSInteger)rideType block:(boolCompletionHandler)block{
    [self loadRidesFromCoreDataByType:rideType];
    [self filterRidesByType:rideType];
    [self checkPhotoForEachRide];
    block(YES);
}

-(void)loadAllRidesFromCoreData {
    [self loadRidesFromCoreDataByType:ContentTypeActivityRides];
    [self loadRidesFromCoreDataByType:ContentTypeCampusRides];
}

-(void)checkPhotoForEachRide {
    for (Ride *ride in [self allRides]) {
        if (ride.destinationImage == nil) {
            [self fetchImageForCurrentRide:ride];
        }
    }
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
        
        for (Ride *ride in self.privateCampusRides) {
            NSLog(@"ride with id: %@ %@", ride.departureTime, ride.rideId);
        }
    }
    else if(contentType == ContentTypeActivityRides) {
        self.privateActivityRides = [[NSMutableArray alloc] initWithArray:fetchedObjects];
    }
}

// fetch all past rides
-(void)fetchPastRidesFromCoreData {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Ride"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    NSPredicate *predicate;
    NSDate *now = [ActionManager currentDate];
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

-(void)fetchUserPastRidesFromCoreData {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Ride"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    NSPredicate *predicate;
    NSDate *now = [NSDate date];
    predicate = [NSPredicate predicateWithFormat:@"(departureTime <= %@) AND (self.rideOwner.userId = %@)", now, [CurrentUser sharedInstance].user.userId];
    
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
    self.privateUserPastRides = [[NSMutableArray alloc] initWithArray:fetchedObjects];
}

- (NSArray *)fetchUserRequestsFromCoreDataForUserId:(NSNumber *)userId {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Request"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    NSDate *now = [ActionManager currentDate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(passengerId = %@) AND (self.requestedRide.departureTime >= %@)", userId, now];
    
    [request setPredicate:predicate];
    request.entity = e;
    
    NSError *error;
    NSArray *fetchedObjects = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!fetchedObjects) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    self.privateRideRequests = [[NSMutableArray alloc] initWithArray:fetchedObjects];
    return self.privateRideRequests;
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

+ (Request *)fetchRequestFromCoreDataWithId:(NSNumber *)requestId {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Request"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"requestId = %@", requestId];
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


-(NSArray *)fetchRegularRidesFromCoreDataWithId:(NSNumber *)regularRideId {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Ride"
                                         inManagedObjectContext:[RKManagedObjectStore defaultStore].
                              mainQueueManagedObjectContext];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(regularRideId = %@)", regularRideId];
    [request setPredicate:predicate];
    request.entity = e;
    
    NSError *error;
    NSArray *fetchedObjects = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
    if (!fetchedObjects) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    return [[NSMutableArray alloc] initWithArray:fetchedObjects];
}

-(void)fetchRidesForCurrentUser:(boolCompletionHandler)block {
    if ([CurrentUser sharedInstance].user == nil) {
        return;
    }
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager.HTTPClient setDefaultHeader:@"apiKey" value:[CurrentUser sharedInstance].user.apiKey];
    
    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"/api/v2/users/%@/rides", [CurrentUser sharedInstance].user.userId] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self updateBadgesWithType:ContentTypeCampusRides];
        [self updateBadgesWithType:ContentTypeActivityRides];
        block(YES);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Load failed with error: %@", error);
        block(NO);
    }];
}

-(void)fetchNewRides:(boolCompletionHandler)block {
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"/api/v2/rides?page=%d", activity_id] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if ([[mappingResult array] count] > 0) {
            activity_id++;
//            [self updateBadges];
        }
        block(YES);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Load failed with error: %@", error);
        block(NO);
    }];
}

-(void)fetchRidesfromDate:(NSDate *)date rideType:(NSInteger)rideType block:(boolCompletionHandler)block {

    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSDictionary *queryParams = @{@"from_date": date, @"ride_type" : [NSNumber numberWithInt:(int)rideType]};
    
    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"/api/v2/rides"] parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if ([[mappingResult array] count] > 0) {
            [self updateBadgesWithType:rideType];
        }
        block(YES);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Load failed with error: %@", error);
        block(NO);
    }];
}

-(void)updateBadgesWithType:(NSInteger)rideType {
    if (rideType == ContentTypeCampusRides) {
        [BadgeUtilities updateCampusDateInBadge:[ActionManager currentDate]];
    } else {
        [BadgeUtilities updateActivityDateInBadge:[ActionManager currentDate]];
    }
    [BadgeUtilities updateMyRidesDateInBadge:[ActionManager currentDate]];
}

-(void)fetchSingleRideFromWebserviceWithId:(NSNumber *)rideId block:(rideCompletionHandler)block {
    RKObjectManager *objectManager = [RKObjectManager sharedManager];

    [objectManager getObject:nil path:[NSString stringWithFormat:@"/api/v2/rides/%@", rideId] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        Ride *ride = [mappingResult firstObject];
        block(ride);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Load failed with error: %@", error);
        block(nil);
    }];
}

-(Ride *)containsRideWithId:(NSNumber *)rideId {
    for (Ride *ride in [self allRides]) {
        if ([ride.rideId isEqualToNumber:rideId]) {
            return ride;
        }
    }
    return nil;
}

-(void)checkIfRidesExistInWebservice {
    if ([CurrentUser sharedInstance].user == nil) {
        return;
    }
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager getObjectsAtPath:@"/api/v2/rides/ids" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        IdsMapping *mapping = [mappingResult firstObject];
        [self compareRides:mapping.ids];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Load failed with error: %@", error);
    }];
}

-(void)compareRides:(NSSet *)rideIds {
    NSArray *rides = [self allRides];
    for (Ride *ride in rides) {
        if (![rideIds containsObject:ride.rideId]) {
            [self deleteRideFromCoreData:ride];
        }
    }
}

# pragma mark - add and delete methods

-(void)addRideToStore:(Ride *)ride {
    
    if ([[self allRides] containsObject:ride]) {
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
    
    if ([self checkIfRideFavourite:ride recentPlacesFromCoreData:[RecentPlaceUtilities fetchPlacesFromCoreData]]) {
        [self addFavoriteRide:ride];
    }
    
    [self checkIfRideNearby:ride block:^(BOOL isNearby) {
        if (isNearby) {
            [self addNearbyRide:ride];
        }
    }];
}

+(void)initRide:(Ride *)ride block:(boolCompletionHandler)block{
    [[RidesStore sharedStore] fetchLocationForRide:ride block:^(BOOL fetched) {
        if (fetched) {
            block(YES);
        } else {
            block(NO);
        }
    }];
}

+(void)initRide:(Ride *)ride index:(NSInteger)index block:(completionHandlerWithIndex)block{
    [[RidesStore sharedStore] fetchLocationForRide:ride block:^(BOOL fetched) {
        if (fetched) {
            block(index);
        } else {
            block(-1);
        }
    }];
}

-(void)addRideRequestToStore:(Request *)request forRide:(Ride *)ride {
    
    // save to core data
    [ride addRequestsObject:request];
    [self saveToPersistentStore:ride];
    
}

-(void)addRideRequestToStore:(Request *)request {
    if ([[self rideRequests] containsObject:request]) {
        return;
    }
    
    int index = 0;
    for (Request *existingRequest in [self rideRequests]) {
        if ([request.requestedRide.departureTime compare:existingRequest.requestedRide.departureTime] == NSOrderedAscending) {
            break;
        } else {
            index++;
        }
    }
    
    // add to local store
    [[self rideRequests] insertObject:request atIndex:index];
}

#pragma mark - utility functions

# pragma mark - filter functions

-(void)filterAllRides {
    [self filterRidesByType:ContentTypeActivityRides];
    [self filterRidesByType:ContentTypeCampusRides];
}

-(void)filterRidesByType:(ContentType)contentType {
    [self filterFavoriteRidesByType:contentType];
    [self filterNearbyRidesByType:contentType];
}

#pragma mark - favorite rides

-(void)filterAllFavoriteRides {
    [self filterFavoriteRidesByType:ContentTypeCampusRides];
    [self filterFavoriteRidesByType:ContentTypeActivityRides];
}

- (void)filterFavoriteRidesByType:(ContentType)rideType {
    [self initFavoriteRidesByType:rideType];
    NSArray *recentPlaces = [RecentPlaceUtilities fetchPlacesFromCoreData];
    for (Ride *ride in [self allRides]) {
        if ([self checkIfRideFavourite:ride recentPlacesFromCoreData:recentPlaces]) {
            [self addFavoriteRide:ride];
        }
    }
}

-(void)initFavoriteRidesByType:(ContentType)rideType {
    if (rideType == ContentTypeActivityRides) {
        self.privateActivityRidesFavorites = [[NSMutableArray alloc] init];
    } else if(rideType == ContentTypeCampusRides) {
        self.privateCampusRidesFavorites = [[NSMutableArray alloc] init];
    }
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

-(BOOL)checkIfRideFavourite:(Ride*)ride recentPlacesFromCoreData:(NSArray *)recentPlaces{
    
    CLLocation *departureLocation = [[CLLocation alloc] initWithLatitude:[ride.departureLatitude doubleValue] longitude:[ride.departureLongitude doubleValue]];
    CLLocation *destinationLocation = [[CLLocation alloc] initWithLatitude:[ride.departureLatitude doubleValue] longitude:[ride.departureLongitude doubleValue]];
    
    for (RecentPlace *recentPlace in recentPlaces) {
        CLLocation *recentPlaceLocation = [[CLLocation alloc] initWithLatitude:[recentPlace.placeLatitude doubleValue] longitude:[recentPlace.placeLongitude doubleValue]];
        
        if([LocationController isLocation:recentPlaceLocation nearbyAnotherLocation:departureLocation thresholdInMeters:5000] || [LocationController isLocation:recentPlaceLocation nearbyAnotherLocation:destinationLocation thresholdInMeters:5000]) {
            return YES;
        }
    }
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

// add nearby ride to the array with nearby rides. Rides are ordered by departure place, so in the loop determine the right location
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
    if ([ride.destinationLatitude doubleValue] == 0 || [ride.departureLatitude doubleValue] == 0 || [ride.departureLongitude doubleValue] == 0 || [ride.destinationLongitude doubleValue] == 0) {
        return NO;
    }
    return YES;
}

-(void)checkIfRideNearby:(Ride *)ride block:(boolCompletionHandler)block{
    [self fetchLocationForRide:ride block:^(BOOL fetched) {
        if ([self isCurrentLocationNearbyRide:ride]) {
            block(YES);
        } else {
            block(NO);
        }
    }];
}

# pragma mark - location and delegate methods

-(void)fetchLocationForRide:(Ride *)ride  block:(boolCompletionHandler)block {
    
    if ([self locationExists:ride]) {
        block(YES);
    }
    else if ([ride.destinationLatitude doubleValue] == 0) {
        [[LocationController sharedInstance] fetchLocationForAddress:ride.destination completionHandler:^(CLLocation *location) {
            
            if (location != nil) {
                ride.destinationLatitude = [NSNumber numberWithDouble:location.coordinate.latitude];
                ride.destinationLongitude = [NSNumber numberWithDouble:location.coordinate.longitude];
                if (ride.destinationImage == nil) {
                    [self fetchImageForCurrentRide:ride];
                }
            }
            
            if ([ride.departureLatitude doubleValue] == 0) {
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
    [[PanoramioUtilities sharedInstance] fetchPhotoForLocation:location completionHandler:^(Photo *photo) {
        if (photo != nil) {
            NSURL *photoUrl = [NSURL URLWithString:photo.photoFileUrl];
            UIImage *retrievedImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:photoUrl]];
            [self setImage:retrievedImage photoInfo:photo forRide:ride];
        }
    }];
}

-(void)setImage:(UIImage *)image photoInfo:(Photo *)photoInfo forRide:(Ride *)ride {
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    ride.destinationImage = data;
    ride.photo = photoInfo;
    [self saveToPersistentStore:ride];
    [self notifyAllAboutNewImageForRideId:ride.rideId];
}

-(BOOL)isCurrentLocationNearbyRide:(Ride *)ride {
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

# pragma mark - all rides functions

-(NSArray *)allRides {
    NSMutableArray *rides = [[NSMutableArray alloc] init];
    if([[self activityRides] count] >0 )
        [rides addObjectsFromArray:[self activityRides]];
    if([[self campusRides] count] > 0)
        [rides addObjectsFromArray:[self campusRides]];
    return rides;
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

# pragma mark - persistent store methods

-(void)saveToPersistentStore:(Ride *)ride {
    NSManagedObjectContext *context = ride.managedObjectContext;
    NSError *error;
    if (![context saveToPersistentStore:&error]) {
        NSLog(@"saving error %@", [error localizedDescription]);
    }
}


-(void)deleteRideFromCoreData:(Ride *)ride {
    [self deleteRideFromLocalStore:ride];
    [[ActivityStore sharedStore] deleteRideFromActivites:ride];
    
    NSManagedObjectContext *context = ride.managedObjectContext;
    [context deleteObject:ride];
    NSError *error;
    if (![context saveToPersistentStore:&error]) {
        NSLog(@"delete error %@", [error localizedDescription]);
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

-(void)deleteRideRequest:(Request *)request {
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

-(Request *)getRequestForPassengerWithId:(NSNumber *)passengerId ride:(Ride *)ride{
    for(Request *currentRequest in [ride.requests allObjects]) {
        if ([[currentRequest passengerId] isEqualToNumber:passengerId]) {
            return currentRequest;
        }
    }
    return nil;
}

-(BOOL)addPassengerForRideId:(NSNumber *)rideId requestor:(User *)requestor {
    Ride *ride = [self containsRideWithId:rideId];
    [ride addPassengersObject:requestor];
    
    Request *requestToBeRemoved = [self getRequestForPassengerWithId:requestor.userId ride:ride];
    if (requestToBeRemoved != nil) {
        [ride removeRequestsObject:requestToBeRemoved];
        [self saveToPersistentStore:ride];
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)removeRequestForRide:(NSNumber *)rideId request:(Request *)request {
    Ride *ride = [self containsRideWithId:rideId];
    [ride removeRequestsObject:request];
    [self saveToPersistentStore:ride];
    return YES;
}

-(BOOL)removePassengerForRide:(NSNumber *)rideId passenger:(User *)passenger {
    Ride *ride = [self containsRideWithId:rideId];
    [ride removePassengersObject:passenger];
    [self saveToPersistentStore:ride];
    return true;
}

+(void)updateLastSeenTime:(Ride *)ride {
    if (ride != nil) {
        ride.lastSeenTime = [NSDate date];
        [[RidesStore sharedStore] saveToPersistentStore:ride];
    }
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

-(NSMutableArray *)userPastRides {
    if (self.privateUserPastRides == nil) {
        self.privateUserPastRides = [[NSMutableArray alloc] init];
    }
    return self.privateUserPastRides;
}

-(NSMutableArray *)rideRequests {
    if (self.privateRideRequests == nil) {
        self.privateRideRequests = [[NSMutableArray alloc] init];
    }
    return self.privateRideRequests;
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

-(void)dealloc {
    for (id<RideStoreDelegate> observer in self.observers) {
        [self removeObserver:observer];
    }
}

@end

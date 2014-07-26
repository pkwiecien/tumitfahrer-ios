//
//  PanoramioUtilities.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "PanoramioUtilities.h"
#import "LocationController.h"
#import "AppDelegate.h"
#import "Photo.h"
#import "Ride.h"

@interface PanoramioUtilities ()

@property (nonatomic, strong) NSMutableArray *observers;
@property (nonatomic, assign) NSInteger requestCounter;

@end

@implementation PanoramioUtilities

-(instancetype)init {
    self = [super init];
    if (self) {
        self.observers = [[NSMutableArray alloc] init];
        self.requestCounter = 1;
    }
    return self;
}

+(PanoramioUtilities *)sharedInstance {
    static PanoramioUtilities *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

# pragma mark - build requests and fetch methods

- (NSDictionary*)queryParams:(CLLocation *)location {
    
    NSDictionary *queryParams = @{@"set": @"public", @"from" : @"0", @"to": @"1", @"minx" : [NSNumber numberWithFloat:location.coordinate.longitude], @"miny" : [NSNumber numberWithFloat:location.coordinate.latitude], @"maxx" : [NSNumber numberWithFloat:(location.coordinate.longitude+0.0005*pow(4, self.requestCounter))], @"maxy" : [NSNumber numberWithFloat:(location.coordinate.latitude+0.0005*pow(4, self.requestCounter))], @"size" : @"medium", @"mapfilter" : @YES};
    self.requestCounter++;
    return queryParams;
}

-(void)fetchPhotoForLocation:(CLLocation *)location completionHandler:(photoCompletionHandler)block {
    
    if (self.requestCounter > 3) {
        self.requestCounter = 1;
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [delegate.panoramioObjectManager getObjectsAtPath:@"/map/get_panoramas.php" parameters:[self queryParams:location] success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        Photo *photo = [mappingResult firstObject];
        if (photo != nil) {
            self.requestCounter = 1;
            block(photo);
        } else {
            [self fetchPhotoForLocation:location completionHandler:^(Photo * photo) {
                block(photo);
            }];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Could not received photo with error: %@", error);
        block(nil);
    }];
}

# pragma mark - observer methods

-(void)addObserver:(id<LocationControllerDelegate>)observer {
    [self.observers addObject:observer];
}

-(void)notifyWithImage:(UIImage*)image {
    for (id<PanoramioUtilitiesDelegate> observer in self.observers) {
        if ([observer respondsToSelector:@selector(didReceivePhotoForCurrentLocation:)]) {
            [observer didReceivePhotoForCurrentLocation:image];
        }
    }
}

-(void)notifyAllAboutNewImage:(UIImage *)image rideId:(NSNumber *)rideId {
    for (id<PanoramioUtilitiesDelegate> observer in self.observers) {
        if ([observer respondsToSelector:@selector(didReceivePhotoForLocation:rideId:)]) {
            [observer didReceivePhotoForLocation:image rideId:rideId];
        }
    }
}

-(void)removeObserver:(id<PanoramioUtilitiesDelegate>)observer {
    [self.observers removeObject:observer];
}

@end

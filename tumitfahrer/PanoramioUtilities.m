//
//  PanoramioUtilities.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "PanoramioUtilities.h"
#import "LocationController.h"

@interface PanoramioUtilities ()

@property (nonatomic, strong) NSMutableArray *observers;

@end

@implementation PanoramioUtilities

-(instancetype)init {
    self = [super init];
    if (self) {
        self.observers = [[NSMutableArray alloc] init];
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

- (NSURLRequest*)buildUrlRequestWithLocation:(CLLocation *)location {
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.panoramio.com/map/get_panoramas.php?set=public&from=0&to=1&minx=%f&miny=%f&maxx=%f&maxy=%f&size=medium&mapfilter=true", location.coordinate.longitude, location.coordinate.latitude, location.coordinate.longitude+0.02, location.coordinate.latitude+0.02];
    NSLog(@"request: %@", urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    return urlRequest;
}

-(void)fetchPhotoForCurrentLocation:(CLLocation *)location {
    
    [NSURLConnection sendAsynchronousRequest:[self buildUrlRequestWithLocation:location] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError)
        {
            NSLog(@"Error connecting data from server: %@", connectionError.localizedDescription);
        } else {
            NSLog(@"Response data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            
            NSError *localError = nil;
            if (localError) {
                return;
            }
            
            // parse json
            NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            NSLog(@"photo url: %@", parsedObject[@"photos"][0][@"photo_file_url"]);
            NSURL *url = [[NSURL alloc] initWithString:parsedObject[@"photos"][0][@"photo_file_url"]];
            
            UIImage *retrievedImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
            [LocationController sharedInstance].locationImage = retrievedImage;
            
            // notify observers about retrieved image
            [self notifyWithImage:retrievedImage];
        }
    }];
    
}
-(void)fetchPhotoForLocation:(CLLocation *)location rideId:(NSInteger)rideId {
    
    [NSURLConnection sendAsynchronousRequest:[self buildUrlRequestWithLocation:location] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError)
        {
            NSLog(@"Error connecting data from server: %@", connectionError.localizedDescription);
        } else {
            NSLog(@"Response data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            
            NSError *localError = nil;
            if (localError) {
                return;
            }
            
            // parse json
            NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            @try {
                NSLog(@"request was: %@", [[self buildUrlRequestWithLocation:location] URL]);
                NSLog(@"parsed object: %@", parsedObject);
                NSLog(@"photo url: %@", parsedObject[@"photos"][0][@"photo_file_url"]);
                NSURL *url = [[NSURL alloc] initWithString:parsedObject[@"photos"][0][@"photo_file_url"]];
                
                UIImage *retrievedImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
                [self notifyAllAboutNewImage:retrievedImage rideId:rideId];
            }
            @catch (NSException *exception) {
                NSLog(@"Photo could not be received for location: %@", location);
            }
        }
    }];
}

# pragma mark - observer methods

-(void)didReceiveCurrentLocation:(CLLocation *)location {
    [self fetchPhotoForCurrentLocation:location];
}

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

-(void)notifyAllAboutNewImage:(UIImage *)image rideId:(NSInteger)rideId {
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

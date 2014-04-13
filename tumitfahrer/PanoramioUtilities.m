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

- (NSURLRequest*)buildUrlRequestWithLocation:(CLLocation *)location {
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.panoramio.com/map/get_panoramas.php?set=public&from=0&to=1&minx=%f&miny=%f&maxx=%f&maxy=%f&size=medium&mapfilter=true", location.coordinate.longitude, location.coordinate.latitude, location.coordinate.longitude+0.02, location.coordinate.latitude+0.02];
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
            NSLog(@"photo url: %@", parsedObject[@"photos"][0][@"photo_file_url"]);
            NSURL *url = [[NSURL alloc] initWithString:parsedObject[@"photos"][0][@"photo_file_url"]];
            
            UIImage *retrievedImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
            [LocationController sharedInstance].locationImage = retrievedImage;
        }
    }];
}

-(void)didReceiveCurrentLocation:(CLLocation *)location {
    [self fetchPhotoForCurrentLocation:location];
}

# pragma mark - observer methods
-(void)addObserver:(id<LocationControllerDelegate>)observer {
    [self.observers addObject:observer];
}

-(void)notifyWithImage:(UIImage*)image {
    for (id<PanoramioUtilitiesDelegate> observer in self.observers) {
        [observer didReceivePhotoForCurrentLocation:image];
    }
}

-(void)removeObserver:(id<PanoramioUtilitiesDelegate>)observer {
    [self.observers removeObject:observer];
}

@end

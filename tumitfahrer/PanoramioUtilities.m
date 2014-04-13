//
//  PanoramioUtilities.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "PanoramioUtilities.h"
#import "LocationController.h"

@implementation PanoramioUtilities

-(instancetype)init {
    self = [super init];
    if (self) {
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

- (UIImage*)fetchPhotoForLocation:(CLLocation*)location rideId:(NSInteger)rideId{

    __block UIImage *retrievedImage = nil;
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.panoramio.com/map/get_panoramas.php?set=public&from=0&to=1&minx=%f&miny=%f&maxx=%f&maxy=%f&size=medium&mapfilter=true", location.coordinate.longitude, location.coordinate.latitude, location.coordinate.longitude+0.02, location.coordinate.latitude+0.02];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
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
            
            retrievedImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
            [LocationController sharedInstance].locationImage = retrievedImage;
            [self.delegate didReceivePhotoForLocation:retrievedImage rideId:rideId];
        }
    }];
    
    return retrievedImage;
}

@end

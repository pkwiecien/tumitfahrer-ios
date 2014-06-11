//
//  MKAnnotation+Annotation.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/30/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface CustomAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    id annotationObject;
    RideMode rideMode;
}


@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) RideMode rideMode;
@property id annotationObject;

@end

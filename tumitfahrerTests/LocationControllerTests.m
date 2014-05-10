//
//  LocationControllerTests.m
//  tumitfahrer
//
//  Created by Automotive Service Lab on 09/05/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LocationController.h"
#import "RideRequestsViewController.h"
#import <OCMock/OCMock.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationControllerTests : XCTestCase<LocationControllerDelegate>

@end

@implementation LocationControllerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFetchLocationForAddress
{
    [[LocationController sharedInstance] addObserver:self];
    [[LocationController sharedInstance] fetchLocationForAddress:@"Garching" rideId:0];
    
    // somehow the inner block of fetchLocationForAddress is not called during a test
    // you need to find a way how to test asynchronous calls
}

- (void)didReceiveLocationForAddress:(CLLocation *)location rideId:(NSInteger)rideId{
    CLGeocoder *geocoder =[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error){
            NSLog(@"Geocoder get error %@", error);
            return ;
        }
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        NSLog(@"placemark.ISOcountryCode %@", placemark.ISOcountryCode);
        XCTAssertTrue([placemark.administrativeArea isEqualToString:@"Bavaria"], @"Location wrong");
    }];
}

@end

//
//  JoinRideTest.m
//  tumitfahrer
//
//  Created by Automotive Service Lab on 22/06/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "JoinRideTest.h"

@implementation JoinRideTest


-(void)beforeAll
{
    [tester tapViewWithAccessibilityLabel:@"Left Drawer Button"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Menu View"];
}

-(void)testJoinRide
{
    
}

@end

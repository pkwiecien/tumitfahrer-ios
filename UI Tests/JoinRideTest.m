//
//  JoinRideTest.m
//  tumitfahrer
//
//  Created by Automotive Service Lab on 22/06/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "JoinRideTest.h"
#import "KIFUITestActor+EXAdditions.h"
@implementation JoinRideTest


-(void)beforeAll
{
//    [tester tapViewWithAccessibilityLabel:@"Left Drawer Button"];
//    [tester waitForTappableViewWithAccessibilityLabel:@"Menu View"];
}

// test case of join ride
-(void)testJoinRide
{
////before join ride, add a new ride
//[self createRide];
////logout as user 1 and relogin as user 2
//[self logout];
//[self reLogin:@"zds8978704@gmail.com" password:@"123456"];
////join the ride which is just added
//[self joinRide];
////logout as user 2 and relogin as user 1
//[self logout];
//[self reLogin:@"tumitfahrer@gmail.com" password:@"123456"];
////owner accept the join
//[self ownerAgree];
////owner reject the join
//[self ownerDelete];
}

// add new ride before join as use 1
-(void)createRide
{
    [tester addRideAsDriverWithCampusRide];
}

// logout
-(void)logout
{
    [tester tapViewWithAccessibilityLabel:@"Setting Button"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Setting View"];
    
    [tester tapViewWithAccessibilityLabel:@"Logout Button"];
}

//login as another user
-(void)reLogin:(NSString *)email password:(NSString *)password
{
    [tester clearTextFromAndThenEnterText:email intoViewWithAccessibilityLabel:@"Login Email"];
    
    [tester enterText:password intoViewWithAccessibilityLabel:@"Login Password"];
    [tester tapViewWithAccessibilityLabel:@"Login Button"];

    [tester waitForTappableViewWithAccessibilityLabel:@"Setting View"];
        [tester tapViewWithAccessibilityLabel:@"Menu Button"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Menu View"];
}

// search ride and join ride
-(void)joinRide
{
    [tester searchRideWithCampusRideWithRadius0WithTime];
    
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"Search Result List"];
    [tester waitForViewWithAccessibilityLabel:@"Offer View"];
    
    [tester tapViewWithAccessibilityLabel:@"Join Ride Button"];
    
    [tester waitForTimeInterval:1];
    CGPoint select;
    select.x = 25;
    select.y = 25;
    [tester tapScreenAtPoint:select];
    
    [tester waitForTimeInterval:1];
    select.x = 25;
    select.y = 25;
    [tester tapScreenAtPoint:select];
    [tester waitForTimeInterval:1];
    
    [tester tapViewWithAccessibilityLabel:@"Left Drawer Button"];
}

// owner accept the join
-(void)ownerAgree
{
    [tester searchRideWithCampusRideWithRadius0WithTime];
    
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"Search Result List"];
    [tester waitForViewWithAccessibilityLabel:@"Owner Offer View"];
    
    [tester tapViewWithAccessibilityLabel:@"Accept Button"];
    [tester waitForViewWithAccessibilityLabel:@"Owner Offer View"];
}

// owner reject the join
-(void)ownerDelete
{
    [tester searchRideWithCampusRideWithRadius0WithTime];
    
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"Search Result List"];
    [tester waitForViewWithAccessibilityLabel:@"Owner Offer View"];
    
    [tester tapViewWithAccessibilityLabel:@"Delete Button"];
    [tester waitForViewWithAccessibilityLabel:@"Owner Offer View"];
}


@end

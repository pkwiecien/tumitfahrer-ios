//
//  AddRideTest.m
//  tumitfahrer
//
//  Created by Automotive Service Lab on 15/06/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "AddRideTest.h"

NSInteger const kDESTINATION_ADD = 2;
NSInteger const kDEPARTURE_ADD = 1;
NSInteger const kDESTINATION_SEARCH = 5;
NSInteger const kDEPARTURE_SEARCH = 3;
@implementation AddRideTest


-(void)beforeAll
{
    [tester tapViewWithAccessibilityLabel:@"Left Drawer Button"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Menu View"];
}

-(void)afterEach
{
    [tester tapViewWithAccessibilityLabel:@"Back Button"];
    [tester tapViewWithAccessibilityLabel:@"Left Drawer Button"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Menu View"];
}

-(void)testAddRideAsPassengerWithCampusRide
{
    [self selectAddRide];
    [self selectPassenger];
    [self selectPlace:0 section:0 type:kDEPARTURE_ADD];
    [self selectPlace:1 section:0 type:kDESTINATION_ADD];

    
    [self selectDate:@[@"Jun 25", @"6", @"30", @"AM"]];
    [self selectMeetPoint:@"Mensa" driver:NO];
    [self selectShare];
    
    [self addRideAsPassenger];
    //TODO To be continued
    [tester tapViewWithAccessibilityLabel:@"Back Button"];
    [tester tapViewWithAccessibilityLabel:@"Left Drawer Button"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Menu View"];
    [self searchRideWithCampusRide];
}

//-(void)testAddRideAsPassengerWithCampusRideWithSearch
//{
//    [self selectAddRide];
//    [self selectPassenger];
//    [self searchPlace:0 section:1 address:@"Garching" type:kDEPARTURE_ADD];
//    [self searchPlace:0 section:1 address:@"Munich" type:kDESTINATION_ADD];
//
//    [self selectDate:@[@"Jun 17", @"6", @"30", @"AM"]];
//    [self selectMeetPoint:@"Mensa" driver:NO];
//    [self selectShare];
//    
//    [self addRideAsPassenger];
//    //TODO To be continued
//}

//-(void)testAddRideAsPassengerWithActivityRide
//{
//    [self selectAddRide];
//    [self selectPassenger];
//    [self selectPlace:0 section:0 type:kDEPARTURE_ADD];
//    [self selectPlace:1 section:0 type:kDESTINATION_ADD];
//    [self selectDate:@[@"Jun 17", @"6", @"30", @"AM"]];
//    [self selectMeetPoint:@"Mensa" driver:NO];
//    [self selectActivity];
//    [self selectShare];
//
//    [self addRideAsPassenger];
//
//    //TODO To be continued
//}

//-(void)testAddRideAsPassengerWithActivityRideWithSearch
//{
//    [self selectAddRide];
//    [self selectPassenger];
//    [self searchPlace:0 section:1 address:@"Garching" type:kDEPARTURE_ADD];
//    [self searchPlace:0 section:1 address:@"Munich" type:kDESTINATION_ADD];
//    
//    [self selectDate:@[@"Jun 17", @"6", @"30", @"AM"]];
//    [self selectMeetPoint:@"Mensa" driver:NO];
//    [self selectActivity];
//    [self selectShare];
//    
//    [self addRideAsPassenger];
//    //TODO To be continued
//}

//-(void)testAddRideAsDriverWithCampusRide
//{
//    
//    [self selectAddRide];
//    [self selectPlace:0 section:0 type:kDEPARTURE];
//    [self selectPlace:1 section:0 type:kDESTINATION];
//    [self selectDate:@[@"Jun 30", @"6", @"30", @"AM"]];
//    [self selectSeatNumber:2];
//    [self selectCar:@"BMW i8"];
//    [self selectMeetPoint:@"Mensa" driver:YES];
//    [self selectShare];
//    
//    [self addRideAsDriver];
//   
//    //TODO To be continued
//}

//-(void)testAddRideAsDriverWithCampusRideWithSearch
//{
//
//    [self selectAddRide];
//    [self searchPlace:0 section:1 address:@"Garching" type:kDEPARTURE_ADD];
//    [self searchPlace:0 section:1 address:@"Munich" type:kDESTINATION_ADD];
//    [self selectDate:@[@"Jun 30", @"6", @"30", @"AM"]];
//    [self selectSeatNumber:2];
//    [self selectCar:@"BMW i8"];
//    [self selectMeetPoint:@"Mensa" driver:YES];
//    [self selectShare];
//
//    [self addRideAsDriver];
//
//    //TODO To be continued
//}

//-(void)testAddRideAsDriverWithActivityRide
//{
//    
//    [self selectAddRide];
//    [self selectPlace:0 section:0 type:kDEPARTURE];
//    [self selectPlace:1 section:0 type:kDESTINATION];
//    [self selectDate:@[@"Jun 30", @"6", @"30", @"AM"]];
//    [self selectSeatNumber:2];
//    [self selectCar:@"BMW i8"];
//    [self selectMeetPoint:@"Mensa" driver:YES];
//    [self selectActivity];
//    [self selectShare];
//    
//    [self addRideAsDriver];
//    
//    //TODO To be continued
//}

//-(void)testAddRideAsDriverWithActivityRideWithSearch
//{
//
//    [self selectAddRide];
//    [self searchPlace:0 section:1 address:@"Garching" type:kDEPARTURE_ADD];
//    [self searchPlace:0 section:1 address:@"Berlin" type:kDESTINATION_ADD];
//    [self selectDate:@[@"Jun 30", @"6", @"30", @"AM"]];
//    [self selectSeatNumber:2];
//    [self selectCar:@"BMW i8"];
//    [self selectMeetPoint:@"Mensa" driver:YES];
//    [self selectActivity];
//    [self selectShare];
//
//    [self addRideAsDriver];
//
//    //TODO To be continued
//}


-(void)searchRideWithCampusRide
{
    [self selectSearchRide];
    
    [self selectPlace:1 section:0 type:kDEPARTURE_SEARCH];
    [self selectPlace:2 section:0 type:kDESTINATION_SEARCH];
    
    [self search];
}


#pragma mark - test steps
-(void)selectAddRide
{
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] inTableViewWithAccessibilityIdentifier:@"Menu List"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}

-(void)selectSearchRide
{
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2] inTableViewWithAccessibilityIdentifier:@"Menu List"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Search Ride View"];
}
-(void)selectPassenger
{
    [tester tapViewWithAccessibilityLabel:@"Passenger Choice"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}

-(void)selectDriver
{
    [tester tapViewWithAccessibilityLabel:@"Driver Choice"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}

-(void)selectPlace:(NSInteger)row section:(NSInteger)section type:(NSInteger)type
{
    if(type == kDESTINATION_ADD || type == kDEPARTURE_ADD){
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:type inSection:0] inTableViewWithAccessibilityIdentifier:@"Add Ride List"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Destination View"];
    
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] inTableViewWithAccessibilityIdentifier:@"Destination List"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
    }else{
        [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:(type-2) inSection:0] inTableViewWithAccessibilityIdentifier:@"Search Ride List"];
        [tester waitForTappableViewWithAccessibilityLabel:@"Destination View"];
        
        [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] inTableViewWithAccessibilityIdentifier:@"Destination List"];
        [tester waitForTappableViewWithAccessibilityLabel:@"Search Ride View"];
        }
}

-(void)searchPlace:(NSInteger)row section:(NSInteger)section address:(NSString *)address type:(NSInteger)type
{
    if(type == kDEPARTURE_ADD || type == kDESTINATION_ADD){
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:type inSection:0] inTableViewWithAccessibilityIdentifier:@"Add Ride List"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Destination View"];
    
    [tester enterText:address intoViewWithAccessibilityLabel:@"Search Bar"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Destination View"];
    
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] inTableViewWithAccessibilityIdentifier:@"Destination List"];
        [tester waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];}
    else{
        [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:type inSection:0] inTableViewWithAccessibilityIdentifier:@"Search Ride List"];
        [tester waitForTappableViewWithAccessibilityLabel:@"Destination View"];
        
        [tester enterText:address intoViewWithAccessibilityLabel:@"Search Bar"];
        [tester waitForTappableViewWithAccessibilityLabel:@"Destination View"];
        
        [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] inTableViewWithAccessibilityIdentifier:@"Destination List"];
        [tester waitForTappableViewWithAccessibilityLabel:@"Search Ride View"];
    }
}

-(void)selectDate:(NSArray *)dateTime
{

    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] inTableViewWithAccessibilityIdentifier:@"Add Ride List"];
    
    CGPoint select;
    select.x = 250;
    select.y = 100;
    [tester tapScreenAtPoint:select];
    [tester tapViewWithAccessibilityLabel:@"Date Picker"];
    //NSArray *dateTime = @[@"Jun 17", @"6", @"30", @"AM"];
    [tester selectDatePickerValue:dateTime];
    // could not find a way to locat "Select" button, using stupid way to tap the button

    select.x = 250;
    select.y = 550;
    [tester tapScreenAtPoint:select];
    //[tester waitForViewWithAccessibilityLabel:@"Date Time Picker" value:@"Tuesday, Jun 17, 06:43 AM" traits:UIAccessibilityTraitNone];
    [tester waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}

-(void)selectMeetPoint:(NSString *)location driver:(Boolean) driver
{
    if(driver){
        [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] inTableViewWithAccessibilityIdentifier:@"Add Ride List"];
    }else{
        [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] inTableViewWithAccessibilityIdentifier:@"Add Ride List"];
    }
    
    [tester waitForTappableViewWithAccessibilityLabel:@"Meet Point View"];
    [tester enterText:location intoViewWithAccessibilityLabel:@"Meetpoint Text"];
    [tester tapViewWithAccessibilityLabel:@"Save Meetpoint Button"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}

-(void)selectCampus
{
    [tester tapViewWithAccessibilityLabel:@"Campus"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}

-(void)selectActivity
{
    [tester tapViewWithAccessibilityLabel:@"Activity"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}

-(void)selectShare
{
    //[tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] inTableViewWithAccessibilityIdentifier:@"Add Ride List"];
    //[tester setOn:YES forSwitchWithAccessibilityLabel:@"Facebook"];
//    
//    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1] inTableViewWithAccessibilityIdentifier:@"Add Ride List"];
//    [tester setOn:YES forSwitchWithAccessibilityLabel:@"Email"];
}

-(void)selectSeatNumber:(NSInteger)seat
{
    // increase the seat
    UIStepper *repsStepper = (UIStepper*)[tester waitForViewWithAccessibilityLabel:@"Seat Stepper"];
    CGPoint stepperCenter = [repsStepper.window convertPoint:repsStepper.center
                                                    fromView:repsStepper.superview];
    CGPoint minusButton = stepperCenter;
    minusButton.x -= CGRectGetWidth(repsStepper.frame) / 4;

    CGPoint plusButton = stepperCenter;
    plusButton.x += CGRectGetWidth(repsStepper.frame) / 4;
    
    for (NSInteger i = 0; i<seat+2; i++) {
        [tester tapScreenAtPoint:plusButton];
    }
    [tester tapScreenAtPoint:minusButton];
    [tester tapScreenAtPoint:minusButton];
}

-(void)selectCar:(NSString *)car
{
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] inTableViewWithAccessibilityIdentifier:@"Add Ride List"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Meet Point View"];
    [tester enterText:car intoViewWithAccessibilityLabel:@"Meetpoint Text"];
    [tester tapViewWithAccessibilityLabel:@"Save Meetpoint Button"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}

-(void)addRideAsPassenger
{
    [tester swipeViewWithAccessibilityLabel:@"Add Ride View" inDirection:KIFSwipeDirectionUp];
    [tester tapViewWithAccessibilityLabel:@"Add Button"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Owner Request View"];

}

-(void)addRideAsDriver
{
    [tester swipeViewWithAccessibilityLabel:@"Add Ride View" inDirection:KIFSwipeDirectionUp];
    [tester tapViewWithAccessibilityLabel:@"Add Button"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Owner Offer View"];
}

-(void)search
{
    [tester tapViewWithAccessibilityLabel:@"Search Button"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Search Result View"];
}

@end

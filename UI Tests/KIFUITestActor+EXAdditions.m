//
//  KIFUITestActor+EXAdditions.m
//  tumitfahrer
//
//  Created by Automotive Service Lab on 02/07/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "KIFUITestActor+EXAdditions.h"
NSInteger const kDESTINATION_ADD = 2;
NSInteger const kDEPARTURE_ADD = 1;
NSInteger const kDESTINATION_SEARCH = 5;
NSInteger const kDEPARTURE_SEARCH = 3;
@implementation KIFUITestActor (EXAdditions)

#pragma mark - test cases
// add new campus ride as a passenger with choosing destination and departure from the suggestions
-(void)addRideAsPassengerWithCampusRide
{
    [self selectAddRide];
    [self selectPassenger];
    [self selectPlace:0 section:0 type:kDEPARTURE_ADD];
    [self selectPlace:1 section:0 type:kDESTINATION_ADD];
    
    [self selectDateByPoint];
    [self selectMeetPoint:@"Mensa" driver:NO];
    [self selectShare];
    
    [self addRideAsPassenger];
}
// add new campus ride as a passenger with choosing destination and departure from the search
-(void)addRideAsPassengerWithCampusRideWithSearch
{
    [self selectAddRide];
    [self selectPassenger];
    [self searchPlace:0 section:1 address:@"Garching" type:kDEPARTURE_ADD];
    [self searchPlace:0 section:1 address:@"Munich" type:kDESTINATION_ADD];
    
    [self selectDateByPoint];
    [self selectMeetPoint:@"Mensa" driver:NO];
    [self selectShare];
    
    [self addRideAsPassenger];
    
}
// add new activity ride as a passenger with choosing destination and departure from the suggestions
-(void)addRideAsPassengerWithActivityRide
{
    [self selectAddRide];
    [self selectPassenger];
    [self selectPlace:0 section:0 type:kDEPARTURE_ADD];
    [self selectPlace:1 section:0 type:kDESTINATION_ADD];
    [self selectDateByPoint];
    [self selectMeetPoint:@"Mensa" driver:NO];
    [self selectActivity];
    [self selectShare];
    
    [self addRideAsPassenger];
}
// add new activity ride as a passenger with choosing destination and departure from the search
-(void)addRideAsPassengerWithActivityRideWithSearch
{
    [self selectAddRide];
    [self selectPassenger];
    [self searchPlace:0 section:1 address:@"Garching" type:kDEPARTURE_ADD];
    [self searchPlace:0 section:1 address:@"Munich" type:kDESTINATION_ADD];
    
    [self selectDateByPoint];
    [self selectMeetPoint:@"Mensa" driver:NO];
    [self selectActivity];
    [self selectShare];
    
    [self addRideAsPassenger];
}
// add new campus ride as a driver with choosing destination and departure from the suggestions
-(void)addRideAsDriverWithCampusRide
{
    
    [self selectAddRide];
    [self selectPlace:0 section:0 type:kDEPARTURE_ADD];
    [self selectPlace:1 section:0 type:kDESTINATION_ADD];
    [self selectDateByPoint];
    [self selectRepeat];
    [self selectSeatNumber:2];
    [self selectCar:@"BMW i8"];
    [self selectMeetPoint:@"Mensa" driver:YES];
    [self selectShare];
    
    [self addRideAsDriver];
}
// add new campus ride as a driver with choosing destination and departure from the search
-(void)addRideAsDriverWithCampusRideWithSearch
{
    
    [self selectAddRide];
    [self searchPlace:0 section:1 address:@"Garching" type:kDEPARTURE_ADD];
    [self searchPlace:0 section:1 address:@"Munich" type:kDESTINATION_ADD];
    [self selectDateByPoint];
    [self selectRepeat];
    [self selectSeatNumber:2];
    [self selectCar:@"BMW i8"];
    [self selectMeetPoint:@"Mensa" driver:YES];
    [self selectShare];
    
    [self addRideAsDriver];
}
// add new activity ride as a driver with choosing destination and departure from the suggestions
-(void)addRideAsDriverWithActivityRide
{
    
    [self selectAddRide];
    [self selectPlace:0 section:0 type:kDEPARTURE_ADD];
    [self selectPlace:1 section:0 type:kDESTINATION_ADD];
    [self selectDateByPoint];
    [self selectRepeat];
    [self selectSeatNumber:2];
    [self selectCar:@"BMW i8"];
    [self selectMeetPoint:@"Mensa" driver:YES];
    [self selectActivity];
    [self selectShare];
    
    [self addRideAsDriver];
}
// add new activity ride as a driver with choosing destination and departure from the search
-(void)addRideAsDriverWithActivityRideWithSearch
{
    
    [self selectAddRide];
    [self searchPlace:0 section:1 address:@"Garching" type:kDEPARTURE_ADD];
    [self searchPlace:0 section:1 address:@"Munich" type:kDESTINATION_ADD];
    [self selectDateByPoint];
    [self selectRepeat];
    [self selectSeatNumber:2];
    [self selectCar:@"BMW i8"];
    [self selectMeetPoint:@"Mensa" driver:YES];
    [self selectActivity];
    [self selectShare];
    
    [self addRideAsDriver];
}
// search campus ride with radius 0 without specific time and departure/destination from suggestions
-(void)searchRideWithCampusRideWithRadius0WithoutTime
{
    [self selectSearchRide];
    
    [self selectPlace:1 section:0 type:kDEPARTURE_SEARCH];
    [self sliderRadius:0 row:2];
    
    [self selectPlace:2 section:0 type:kDESTINATION_SEARCH];
    [self sliderRadius:0 row:4];
    
    [self search];
}
// search campus ride with radius 30 without specific time and departure/destination from suggestions
-(void)searchRideWithCampusRideWithRadius30WithoutTime
{
    [self selectSearchRide];
    
    [self selectPlace:1 section:0 type:kDEPARTURE_SEARCH];
    [self sliderRadius:30 row:2];
    
    [self selectPlace:2 section:0 type:kDESTINATION_SEARCH];
    [self sliderRadius:30 row:4];
    
    [self search];
}
// search campus ride with radius 30 with specific time and departure/destination from suggestions
-(void)searchRideWithCampusRideWithRadius30WithTime
{
    [self selectSearchRide];
    
    [self selectPlace:1 section:0 type:kDEPARTURE_SEARCH];
    [self sliderRadius:30 row:2];
    
    [self selectPlace:2 section:0 type:kDESTINATION_SEARCH];
    [self sliderRadius:30 row:4];
    [self selectDateByPointInSearch];
    
    [self search];
}
// search campus ride with radius 0 without specific time and departure/destination from suggestions
-(void)searchRideWithCampusRideWithRadius0WithTime
{
    [self selectSearchRide];
    
    [self selectPlace:1 section:0 type:kDEPARTURE_SEARCH];
    [self sliderRadius:0 row:2];
    
    [self selectPlace:2 section:0 type:kDESTINATION_SEARCH];
    [self sliderRadius:0 row:4];
    [self selectDateByPointInSearch];
    
    [self search];
}
// search campus ride with radius 0 with specific time and departure/destination from search
-(void)searchRideWithCampusRideWithRadius0WithTimeWithSearch
{
    [self selectSearchRide];
    
    [self searchPlace:0 section:1 address:@"Garching" type:kDEPARTURE_SEARCH];
    [self sliderRadius:0 row:2];
    
    [self searchPlace:0 section:1 address:@"Munich" type:kDESTINATION_SEARCH];
    [self sliderRadius:0 row:4];
    [self selectDateByPointInSearch];
    
    [self search];
}
// search activity ride with radius 0 with specific time and departure/destination from search
-(void)searchRideWithActivityRideWithRadius0WithTimeWithSearch
{
    [self selectSearchRide];
    [self selectActivity];
    
    [self searchPlace:0 section:1 address:@"Garching" type:kDEPARTURE_SEARCH];
    [self sliderRadius:0 row:2];
    
    [self searchPlace:0 section:1 address:@"Munich" type:kDESTINATION_SEARCH];
    [self sliderRadius:0 row:4];
    [self selectDateByPointInSearch];
    
    [self search];
}
// delete a request
-(void)deleteRideAsRequest
{
    // then choose the first one in list
    
    [self viewRideDetailAsRequestAndDelete];
    [self tapDeleteButtonInAlert];
}
// delete an offer
-(void)deleteRideAsOffer
{
    // then choose the first one in list
    [self viewRideDetailAsOfferAndDelete];
    [self tapDeleteButtonInAlert];
}

#pragma mark - test steps
// select add a ride in menu
-(void)selectAddRide
{
    [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] inTableViewWithAccessibilityIdentifier:@"Menu List"];
    [self waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}
// select search a ride in menu
-(void)selectSearchRide
{
    [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2] inTableViewWithAccessibilityIdentifier:@"Menu List"];
    [self waitForTappableViewWithAccessibilityLabel:@"Search Ride View"];
}
// select passenger in add ride view
-(void)selectPassenger
{
    [self tapViewWithAccessibilityLabel:@"Passenger Choice"];
    [self waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}
// select driver in add ride view
-(void)selectDriver
{
    [self tapViewWithAccessibilityLabel:@"Driver Choice"];
    [self waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}
// select places from suggestions
-(void)selectPlace:(NSInteger)row section:(NSInteger)section type:(NSInteger)type
{
    if(type == kDESTINATION_ADD || type == kDEPARTURE_ADD){
        [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:type inSection:0] inTableViewWithAccessibilityIdentifier:@"Add Ride List"];
        [self waitForTappableViewWithAccessibilityLabel:@"Destination View"];
        
        [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] inTableViewWithAccessibilityIdentifier:@"Destination List"];
        [self waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
    }else{
        [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:(type-2) inSection:0] inTableViewWithAccessibilityIdentifier:@"Search Ride List"];
        [self waitForTappableViewWithAccessibilityLabel:@"Destination View"];
        
        [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] inTableViewWithAccessibilityIdentifier:@"Destination List"];
        [self waitForTappableViewWithAccessibilityLabel:@"Search Ride View"];
    }
}
// select places from search
-(void)searchPlace:(NSInteger)row section:(NSInteger)section address:(NSString *)address type:(NSInteger)type
{
    if(type == kDEPARTURE_ADD || type == kDESTINATION_ADD){
        [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:type inSection:0] inTableViewWithAccessibilityIdentifier:@"Add Ride List"];
        [self waitForTappableViewWithAccessibilityLabel:@"Destination View"];
        
        [self enterText:address intoViewWithAccessibilityLabel:@"Search Bar"];
        [self waitForTappableViewWithAccessibilityLabel:@"Destination View"];
        
        [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] inTableViewWithAccessibilityIdentifier:@"Destination List"];
        [self waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];}
    else{
        [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:(type-2) inSection:0] inTableViewWithAccessibilityIdentifier:@"Search Ride List"];
        [self waitForTappableViewWithAccessibilityLabel:@"Destination View"];
        
        [self enterText:address intoViewWithAccessibilityLabel:@"Search Bar"];
        [self waitForTappableViewWithAccessibilityLabel:@"Destination View"];
        
        [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] inTableViewWithAccessibilityIdentifier:@"Destination List"];
        [self waitForTappableViewWithAccessibilityLabel:@"Search Ride View"];
    }
}
// select date time
-(void)selectDate:(NSArray *)dateTime
{
    
    [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] inTableViewWithAccessibilityIdentifier:@"Add Ride List"];
    
    CGPoint select;
    select.x = 250;
    select.y = 100;
    [self tapScreenAtPoint:select];
    [self tapViewWithAccessibilityLabel:@"Date Picker"];
    //NSArray *dateTime = @[@"Jun 17", @"6", @"30", @"AM"];
    [self selectDatePickerValue:dateTime];
    // could not find a way to locat "Select" button, using stupid way to tap the button
    
    select.x = 250;
    select.y = 550;
    [self tapScreenAtPoint:select];
    //[self waitForViewWithAccessibilityLabel:@"Date Time Picker" value:@"Tuesday, Jun 17, 06:43 AM" traits:UIAccessibilityTraitNone];
    [self waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}
// select date time, because a third party plugin of time picker is used, cannot use the original test from KIF, so a tap-point test is used
-(void)selectDateByPoint
{
    
    [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] inTableViewWithAccessibilityIdentifier:@"Add Ride List"];
    
    CGPoint select;
    select.x = 50;
    select.y = 450;
    [self tapScreenAtPoint:select];
    [self waitForTimeInterval:1];
    
    select.x = 200;
    select.y = 450;
    [self tapScreenAtPoint:select];
    [self waitForTimeInterval:1];
    
    select.x = 250;
    select.y = 550;
    [self tapScreenAtPoint:select];
    //[self waitForViewWithAccessibilityLabel:@"Date Time Picker" value:@"Tuesday, Jun 17, 06:43 AM" traits:UIAccessibilityTraitNone];
    [self waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}
// select repeat, now repeat is not supported
-(void)selectRepeat
{
    
    [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] inTableViewWithAccessibilityIdentifier:@"Add Ride List"];
    [self waitForTappableViewWithAccessibilityLabel:@"Repeat View"];
    [self waitForTimeInterval:1];
    CGPoint select;
    select.x = 20;
    select.y = 20;
    [self tapScreenAtPoint:select];
    
    [self waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}
// select date by tap-point in the search view
-(void)selectDateByPointInSearch
{
    
    [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] inTableViewWithAccessibilityIdentifier:@"Search Ride List"];
    
    CGPoint select;
    select.x = 50;
    select.y = 450;
    [self tapScreenAtPoint:select];
    [self waitForTimeInterval:1];
    
    select.x = 200;
    select.y = 450;
    [self tapScreenAtPoint:select];
    [self waitForTimeInterval:1];
    
    select.x = 250;
    select.y = 550;
    [self tapScreenAtPoint:select];
    [self waitForTappableViewWithAccessibilityLabel:@"Search Ride View"];
}
// change the meeting point in the add ride view
-(void)selectMeetPoint:(NSString *)location driver:(Boolean) driver
{
    if(driver){
        [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0] inTableViewWithAccessibilityIdentifier:@"Add Ride List"];
    }else{
        [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] inTableViewWithAccessibilityIdentifier:@"Add Ride List"];
    }
    
    [self waitForTappableViewWithAccessibilityLabel:@"Meet Point View"];
    [self enterText:location intoViewWithAccessibilityLabel:@"Meetpoint Text"];
    [self tapViewWithAccessibilityLabel:@"Save Meetpoint Button"];
    [self waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}
// select campus ride
-(void)selectCampus
{
    [self tapViewWithAccessibilityLabel:@"Campus"];
    //[self waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}
// select activity ride
-(void)selectActivity
{
    [self tapViewWithAccessibilityLabel:@"Activity"];
    //[self waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}
// select share on facebook, this facebook plugin cannot be tested
-(void)selectShare
{
    //share of facebook can not be tested
    //[self tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] inTableViewWithAccessibilityIdentifier:@"Add Ride List"];
    //[self setOn:YES forSwitchWithAccessibilityLabel:@"Facebook"];
    //
    //    [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1] inTableViewWithAccessibilityIdentifier:@"Add Ride List"];
    //    [self setOn:YES forSwitchWithAccessibilityLabel:@"Email"];
}
// change the free seat number
-(void)selectSeatNumber:(NSInteger)seat
{
    // increase the seat
    UIStepper *repsStepper = (UIStepper*)[self waitForViewWithAccessibilityLabel:@"Seat Stepper"];
    CGPoint stepperCenter = [repsStepper.window convertPoint:repsStepper.center
                                                    fromView:repsStepper.superview];
    CGPoint minusButton = stepperCenter;
    minusButton.x -= CGRectGetWidth(repsStepper.frame) / 4;
    
    CGPoint plusButton = stepperCenter;
    plusButton.x += CGRectGetWidth(repsStepper.frame) / 4;
    
    for (NSInteger i = 0; i<seat+2; i++) {
        [self tapScreenAtPoint:plusButton];
    }
    [self tapScreenAtPoint:minusButton];
    [self tapScreenAtPoint:minusButton];
}
// change the car type
-(void)selectCar:(NSString *)car
{
    [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] inTableViewWithAccessibilityIdentifier:@"Add Ride List"];
    [self waitForTappableViewWithAccessibilityLabel:@"Meet Point View"];
    [self enterText:car intoViewWithAccessibilityLabel:@"Meetpoint Text"];
    [self tapViewWithAccessibilityLabel:@"Save Meetpoint Button"];
    [self waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}
// click add button, change to owner request view
-(void)addRideAsPassenger
{
    [self swipeViewWithAccessibilityLabel:@"Add Ride View" inDirection:KIFSwipeDirectionUp];
    [self tapViewWithAccessibilityLabel:@"Add Button"];
    [self waitForTappableViewWithAccessibilityLabel:@"Owner Request View"];
    
    [self waitForTimeInterval:1];
    
    [self tapViewWithAccessibilityLabel:@"Back Button"];
    [self tapViewWithAccessibilityLabel:@"Left Drawer Button"];
    [self waitForTappableViewWithAccessibilityLabel:@"Menu View"];
}
// click add button, change to owner offer view
-(void)addRideAsDriver
{
    [self swipeViewWithAccessibilityLabel:@"Add Ride View" inDirection:KIFSwipeDirectionUp];
    [self tapViewWithAccessibilityLabel:@"Add Button"];
    [self waitForTappableViewWithAccessibilityLabel:@"Owner Offer View"];
    
    [self waitForTimeInterval:1];
    
    [self tapViewWithAccessibilityLabel:@"Back Button"];
    [self tapViewWithAccessibilityLabel:@"Left Drawer Button"];
    [self waitForTappableViewWithAccessibilityLabel:@"Menu View"];
}
// click search button
-(void)search
{
    [self tapViewWithAccessibilityLabel:@"Search Button"];
    [self waitForTappableViewWithAccessibilityLabel:@"Search Result View"];
    [self waitForTimeInterval:1];
    
}
// click back after viewing the search result
-(void)searchBack
{
    CGPoint select;
    select.x = 20;
    select.y = 20;
    [self tapScreenAtPoint:select];
    [self tapViewWithAccessibilityLabel:@"Left Drawer Button"];
}
// choose the different radius of search
-(void)sliderRadius:(NSInteger) radius row:(NSInteger)row
{
    [self setValue:radius forSliderWithAccessibilityLabel: [NSString stringWithFormat: @"Slider Radius Row %ld", (long)row]];
    [self waitForViewWithAccessibilityLabel:@"Search Ride View"];
}
// delete the request ride
-(void)viewRideDetailAsRequestAndDelete
{
    [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"Search Result List"];
    [self waitForViewWithAccessibilityLabel:@"Owner Request View"];
    
    [self tapViewWithAccessibilityLabel:@"Delete Button"];
}
// delete the offer ride
-(void)viewRideDetailAsOfferAndDelete
{
    [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"Search Result List"];
    [self waitForViewWithAccessibilityLabel:@"Owner Offer View"];
    
    [self tapViewWithAccessibilityLabel:@"Cancel Button"];
}
// insert delete reason
-(void)tapDeleteButtonInAlert
{
    [self enterText:@"This is just a test. I need to delete this ride to continue test." intoViewWithAccessibilityLabel:@"Delete Reason"];
    
    CGPoint select;
    select.x = 250;
    select.y = 300;
    [self tapScreenAtPoint:select];
    
    [self waitForTimeInterval:1];
    
    select.x = 25;
    select.y = 25;
    [self tapScreenAtPoint:select];
    
    [self waitForTimeInterval:1];
}

@end

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


#pragma mark - test procedure
-(void)testDemo
{
    // add an activity ride as driver with search place
    //[self addRideAsDriverWithActivityRideWithSearch];
    // search an activity ride
    //[self searchRideWithActivityRideWithRadius0WithTimeWithSearch];
    // delete an activity ride as an owner
    //[self deleteRideAsOffer];

    //[self addRideAsDriverWithCampusRide];
    //[self addRideAsDriverWithCampusRide];
    //[self addRideAsDriverWithCampusRide];
    //[self searchRideWithCampusRideWithRadius0WithoutTime];
    //[self searchBack];
[self addRideAsPassengerWithCampusRideWithSearch];

[self searchRideWithCampusRideWithRadius0WithTimeWithSearch];
[self deleteRideAsRequest];
}


#pragma mark - test cases
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

-(void)addRideAsDriverWithCampusRide
{
    
    [self selectAddRide];
    [self selectPlace:0 section:0 type:kDEPARTURE_ADD];
    [self selectPlace:1 section:0 type:kDESTINATION_ADD];
    [self selectDateByPoint];
    [self selectSeatNumber:2];
    [self selectCar:@"BMW i8"];
    [self selectMeetPoint:@"Mensa" driver:YES];
    [self selectShare];
    
    [self addRideAsDriver];
}

-(void)addRideAsDriverWithCampusRideWithSearch
{

    [self selectAddRide];
    [self searchPlace:0 section:1 address:@"Garching" type:kDEPARTURE_ADD];
    [self searchPlace:0 section:1 address:@"Munich" type:kDESTINATION_ADD];
    [self selectDateByPoint];
    [self selectSeatNumber:2];
    [self selectCar:@"BMW i8"];
    [self selectMeetPoint:@"Mensa" driver:YES];
    [self selectShare];

    [self addRideAsDriver];
}

-(void)addRideAsDriverWithActivityRide
{
    
    [self selectAddRide];
    [self selectPlace:0 section:0 type:kDEPARTURE_ADD];
    [self selectPlace:1 section:0 type:kDESTINATION_ADD];
    [self selectDateByPoint];
    [self selectSeatNumber:2];
    [self selectCar:@"BMW i8"];
    [self selectMeetPoint:@"Mensa" driver:YES];
    [self selectActivity];
    [self selectShare];
    
    [self addRideAsDriver];
}

-(void)addRideAsDriverWithActivityRideWithSearch
{
    
    [self selectAddRide];
    [self searchPlace:0 section:1 address:@"Garching" type:kDEPARTURE_ADD];
    [self searchPlace:0 section:1 address:@"Munich" type:kDESTINATION_ADD];
    [self selectDateByPoint];
    [self selectSeatNumber:2];
    [self selectCar:@"BMW i8"];
    [self selectMeetPoint:@"Mensa" driver:YES];
    [self selectActivity];
    [self selectShare];
    
    [self addRideAsDriver];
}

-(void)searchRideWithCampusRideWithRadius0WithoutTime
{
    [self selectSearchRide];
    
    [self selectPlace:1 section:0 type:kDEPARTURE_SEARCH];
    [self sliderRadius:0 row:2];
    
    [self selectPlace:2 section:0 type:kDESTINATION_SEARCH];
    [self sliderRadius:0 row:4];
    
    [self search];
}

-(void)searchRideWithCampusRideWithRadius30WithoutTime
{
    [self selectSearchRide];
    
    [self selectPlace:1 section:0 type:kDEPARTURE_SEARCH];
    [self sliderRadius:30 row:2];
    
    [self selectPlace:2 section:0 type:kDESTINATION_SEARCH];
    [self sliderRadius:30 row:4];
    
    [self search];
}

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

-(void)deleteRideAsRequest
{
    // then choose the first one in list

    [self viewRideDetailAsRequestAndDelete];
    [self tapDeleteButtonInAlert];
}

-(void)deleteRideAsOffer
{
    // then choose the first one in list
    [self viewRideDetailAsOfferAndDelete];
    [self tapDeleteButtonInAlert];
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
        [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:(type-2) inSection:0] inTableViewWithAccessibilityIdentifier:@"Search Ride List"];
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

-(void)selectDateByPoint
{
    
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] inTableViewWithAccessibilityIdentifier:@"Add Ride List"];
    
    CGPoint select;
    select.x = 50;
    select.y = 450;
    [tester tapScreenAtPoint:select];
    [tester waitForTimeInterval:1];

    select.x = 200;
    select.y = 450;
    [tester tapScreenAtPoint:select];
    [tester waitForTimeInterval:1];
    
    select.x = 250;
    select.y = 550;
    [tester tapScreenAtPoint:select];
    //[tester waitForViewWithAccessibilityLabel:@"Date Time Picker" value:@"Tuesday, Jun 17, 06:43 AM" traits:UIAccessibilityTraitNone];
    [tester waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}

-(void)selectDateByPointInSearch
{
    
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] inTableViewWithAccessibilityIdentifier:@"Search Ride List"];
    
    CGPoint select;
    select.x = 50;
    select.y = 450;
    [tester tapScreenAtPoint:select];
    [tester waitForTimeInterval:1];
    
    select.x = 200;
    select.y = 450;
    [tester tapScreenAtPoint:select];
    [tester waitForTimeInterval:1];
    
    select.x = 250;
    select.y = 550;
    [tester tapScreenAtPoint:select];
    [tester waitForTappableViewWithAccessibilityLabel:@"Search Ride View"];
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
    //[tester waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}

-(void)selectActivity
{
    [tester tapViewWithAccessibilityLabel:@"Activity"];
    //[tester waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}

-(void)selectShare
{
    //share of facebook can not be tested
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
    
    [tester waitForTimeInterval:1];
    
    [tester tapViewWithAccessibilityLabel:@"Back Button"];
    [tester tapViewWithAccessibilityLabel:@"Left Drawer Button"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Menu View"];
}

-(void)addRideAsDriver
{
    [tester swipeViewWithAccessibilityLabel:@"Add Ride View" inDirection:KIFSwipeDirectionUp];
    [tester tapViewWithAccessibilityLabel:@"Add Button"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Owner Offer View"];

    [tester waitForTimeInterval:1];
    
    [tester tapViewWithAccessibilityLabel:@"Back Button"];
    [tester tapViewWithAccessibilityLabel:@"Left Drawer Button"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Menu View"];
}

-(void)search
{
    [tester tapViewWithAccessibilityLabel:@"Search Button"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Search Result View"];
    [tester waitForTimeInterval:1];

}
-(void)searchBack
{
    CGPoint select;
    select.x = 20;
    select.y = 20;
    [tester tapScreenAtPoint:select];
    [tester tapViewWithAccessibilityLabel:@"Left Drawer Button"];
}

-(void)sliderRadius:(NSInteger) radius row:(NSInteger)row
{
    [tester setValue:radius forSliderWithAccessibilityLabel: [NSString stringWithFormat: @"Slider Radius Row %ld", (long)row]];
    [tester waitForViewWithAccessibilityLabel:@"Search Ride View"];
}

-(void)viewRideDetailAsRequestAndDelete
{
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"Search Result List"];
    [tester waitForViewWithAccessibilityLabel:@"Owner Request View"];
    
    [tester tapViewWithAccessibilityLabel:@"Delete Button"];
}

-(void)viewRideDetailAsOfferAndDelete
{
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"Search Result List"];
    [tester waitForViewWithAccessibilityLabel:@"Owner Offer View"];
    
    [tester tapViewWithAccessibilityLabel:@"Cancel Button"];
}

-(void)tapDeleteButtonInAlert
{
    [tester enterText:@"This is just a test. I need to delete this ride to continue test." intoViewWithAccessibilityLabel:@"Delete Reason"];
    
    CGPoint select;
    select.x = 250;
    select.y = 300;
    [tester tapScreenAtPoint:select];
    
    [tester waitForTimeInterval:1];
    
    select.x = 25;
    select.y = 25;
    [tester tapScreenAtPoint:select];

    [tester waitForTimeInterval:1];
}


@end

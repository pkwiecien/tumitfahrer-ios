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
    [self selectRepeat];
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
    [self selectRepeat];
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
    [self selectRepeat];
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
    [self selectRepeat];
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
    [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] inTableViewWithAccessibilityIdentifier:@"Menu List"];
    [self waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}

-(void)selectSearchRide
{
    [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2] inTableViewWithAccessibilityIdentifier:@"Menu List"];
    [self waitForTappableViewWithAccessibilityLabel:@"Search Ride View"];
}
-(void)selectPassenger
{
    [self tapViewWithAccessibilityLabel:@"Passenger Choice"];
    [self waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}

-(void)selectDriver
{
    [self tapViewWithAccessibilityLabel:@"Driver Choice"];
    [self waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}

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

-(void)selectCampus
{
    [self tapViewWithAccessibilityLabel:@"Campus"];
    //[self waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}

-(void)selectActivity
{
    [self tapViewWithAccessibilityLabel:@"Activity"];
    //[self waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}

-(void)selectShare
{
    //share of facebook can not be tested
    //[self tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] inTableViewWithAccessibilityIdentifier:@"Add Ride List"];
    //[self setOn:YES forSwitchWithAccessibilityLabel:@"Facebook"];
    //
    //    [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1] inTableViewWithAccessibilityIdentifier:@"Add Ride List"];
    //    [self setOn:YES forSwitchWithAccessibilityLabel:@"Email"];
}

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

-(void)selectCar:(NSString *)car
{
    [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] inTableViewWithAccessibilityIdentifier:@"Add Ride List"];
    [self waitForTappableViewWithAccessibilityLabel:@"Meet Point View"];
    [self enterText:car intoViewWithAccessibilityLabel:@"Meetpoint Text"];
    [self tapViewWithAccessibilityLabel:@"Save Meetpoint Button"];
    [self waitForTappableViewWithAccessibilityLabel:@"Add Ride View"];
}

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

-(void)search
{
    [self tapViewWithAccessibilityLabel:@"Search Button"];
    [self waitForTappableViewWithAccessibilityLabel:@"Search Result View"];
    [self waitForTimeInterval:1];
    
}
-(void)searchBack
{
    CGPoint select;
    select.x = 20;
    select.y = 20;
    [self tapScreenAtPoint:select];
    [self tapViewWithAccessibilityLabel:@"Left Drawer Button"];
}

-(void)sliderRadius:(NSInteger) radius row:(NSInteger)row
{
    [self setValue:radius forSliderWithAccessibilityLabel: [NSString stringWithFormat: @"Slider Radius Row %ld", (long)row]];
    [self waitForViewWithAccessibilityLabel:@"Search Ride View"];
}

-(void)viewRideDetailAsRequestAndDelete
{
    [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"Search Result List"];
    [self waitForViewWithAccessibilityLabel:@"Owner Request View"];
    
    [self tapViewWithAccessibilityLabel:@"Delete Button"];
}

-(void)viewRideDetailAsOfferAndDelete
{
    [self tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"Search Result List"];
    [self waitForViewWithAccessibilityLabel:@"Owner Offer View"];
    
    [self tapViewWithAccessibilityLabel:@"Cancel Button"];
}

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

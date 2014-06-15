//
//  SettingTest.m
//  tumitfahrer
//
//  Created by Automotive Service Lab on 15/06/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "SettingTest.h"

@implementation SettingTest


-(void)beforeAll
{
    [tester tapViewWithAccessibilityLabel:@"Left Drawer Button"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Menu View"];
    
    [tester tapViewWithAccessibilityLabel:@"Setting Button"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Setting View"];
}

-(void)afterAll
{
    [tester tapViewWithAccessibilityLabel:@"Menu Button"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Menu View"];
}

//-(void)test00SendFeedback
//{
//    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"Setting List"];
//    [tester waitForTappableViewWithAccessibilityLabel:@"Feedback View"];
//    
//    [tester enterText:@"This is the feedback from UI Test" intoViewWithAccessibilityLabel:@"Feedback Title"];
//    [tester enterText:@"TUMitfahrer is awesome! Btw.KIF is pretty good for UI Test." intoViewWithAccessibilityLabel:@"Feedback Text"];
//    
//    [tester waitForTappableViewWithAccessibilityLabel:@"Feedback View"];
//    
//    [tester tapViewWithAccessibilityLabel:@"Feedback Send Button"];
//    [tester waitForTappableViewWithAccessibilityLabel:@"Setting View"];
//}

//-(void)test10ReportProblem
//{
//    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] inTableViewWithAccessibilityIdentifier:@"Setting List"];
//    [tester waitForTappableViewWithAccessibilityLabel:@"Feedback View"];
//    
//    [tester enterText:@"This is the report from UI Test" intoViewWithAccessibilityLabel:@"Feedback Title"];
//    [tester enterText:@"TUMitfahrer has no bug till now" intoViewWithAccessibilityLabel:@"Feedback Text"];
//    
//    [tester waitForTappableViewWithAccessibilityLabel:@"Feedback View"];
//    
//    [tester tapViewWithAccessibilityLabel:@"Feedback Send Button"];
//    [tester waitForTappableViewWithAccessibilityLabel:@"Setting View"];
//}

//-(void)test20Reminder
//{
//    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] inTableViewWithAccessibilityIdentifier:@"Setting List"];
//    [tester waitForTappableViewWithAccessibilityLabel:@"Reminder View"];
//    
//    [tester setOn:YES forSwitchWithAccessibilityLabel:@"Reminder Switch"];
//    
//    [tester tapViewWithAccessibilityLabel:@"Reminder Time Picker"];
//    NSArray *dateTime = @[@"6", @"30", @"AM"];
//    [tester selectDatePickerValue:dateTime];
//    [tester waitForTappableViewWithAccessibilityLabel:@"Reminder View"];
//
//    [tester tapViewWithAccessibilityLabel:@"Back Setting Button"];
//    [tester waitForTappableViewWithAccessibilityLabel:@"Setting View"];
//}

-(void)test30Privacy
{
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1] inTableViewWithAccessibilityIdentifier:@"Setting List"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Privacy View"];
    
    [tester tapViewWithAccessibilityLabel:@"Back Setting Button"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Setting View"];
}

-(void)test40License
{
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1] inTableViewWithAccessibilityIdentifier:@"Setting List"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Privacy View"];
    
    [tester tapViewWithAccessibilityLabel:@"Back Setting Button"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Setting View"];
}

-(void)test50CarSharing
{
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1] inTableViewWithAccessibilityIdentifier:@"Setting List"];
    [tester waitForTappableViewWithAccessibilityLabel:@"CarSharing View"];
    
    [tester tapViewWithAccessibilityLabel:@"Back Setting Button"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Setting View"];
}

//-(void)test60ContactUs
//{
//    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2] inTableViewWithAccessibilityIdentifier:@"Setting List"];
//    [tester waitForTappableViewWithAccessibilityLabel:@"Feedback View"];
//
//    [tester enterText:@"Hello TUMitfahrer" intoViewWithAccessibilityLabel:@"Feedback Title"];
//    [tester enterText:@"I am very tired to write the test :(" intoViewWithAccessibilityLabel:@"Feedback Text"];
//
//    [tester waitForTappableViewWithAccessibilityLabel:@"Feedback View"];
//
//    [tester tapViewWithAccessibilityLabel:@"Feedback Send Button"];
//    [tester waitForTappableViewWithAccessibilityLabel:@"Setting View"];
//}
@end

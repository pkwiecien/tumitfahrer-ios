//
//  ActionManagerTests.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/1/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ActionManager.h"

@interface ActionManagerTests : XCTestCase

@end

@implementation ActionManagerTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testDateToString {

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    [components setMonth:2];
    [components setYear:2014];
    [components setHour:23];
    [components setMinute:59];
    NSDate *calendarDate = [calendar dateFromComponents:components];
    NSString *stringFromDate = [ActionManager stringFromDate:calendarDate];
    
    NSString *expectedString = @"2014-02-01 23:59";
    XCTAssertTrue([expectedString isEqualToString:stringFromDate], @"Strings are not equal %@ %@", expectedString, stringFromDate);
}

@end

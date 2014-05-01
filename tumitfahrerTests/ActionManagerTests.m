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

    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    NSString *stringFromDate = [ActionManager stringFromDate:date];
    
    NSString *dateString = @"1970-01-01 01:01";
    XCTAssertTrue([dateString isEqualToString:stringFromDate], @"Strings are not equal %@ %@", dateString, stringFromDate);
}

@end

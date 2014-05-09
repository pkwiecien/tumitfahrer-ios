//
//  FacultyManagerTests.m
//  tumitfahrer
//
//  Created by Automotive Service Lab on 09/05/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FacultyManager.h"

@interface FacultyManagerTests : XCTestCase

@end

@implementation FacultyManagerTests

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

- (void)testNameOfFacultyAtIndex
{
    NSInteger index = 1;
    NSString *expectedString = @"Chemistry";
    FacultyManager *manager = [[FacultyManager alloc] init];
    NSString *stringFromFunction = [manager nameOfFacultyAtIndex:index];
    
    XCTAssertTrue([expectedString isEqualToString:stringFromFunction], @"String is not equal %@ %@", expectedString, stringFromFunction);
    
}

- (void)testNameOfFacultyAtIndexWithMinus
{
    NSInteger index = -1;
    NSString *expectedString = @"";
    FacultyManager *manager = [[FacultyManager alloc] init];
    NSString *stringFromFunction = [manager nameOfFacultyAtIndex:index];
    
    XCTAssertTrue([expectedString isEqualToString:stringFromFunction], @"String is not equal %@ %@", expectedString, stringFromFunction);
}

- (void)testNameOfFacultyAtIndexWithOverBound
{
    NSInteger index = 13;
    NSString *expectedString = @"";
    FacultyManager *manager = [[FacultyManager alloc] init];
    NSString *stringFromFunction = [manager nameOfFacultyAtIndex:index];
    
    XCTAssertTrue([expectedString isEqualToString:stringFromFunction], @"String is not equal %@ %@", expectedString, stringFromFunction);
    
}
@end

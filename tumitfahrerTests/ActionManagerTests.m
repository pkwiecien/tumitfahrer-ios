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

- (void)testEncryptionAndDecryption{
    NSString *str = @"Hello World";
    NSString *cypher = [ActionManager encodeBase64WithCredentials:str];
    //NSLog(@"Cypher text is %@",cypher);
    //Cypher text of Hello World is SGVsbG8gV29ybGQ=
    NSString *plaintext = [ActionManager decodeBase64String:cypher];
    
    XCTAssertEqualObjects(str, plaintext, @"Strings are not equal");
}

- (void)testEncryption{
    NSString *plain = @"Hello World";
    NSString *expectedString = @"SGVsbG8gV29ybGQ=";
    NSString *cypherAfterEncryption = [ActionManager encodeBase64WithCredentials:plain];
    
    XCTAssertTrue([expectedString isEqualToString:cypherAfterEncryption], @"Strings are not equal %@ %@", expectedString, cypherAfterEncryption);
}


- (void)testEncryptionWithEmptyString{
    NSString *plain = @"";
    NSString *expectedString = @"";
    NSString *cypherAfterEncryption = [ActionManager encodeBase64WithCredentials:plain];
    
    XCTAssertTrue([expectedString isEqualToString:cypherAfterEncryption], @"Strings are not equal %@ %@", expectedString, cypherAfterEncryption);
}

- (void)testDecryption{
    NSString *cypher = @"SGVsbG8gV29ybGQ=";
    NSString *expectedString = @"Hello World";
    NSString *plainAfterDecryption = [ActionManager decodeBase64String:cypher];
    
    XCTAssertTrue([expectedString isEqualToString:plainAfterDecryption], @"Strings are not equal %@ %@", expectedString, plainAfterDecryption);
}

- (void)testDecryptionWithEmptyString{
    NSString *cypher = @"";
    NSString *expectedString = @"";
    NSString *plainAfterDecryption = [ActionManager decodeBase64String:cypher];
    
    XCTAssertTrue([expectedString isEqualToString:plainAfterDecryption], @"Strings are not equal %@ %@", expectedString, plainAfterDecryption);
}

- (void)testSHA512{
    NSString *str = @"Hello World";
    //NSLog(@"SHA512 is %@", [ActionManager createSHA512:str]);
    // SHA 512 of Hello World is 5ae830648f8fc38940b6797f7b1da8b67c81d4abb752be3e6e40f82fa0eb7d8f95aacdc8b21360345dfdad868c9e5594753ff87e2f76cad5d4cc3175ab4bdc32
    NSString *expectedString = @"5ae830648f8fc38940b6797f7b1da8b67c81d4abb752be3e6e40f82fa0eb7d8f95aacdc8b21360345dfdad868c9e5594753ff87e2f76cad5d4cc3175ab4bdc32";
    NSString *sha = [ActionManager createSHA512:str];
    XCTAssertTrue([expectedString isEqualToString:sha], @"Strings are not equal %@ %@", expectedString, sha);
}

- (void)testSHA512WithEmptyString{
    NSString *str = @"";
    NSString *expectedString = @"20f961bcbfa018a504a6b613963797effa74cf76972340a2a835e6db6ae026027392b7be768b1efe55c96d8e0eb7a66d6615489424b709474f4b714a7b61e097";
    NSString *sha = [ActionManager createSHA512:str];
    XCTAssertTrue([expectedString isEqualToString:sha], @"Strings are not equal %@ %@", expectedString, sha);
}

@end

//
//  JsonParser.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/26/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Class that parses JSON responses (there where RestKit is not used).
 */
@interface JsonParser : NSObject

/**
 *  Parse JSON response with the list of devices.
 *
 *  @param objectNotation JSON resopnse that should be parsed.
 *  @param error          Error object for parsing.
 *
 *  @return Array with devices parsed from JSON.
 */
+ (NSArray *)devicesFromJson:(NSData *)objectNotation error:(NSError *)error;

@end

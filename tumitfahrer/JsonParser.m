//
//  JsonParser.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/26/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "JsonParser.h"

@implementation JsonParser

+(NSArray *)devicesFromJson:(NSData *)objectNotation error:(NSError *)error {
    
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:NSJSONReadingMutableContainers error:&localError];
    
    if (localError != nil) {
        error = localError;
        return nil;
    }
    NSArray *devices = parsedObject[@"devices"];
    if(devices == nil)
        return nil;
    
    NSMutableArray *deviceTokens = [[NSMutableArray alloc] init];
    
    for(NSMutableDictionary *device in devices) {
        [deviceTokens addObject:device[@"token"]];
    }
    
    return deviceTokens;
}

@end

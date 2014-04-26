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
    NSLog(@"parsed: %@", parsedObject);
    
    NSArray *devices = parsedObject[@"devices"];
    NSMutableArray *deviceTokens = [[NSMutableArray alloc] init];
    [deviceTokens addObject:@"test"];
    
    NSLog(@"One %@", [devices[0] valueForKey:@"token"]);
    NSLog(@"Two %@", devices[1]);
    NSLog(@"%lu", (unsigned long)[devices count]);

    for(NSMutableDictionary *device in devices) {
        NSLog(@"token: %@", device[@"token"]);
        [deviceTokens addObject:device[@"token"]];
    }

    return deviceTokens;
}

@end

//
//  JsonParser.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/26/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonParser : NSObject

+ (NSArray *)devicesFromJson:(NSData *)objectNotation error:(NSError *)error;

@end

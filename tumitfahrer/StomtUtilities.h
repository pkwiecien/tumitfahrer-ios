//
//  StomtUtilities.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 7/26/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Stomt;

@interface StomtUtilities : NSObject

+(void)getAllStomtsWithCompletionHandler:(boolCompletionHandler)block;
+(void)postStomtWithText:(NSString *)text isNegative:(NSNumber *)isNegative boolCompletionHandler:(boolCompletionHandler)block;
+(void)deleteStomt:(Stomt *)stomt block:(boolCompletionHandler)block;

+(NSArray *)fetchStomtsFromCoreData;
+(void)deleteStomtFromCoreData:(Stomt *)stomt;

@end

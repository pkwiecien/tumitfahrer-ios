//
//  StomtUtilities.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 7/26/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StomtUtilities : NSObject

+(void)getAllStomtsWithCompletionHandler:(boolCompletionHandler)block;
+(void)postStomtWithText:(NSString *)text isNegative:(NSNumber *)isNegative boolCompletionHandler:(boolCompletionHandler)block;

+(NSArray *)fetchStomtsFromCoreData;

@end

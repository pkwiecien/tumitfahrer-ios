//
//  UnimplementedActionManager.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/5/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionManager : NSObject

+ (void)showAlertViewWithTitle:(NSString *)title;
+ (void)showAlertViewWithTitle:(NSString *)title description:(NSString*)description;

// image utilities
+ (UIImage *)colorImage:(UIImage *)origImage withColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color;

// enctryption untilities
+ (NSString*)encodeBase64WithCredentials:(NSString*)credentials;
+ (NSString*)decodeBase64String:(NSString*)base64String;
+ (NSString *)createSHA512:(NSString *)string;

// date formatter
+ (NSString *)stringFromDate:(NSDate*)date;

@end

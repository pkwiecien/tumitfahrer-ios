//
//  UnimplementedActionManager.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/5/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionManager : NSObject

+ (void)showAlertViewWithTitle:(NSString *)title description:(NSString*)description;

// image utilities
+ (UIImage *)colorImage:(UIImage *)origImage withColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

// encryption untilities
+ (NSString*)encodeBase64WithCredentials:(NSString*)credentials;
+ (NSString*)decodeBase64String:(NSString*)base64String;
+ (NSString *)createSHA512:(NSString *)string;
+ (NSString *)encryptCredentialsWithEmail:(NSString *)email password:(NSString *)password;
+ (NSString *)encryptCredentialsWithEmail:(NSString *)email encryptedPassword:(NSString *)encryptedPassword;

// date formatter
+ (NSString *)stringFromDate:(NSDate*)date;
+ (NSString *)timeStringFromDate:(NSDate*)date;
+ (NSString *)dateStringFromDate:(NSDate*)date;
+ (NSDate *)dateFromString:(NSString *)stringDate;
+ (NSString *)webserviceStringFromDate:(NSDate *)date;
+ (NSArray *)shortestTimeFromNowFromDate:(NSDate *)date;

// current time in local time zone
+ (NSDate *)currentDate;
+ (NSDate *)localDateWithDate:(NSDate *)sourceDate;

// validation
+(BOOL)isValidEmail:(NSString *)checkString;


@end

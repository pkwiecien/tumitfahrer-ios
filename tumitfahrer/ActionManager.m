//
//  UnimplementedActionManager.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/5/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "ActionManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <GPUImageiOSBlurFilter.h>

@implementation ActionManager

+ (void)showAlertViewWithTitle:(NSString *)title description:(NSString *)description {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - image handling
// explanation: stackoverflow.com/questions/3514066/how-to-tint-a-transparent-png-image-in-iphone
+ (UIImage *)colorImage:(UIImage *)origImage withColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions (origImage.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, origImage.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect rect = CGRectMake(0, 0, origImage.size.width, origImage.size.height);
    
    // image drawing code here
    
    // draw black background to preserve color of transparent pixels
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    [[UIColor blackColor] setFill];
    CGContextFillRect(context, rect);
    
    // mask by alpha values of original image
    CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
    CGContextDrawImage(context, rect, origImage.CGImage);
    
    // draw alpha-mask
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, origImage.CGImage);
    
    // draw tint color, preserving alpha values of original image
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [color setFill];
    CGContextFillRect(context, rect);
    
    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return coloredImage;
}

// create a square filled with a specific color (useful e.g. for buttons or backgrounds)
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)applyBlurFilterOnImage:(UIImage *)image {
    // Create filter.
    GPUImageiOSBlurFilter *blurFilter = [GPUImageiOSBlurFilter new];
    blurFilter.blurRadiusInPixels = 2.0;
    
    // Apply filter.
    UIImage *blurredSnapshotImage = [blurFilter imageByFilteringImage:image];
    
    return blurredSnapshotImage;
}


#pragma mark - encryption

+ (NSString*)encodeBase64WithCredentials:(NSString*)credentials {
    NSData *plainData = [credentials dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    
    return base64String;
}

+ (NSString *)decodeBase64String:(NSString *)base64String {
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    
    return decodedString;
}

+ (NSString *)createSHA512:(NSString *)string {
    string = [string stringByAppendingString:SALT];
    const char *s = [string cStringUsingEncoding:NSASCIIStringEncoding];
    
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH] = {0};
    CC_SHA512(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
    NSString *response = [out.description stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [response substringWithRange:NSMakeRange(1, response.length-2)];
}

+ (NSString *)encryptCredentialsWithEmail:(NSString *)email password:(NSString *)password {
    
    NSString *encryptedPassword = [ActionManager createSHA512:password];
    return [self encryptCredentialsWithEmail:email encryptedPassword:encryptedPassword];
}

+ (NSString *)encryptCredentialsWithEmail:(NSString *)email encryptedPassword:(NSString *)encryptedPassword {
    
    NSString *credentials = [NSString stringWithFormat:@"%@:%@", email, encryptedPassword];
    NSString *encryptedCredentials = [ActionManager encodeBase64WithCredentials:credentials];
    
    return encryptedCredentials;
}

# pragma mark - date formatter

+ (NSString *)stringFromDate:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"]];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSString *)timeStringFromDate:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"]];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSString *)dateStringFromDate:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"]];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSString *)webserviceStringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"]];
    NSString *time = [formatter stringFromDate:date];
    return time;
}

+ (NSDate *)dateFromString:(NSString *)stringDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"]];
    NSDate *date = [formatter dateFromString:stringDate];
    return date;
}

+(NSDate *)currentDate {
    
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    return destinationDate;
}

+(NSArray *)shortestTimeFromNowFromDate:(NSDate *)date {
    NSDate* date1 = date;
    NSDate* date2 = [NSDate date];
    NSTimeInterval distanceBetweenDates = [date1 timeIntervalSinceDate:date2];
    double secondsInAnHour = 3600;
    double minutesInAnHour = 60;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    NSInteger minutesBetweenDate = distanceBetweenDates / minutesInAnHour;
    
    return [NSArray arrayWithObjects:[NSNumber numberWithInt:hoursBetweenDates], [NSNumber numberWithInt:minutesBetweenDate], nil];
}

+(NSDate *)localDateWithDate:(NSDate *)sourceDate {
    return [NSDate dateWithTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMT] sinceDate:sourceDate];
}

// from: http://stackoverflow.com/questions/3139619/check-that-an-email-address-is-valid-on-ios
+(BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end

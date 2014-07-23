//
//  UnimplementedActionManager.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/5/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A helped class that contains static utility functions.
 */
@interface ActionManager : NSObject

/**
 *  Shows an alert view with the given title and description.
 *
 *  @param title       String with title of the alert view.
 *  @param description String with description of the alert view.
 */
+ (void)showAlertViewWithTitle:(NSString *)title description:(NSString*)description;

// image utilities
/**
 *  Color an original image to another color. Esp. usefull for icon. However, shouldn't be overused as it's a costly operation.
 *
 *  @param origImage The original UIImage
 *  @param color     New color of the image.
 *
 *  @return New image with the new color.
 */
+ (UIImage *)colorImage:(UIImage *)origImage withColor:(UIColor *)color;
/**
 *  Creates an image out of the given color.
 *
 *  @param color Requested color.
 *
 *  @return Image with the given color.
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
/**
 *  Scale an image to the new size.
 *
 *  @param image   The image object.
 *  @param newSize New size of the image.
 *
 *  @return Scaled image.
 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

// encryption untilities

/**
 *  Returns encoded user's credentials. Base64 is used as encryption algorithm.
 *
 *  @param credentials String with credentials that should be encrypted.
 *
 *  @return Encrypted credentails.
 */
+ (NSString*)encodeBase64WithCredentials:(NSString*)credentials;
/**
 *  Decode encrypted credentials that were encrypted with Base64.
 *
 *  @param base64String String with encrypted credentials.
 *
 *  @return Decrypted credentials.
 */
+ (NSString*)decodeBase64String:(NSString*)base64String;
/**
 *  Encryptes a string with SHA algorithm.
 *
 *  @param string The string that should be encrypted.
 *
 *  @return Encrypted string.
 */
+ (NSString *)createSHA512:(NSString *)string;
/**
 *  Encrypts user's email and password with Base64 algorithm. Before the encryption, the password is additionally ecrnypted with SHA512. They are combined to form: email:password and then ecrypted. This is the format expected by the API.
 *
 *  @param email    String with email.
 *  @param password String with password.
 *
 *  @return Encrypted credentails.
 */
+ (NSString *)encryptCredentialsWithEmail:(NSString *)email password:(NSString *)password;
/**
 *  Encrypts user's email and encrypted password with SHA algorithm. They are combined to form: email:password and then ecrypted. This is the format expected by the API.
 *
 *  @param email    String with email.
 *  @param password String with password.
 *
 *  @return Encrypted credentails.
 */
+ (NSString *)encryptCredentialsWithEmail:(NSString *)email encryptedPassword:(NSString *)encryptedPassword;

// date formatter
/**
 *  Return a string object from the date.
 *
 *  @param date The Date object.
 *
 *  @return String with date.
 */
+ (NSString *)stringFromDate:(NSDate*)date;
/**
 *  Returns string with time from the date object.
 *
 *  @param date The Date object.
 *
 *  @return String with time.
 */
+ (NSString *)timeStringFromDate:(NSDate*)date;
/**
 *  Returns string with date (without time) from the date object.
 *
 *  @param date The date object.
 *
 *  @return String with date.
 */
+ (NSString *)dateStringFromDate:(NSDate*)date;
/**
 *  Returns a date object from the string with date.
 *
 *  @param stringDate String with date.
 *
 *  @return New date object.
 */
+ (NSDate *)dateFromString:(NSString *)stringDate;

/**
 *  Another date formatter.
 *
 *  @param date The date objet.
 *
 *  @return String with date.
 */
+ (NSString *)webserviceStringFromDate:(NSDate *)date;
/**
 *  Returns an array with values such as minute, hour, etc from now.
 *
 *  @param date The date that should be compared to the current time.
 *
 *  @return Array with compared values.
 */
+ (NSArray *)shortestTimeFromNowFromDate:(NSDate *)date;

// current time in local time zone
+ (NSDate *)currentDate;
/**
 *  Returns local date from the data with a timezone.
 *
 *  @param sourceDate The date with info about the timezone.
 *
 *  @return Local date.
 */
+ (NSDate *)localDateWithDate:(NSDate *)sourceDate;

// validation
/**
 *  Validates an email field. Checks if it doesn't contains any wrong characters.
 *
 *  @param checkString Email address
 *
 *  @return True if the email is correct, False otherwise.
 */
+(BOOL)isValidEmail:(NSString *)checkString;


@end

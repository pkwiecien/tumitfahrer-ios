//
//  UnimplementedActionManager.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/5/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "ActionManager.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ActionManager

-(instancetype)init {
    self = [super init];
    return  self;
}

+(instancetype)sharedManager {
    static ActionManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return  sharedManager;
}

-(void)showAlertViewWithTitle:(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"Functionality coming soon" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - image handling
// explanation: stackoverflow.com/questions/3514066/how-to-tint-a-transparent-png-image-in-iphone
- (UIImage *)colorImage:(UIImage *)origImage withColor:(UIColor *)color {
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


-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - encryption

-(NSString*)encodeBase64WithCredentials:(NSString*)credentials {
    NSData *plainData = [credentials dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    
    return base64String;
}

-(NSString *)decodeBase64String:(NSString *)base64String {
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];

    return decodedString;
}

-(NSString *)createSHA512:(NSString *)string {
    string = [string stringByAppendingString:SALT];
    const char *s = [string cStringUsingEncoding:NSASCIIStringEncoding];

    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH] = {0};
    CC_SHA512(keyData.bytes, keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
    NSString *response = [out.description stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [response substringWithRange:NSMakeRange(1, response.length-2)];
}



@end

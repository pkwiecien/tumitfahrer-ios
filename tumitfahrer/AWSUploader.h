//
//  AWSUploader.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/21/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSRuntime/AWSRuntime.h>
#import <AWSS3/AWSS3.h>

@interface AWSUploader : NSObject <AmazonServiceRequestDelegate>

+ (instancetype)sharedStore;

- (void)uploadImageData:(NSData *)imageData userId:(NSNumber *)userId;
- (UIImage *)downloadProfilePictureForUserId:(NSNumber *)userId;

@end

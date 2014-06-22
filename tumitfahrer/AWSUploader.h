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

@protocol AWSUploaderDelegate <NSObject>

-(void)didDownloadImageData:(NSData *)imageData;

@end

@interface AWSUploader : NSObject <AmazonServiceRequestDelegate>

+ (instancetype)sharedStore;

@property (nonatomic, strong) id<AWSUploaderDelegate> delegate;

- (void)uploadImageData:(NSData *)imageData userId:(NSNumber *)userId;
- (void)downloadProfilePictureForUserId:(NSNumber *)userId;

@end

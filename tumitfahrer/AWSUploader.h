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

@class User;

/**
 *  Protocol that notifies delegates about receiving a profile image for a given user.
 */
@protocol AWSUploaderDelegate <NSObject>

/**
 *  Notifies about receiving image for the given user.
 *
 *  @param imageData Data with image.
 *  @param user      The user Object
 */
-(void)didDownloadImageData:(NSData *)imageData user:(User *)user;

@end

/**
 *  Class that uploads and download's user's profile pictures to AWS S3.
 */
@interface AWSUploader : NSObject <AmazonServiceRequestDelegate>

+ (instancetype)sharedStore;

@property (nonatomic, strong) id<AWSUploaderDelegate> delegate;

/**
 *  Uploads user's profile pricture to AWS S3.
 *
 *  @param imageData Data with the image.
 *  @param user      The user object who should be later notified about successful upload.
 */
- (void)uploadImageData:(NSData *)imageData user:(User *)user;

/**
 *  Downloads user's profile picture from AWS S3.
 *
 *  @param user The User object.
 */
- (void)downloadProfilePictureForUser:(User *)user;

@end

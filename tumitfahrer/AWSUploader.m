//
//  AWSUploader.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/21/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "AWSUploader.h"
#import "Constants.h"
#import "User.h"

@interface AWSUploader ()

@property (nonatomic) double totalBytesWritten;
@property (nonatomic) long long expectedTotalBytes;
@property (nonatomic, strong)  AmazonCredentials * credentials;
@property (nonatomic, strong) S3TransferManager *tm;
@property (nonatomic, retain) AmazonS3Client *s3;
@property (nonatomic, strong) User *user;

@end

@implementation AWSUploader {
    NSOutputStream *stream;
}

+(instancetype)sharedStore {
    static AWSUploader *awsUploader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        awsUploader = [[self alloc] init];
    });
    return awsUploader;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        [self configureAWS];
    }
    return self;
}

- (void)configureAWS {
    if (![ACCESS_KEY_ID isEqualToString:@"changeme"]) {
        self.s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
        self.credentials = [[AmazonCredentials alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
        self.s3.endpoint = [AmazonEndpoints s3Endpoint:US_EAST_1];
        self.s3.maxRetries = 10;
        self.s3.timeout = 240;
        
        self.tm = [S3TransferManager new];
        self.tm.s3 = self.s3;
    }
}

-(void)uploadImageData:(NSData *)imageData user:(User *)user {
    
    if (self.tm != nil) {
        
        self.user = user;
        
        NSString *path = [NSString stringWithFormat:@"users/%@/profile_picture.jpg", user.userId];
        S3PutObjectRequest *putObjectRequest = [[S3PutObjectRequest alloc] initWithKey:path inBucket:BUCKET_NAME];
        putObjectRequest.data = imageData;
        putObjectRequest.delegate = self;
        putObjectRequest.contentType = @"image/jpeg";
        putObjectRequest.credentials = self.credentials;
        
        [self.tm upload:putObjectRequest];
    } else {
        NSLog(@"AWS uploader is not configured");
    }
}

-(void)downloadProfilePictureForUser:(User *)user {
    
    if (self.tm != nil) {
        
        self.user = user;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/tumitfahrer/users/%@/profile_picture.jpg", documentsDirectory, user.userId];
        NSLog(@"filePath %@", filePath);
        NSString *path = [NSString stringWithFormat:@"users/%@/profile_picture.jpg", user.userId];
        
        S3GetObjectRequest *getObjectRequest = [[S3GetObjectRequest alloc] initWithKey:path withBucket:BUCKET_NAME];
        getObjectRequest.credentials = self.credentials;
        getObjectRequest.delegate = self;
        
        [self.tm download:getObjectRequest];
    } else {
        NSLog(@"AWS uploader is not configured");
    }
}
#pragma mark - AmazonServiceRequestDelegate

-(void)request:(AmazonServiceRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSDictionary * headers = ((NSHTTPURLResponse *)response).allHeaderFields;
    //if content-range is not set (this is not a range download), content-length is the length of the file
    if ([headers objectForKey:(@"Content-Range")] == nil) {
        self.expectedTotalBytes = [[headers objectForKey:(@"Content-Length")] longLongValue];
    }
}

- (void)request:(AmazonServiceRequest *)request didReceiveData:(NSData *)data
{
    self.totalBytesWritten += data.length;
    double percent = ((double)self.totalBytesWritten/(double)self.expectedTotalBytes)*100;
    NSLog(@"%@", [NSString stringWithFormat:@"%.2f%%", percent]);
}

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response {
    NSData *imageData = response.body;
    if (imageData != nil && imageData.length > 0) {
        [self.delegate didDownloadImageData:response.body user:self.user];
    }
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError called: %@", error);
}

-(void)request:(AmazonServiceRequest *)request didFailWithServiceException:(NSException *)exception
{
    NSLog(@"didFailWithServiceException called: %@", exception);
}


@end

//
//  Photo.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/21/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ride;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * photoUrl;
@property (nonatomic, retain) NSString * ownerName;
@property (nonatomic, retain) NSString * photoTitle;
@property (nonatomic, retain) NSString * photoFileUrl;
@property (nonatomic, retain) NSDate * uploadDate;
@property (nonatomic, retain) NSNumber * photoId;
@property (nonatomic, retain) Ride *ride;

@end

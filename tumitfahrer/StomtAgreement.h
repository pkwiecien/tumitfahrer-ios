//
//  StomtAgreement.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 7/30/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Stomt;

@interface StomtAgreement : NSManagedObject

@property (nonatomic, retain) NSNumber * agreementId;
@property (nonatomic, retain) NSNumber * isNegative;
@property (nonatomic, retain) NSString * creator;
@property (nonatomic, retain) Stomt *stomt;

@end

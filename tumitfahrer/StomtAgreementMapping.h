//
//  StomtAgreementMapping.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 7/30/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StomtAgreementMapping : NSObject

+(RKEntityMapping *)agreementMapping;
+(RKResponseDescriptor *)postAgreementResponseDescriptorWithMapping:(RKObjectMapping *)mapping;
+(RKObjectMapping *)deleteStomtAgreementMapping;
+(RKResponseDescriptor *)deleteStomtAgreementResponseDescriptorWithMapping:(RKObjectMapping *)mapping;

@end

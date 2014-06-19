//
//  RatingMapping.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RatingMapping : NSObject

+ (RKEntityMapping*)ratingMapping;
+ (RKResponseDescriptor *)postRatingResponseDescriptorWithMapping:(RKEntityMapping *)mapping;

@end

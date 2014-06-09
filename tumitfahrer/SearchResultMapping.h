//
//  SearchResultMapping.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/9/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResultMapping : NSObject

+(RKResponseDescriptor *)postSearchResponseDescriptorWithMapping:(RKEntityMapping *)mapping;

@end

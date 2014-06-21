//
//  PanoramioMapping.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/21/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "PanoramioMapping.h"
#import "Photo.h"

@implementation PanoramioMapping

+(RKEntityMapping *)panoramioMapping {
    
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Photo" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    mapping.identificationAttributes = @[@"photoId"];
    [mapping addAttributeMappingsFromDictionary:@{    @"photo_id": @"photoId",
                                                      @"photo_title":@"photoTitle",
                                                      @"photo_url":@"photoUrl",
                                                      @"photo_file_url":@"photoFileUrl",
                                                      @"upload_date":@"uploadDate",
                                                      @"owner_name": @"ownerName",
                                                      }];
    return mapping;
}

+(RKResponseDescriptor *)getPhotoResponseDescriptorWithMapping:(RKEntityMapping *)mapping {
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:nil keyPath:@"photos" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return responseDescriptor;
}

@end

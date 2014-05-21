//
//  CoreDataHelper.h
//  tumitfahrer
//
//  Created by Automotive Service Lab on 21/05/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataHelper : NSObject

+ (NSManagedObjectContext *)managedObjectContextForTests;
@end

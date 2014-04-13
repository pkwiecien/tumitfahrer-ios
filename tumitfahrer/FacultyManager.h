//
//  Faculty.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/13/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacultyManager : NSObject

+(instancetype)sharedInstance;

- (NSArray *)allFaculties;
- (NSString *)nameOfFacultyAtIndex:(NSInteger)index;

@end

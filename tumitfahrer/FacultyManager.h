//
//  Faculty.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/13/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A singleton class that stores the Factulty objects.
 */
@interface FacultyManager : NSObject

+(instancetype)sharedInstance;

/**
 *  Retuns all faculties.
 *
 *  @return Array with all faculties.
 */
- (NSArray *)allFaculties;

/**
 *  Returns name of the faculty for a given faculty id.
 *
 *  @param index Id of the faculty.
 *
 *  @return Name of the faculty.
 */
- (NSString *)nameOfFacultyAtIndex:(NSInteger)index;
/**
 *  Returns id of the faculty for the given name.
 *
 *  @param name Name of the faculty.
 *
 *  @return Id of the faculty.
 */
- (NSInteger)indexForFacultyName:(NSString *)name;

@end

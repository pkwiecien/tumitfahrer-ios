//
//  Faculty.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/13/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Class that store info about faculties. Used by Faculty Manager.
 */
@interface Faculty : NSObject

@property (nonatomic) int facultyId;
@property (nonatomic, strong) NSString *name;

/**
 *  Inits factulty with the id and name of the faculty.
 *
 *  @param name      String with name of the faculty.
 *  @param facultyId Id of the faculty.
 *
 *  @return Initialized object.
 */
-(instancetype)initWithName:(NSString*)name facultyId:(NSInteger)facultyId;

@end

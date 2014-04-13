//
//  Faculty.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/13/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Faculty : NSObject

@property (nonatomic) int facultyId;
@property (nonatomic, strong) NSString *name;

-(instancetype)initWithName:(NSString*)name facultyId:(NSInteger)facultyId;

@end

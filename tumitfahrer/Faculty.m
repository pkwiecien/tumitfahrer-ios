//
//  Faculty.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/13/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "Faculty.h"

@implementation Faculty

-(instancetype)initWithName:(NSString *)name facultyId:(NSInteger)facultyId {
    self = [super init];
    if (self) {
        self.name = name;
        self.facultyId = facultyId;
    }
    return self;
}
@end

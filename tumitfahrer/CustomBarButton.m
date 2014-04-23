//
//  CustomBarButtonItem.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "CustomBarButton.h"

@implementation CustomBarButton

-(instancetype)initWithTitle:(NSString*)title {
    
    self = [super init];
    if (self) {

        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.frame = CGRectMake(0, 0, 70, 30);
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 4;
        [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Thin" size:7]];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    }

    return self;
}
@end

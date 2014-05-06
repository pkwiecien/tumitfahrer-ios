//
//  CustomUILabel.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/6/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "CustomUILabel.h"

@implementation CustomUILabel

- (instancetype)initInMiddle:(CGRect)frame text:(NSString *)text viewWithNavigationBar:(UINavigationBar *)navigationBar {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.numberOfLines = 0; //will wrap text in new line
        [self setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0]];//font size and style
        [self setTextColor:[UIColor whiteColor]];
        self.text = text;
        self.textAlignment = NSTextAlignmentCenter;
        [self sizeToFit];
        
        // postition label exactly in the middle of the screen with navigation bar
        self.frame = CGRectMake(frame.size.width/2-self.frame.size.width/2, frame.size.height/2-self.frame.size.height/2-navigationBar.frame.size.height, self.frame.size.width, self.frame.size.height);
    }

    return self;
}

@end

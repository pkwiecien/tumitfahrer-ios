//
//  LogoView.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/10/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "LogoView.h"

@implementation LogoView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"LogoView" owner:self options:nil];
        LogoView *mainView = [subviewArray firstObject];
        
        UILabel *titleLabel = (UILabel *)[mainView viewWithTag:3];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor colorWithRed:0.784 green:0.906 blue:0.984 alpha:1];

        [self addSubview:mainView];
    }
    return self;
}

@end

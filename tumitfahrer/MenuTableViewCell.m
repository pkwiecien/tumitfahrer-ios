//
//  MenuTableViewCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 3/30/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    if (selected) {
        self.selectedView.hidden = NO;
        self.menuLabel.textColor = [UIColor whiteColor];
    } else {
        self.selectedView.hidden = YES;
        self.menuLabel.textColor = [UIColor colorWithRed:0.808 green:0.808 blue:0.808 alpha:1];
    }
}

@end

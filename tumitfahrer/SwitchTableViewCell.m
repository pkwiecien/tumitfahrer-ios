//
//  SwitchTableViewCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "SwitchTableViewCell.h"

@implementation SwitchTableViewCell

- (void)awakeFromNib
{
    
}

- (IBAction)switchChanged:(id)sender {
    if ([sender isOn]) {
        [self.delegate switchChangedToStatus:true switchId:self.switchId];
    } else {
        [self.delegate switchChangedToStatus:false switchId:self.switchId];
    }
}

-(void)dealloc {
    self.delegate = nil;
}

@end

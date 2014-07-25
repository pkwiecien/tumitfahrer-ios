//
//  StomtExperimentalCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 7/26/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "StomtExperimentalCell.h"

@implementation StomtExperimentalCell

- (void)awakeFromNib {
    [self.plusButton setTitleColor:[UIColor darkerBlue] forState:UIControlStateNormal];
    [self.minusButton setTitleColor:[UIColor darkerBlue] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)plusButtonPressed:(id)sender {
    
}

- (IBAction)minusButtonPressed:(id)sender {
}
@end

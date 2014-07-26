//
//  StomtExperimentalCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 7/26/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "StomtExperimentalCell.h"
#import "ActionManager.h"

@implementation StomtExperimentalCell

- (void)awakeFromNib {
    self.plusButton.backgroundColor = [UIColor customGreen];
    [self.plusButton setTitleColor:[UIColor darkerBlue] forState:UIControlStateNormal];
    [self.plusButton addTarget:self action:@selector(plusHighlight) forControlEvents:UIControlEventTouchDown|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    [self.plusButton addTarget:self action:@selector(plusNormal) forControlEvents:UIControlEventTouchUpInside];

    self.minusButton.backgroundColor = [UIColor lightRed];
    [self.minusButton setTitleColor:[UIColor darkerBlue] forState:UIControlStateNormal];
    [self.minusButton addTarget:self action:@selector(minusHighlight) forControlEvents:UIControlEventTouchDown|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    [self.minusButton addTarget:self action:@selector(minusNormal) forControlEvents:UIControlEventTouchUpInside];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)plusHighlight {
    self.plusButton.backgroundColor = [UIColor greenColor];
}

-(void)plusNormal {
    self.plusButton.backgroundColor = [UIColor customGreen];
}

-(void)minusHighlight {
    self.minusButton.backgroundColor = [UIColor redColor];
}

-(void)minusNormal {
    self.minusButton.backgroundColor = [UIColor lightRed];
}

- (IBAction)plusButtonPressed:(id)sender {
    
}

- (IBAction)minusButtonPressed:(id)sender {
    
}

@end

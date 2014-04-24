//
//  FreeSeatsTableViewCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "FreeSeatsTableViewCell.h"

@implementation FreeSeatsTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)stepperValueChanged:(UIStepper *)sender {
    double value = [sender value];
    if (value > 0 && value < 8) {
        self.stepperLabelText.text = [NSString stringWithFormat:@"%d", (int)value];
    }
}

@end

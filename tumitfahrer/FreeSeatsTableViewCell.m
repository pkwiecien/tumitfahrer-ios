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
    self.stepper.value = 1;
    self.stepper.maximumValue = 8;
    self.stepper.minimumValue = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)stepperValueChanged:(UIStepper *)sender {
    NSUInteger value = sender.value;
    self.passengersCountLabel.text = [NSString stringWithFormat:@"%d", (int)value];
}

@end
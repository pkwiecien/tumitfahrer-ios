//
//  FreeSeatsTableViewCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "FreeSeatsTableViewCell.h"

@implementation FreeSeatsTableViewCell

+(FreeSeatsTableViewCell *)freeSeatsTableViewCell {
    
    FreeSeatsTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"FreeSeatsTableViewCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.stepper.value = 1;
    cell.stepper.maximumValue = 8;
    cell.stepper.minimumValue = 1;

    return cell;
}

- (IBAction)stepperValueChanged:(UIStepper *)sender {
    NSUInteger value = sender.value;
    self.passengersCountLabel.text = [NSString stringWithFormat:@"%d", (int)value];
    [self.delegate stepperValueChanged:value];
}

-(void)dealloc {
    self.delegate = nil;
}

@end

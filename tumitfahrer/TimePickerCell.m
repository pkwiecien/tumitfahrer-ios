//
//  TimePickerCell.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/9/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "TimePickerCell.h"

@implementation TimePickerCell

+(TimePickerCell *)timePickerCell {
    TimePickerCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TimePickerCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.datePicker.timeZone = [NSTimeZone localTimeZone];
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 24;
}

@end

//
//  TimePickerCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/9/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimePickerCell : UITableViewCell <UIPickerViewDataSource, UIPickerViewDelegate>

+ (TimePickerCell *)timePickerCell;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

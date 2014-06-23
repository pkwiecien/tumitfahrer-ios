//
//  ReminderViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/9/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "ReminderViewController.h"
#import "SwitchTableViewCell.h"
#import "TimePickerCell.h"
#import "DescriptionCell.h"
#import "ActionManager.h"

@interface ReminderViewController () <SwitchTableViewCellDelegate>

@property BOOL reminderValue;

@end

@implementation ReminderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor customLightGray]];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    self.tableView.tableHeaderView = headerView;
    NSNumber *reminder = [[NSUserDefaults standardUserDefaults] valueForKey:@"reminder"];
    self.reminderValue = [reminder boolValue];
    self.tableView.allowsSelection = NO;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if(indexPath.row == 0) {
        DescriptionCell *descriptionCell = [tableView dequeueReusableCellWithIdentifier:@"DescriptionCell"];
        
        if (descriptionCell == nil) {
            descriptionCell = [[[NSBundle mainBundle] loadNibNamed:@"DescriptionCell" owner:self options:nil] objectAtIndex:0];
        }
        
        return descriptionCell;
    }
    if (indexPath.row == 1) {
        SwitchTableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        
        if (switchCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SwitchTableViewCell" owner:self options:nil];
            switchCell = [nib objectAtIndex:0];
        }
        switchCell.switchCellTextLabel.text = @"Reminder";
        switchCell.switchCellTextLabel.textColor = [UIColor blackColor];
        switchCell.backgroundColor = [UIColor clearColor];
        switchCell.contentView.backgroundColor = [UIColor clearColor];
        switchCell.selectionStyle = UITableViewCellSelectionStyleNone;
        switchCell.switchId = indexPath.row;
        switchCell.delegate = self;
        [switchCell.switchElement setOn:self.reminderValue];
#ifdef DEBUG
        //set label for KIF test
        [switchCell setAccessibilityLabel:@"Reminder Switch"];
        [switchCell setIsAccessibilityElement:YES];
#endif
        return switchCell;
    } else if(indexPath.row == 2) {
        TimePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimePickerCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TimePickerCell" owner:self options:nil] firstObject];
        }

        [self checkIfDateDefaultsExistForCell:(&cell)];
        cell.datePicker.userInteractionEnabled = self.reminderValue;
        if (!self.reminderValue) {
            [cell.datePicker setAlpha:.6];
        } else {
            [cell.datePicker setAlpha:1.0];
        }
        [cell.datePicker addTarget:self action:@selector(pickerViewChanged:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
    
    return cell;
}

-(void)checkIfDateDefaultsExistForCell:(TimePickerCell **)cell {
    (*cell).datePicker.date;
    NSNumber *hour = [[NSUserDefaults standardUserDefaults] valueForKey:@"reminderHour"];
    NSNumber *minute = [[NSUserDefaults standardUserDefaults] valueForKey:@"reminderMinute"];
    if (hour && minute) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit)
                                                   fromDate:[NSDate date]];
        components.timeZone = [NSTimeZone localTimeZone];
        [components setCalendar:calendar];
        components.hour = [hour intValue];
        components.minute = [minute intValue];

        (*cell).datePicker.date = [components date];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 70;
    } else if (indexPath.row == 2) {
        return 200;
    }
    return 44;
}

-(void)switchChangedToStatus:(BOOL)status switchId:(NSInteger)switchId {
    self.reminderValue = status;
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:status] forKey:@"reminder"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData];
}

- (void) pickerViewChanged:(id)sender {
    
    UIDatePicker *picker=(UIDatePicker*)sender;
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];

    NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit ) fromDate:picker.date];
    NSInteger minutes = timeComponents.minute;
    NSInteger hour = timeComponents.hour;
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:(int)hour] forKey:@"reminderHour"];
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:(int)minutes] forKey:@"reminderMinute"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

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
#import "CurrentUser.h"
#import "Ride.h"

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

-(void)viewWillDisappear:(BOOL)animated {
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"reminder"] boolValue]) {
        for (Ride *ride in [CurrentUser sharedInstance].user.ridesAsPassenger) {
            [self setupLocalNotificationDateForRide:ride];
        }
        
        for (Ride *ride in [CurrentUser sharedInstance].user.ridesAsOwner) {
            [self setupLocalNotificationDateForRide:ride];
            
        }
    } else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

-(void)setupLocalNotificationDateForRide:(Ride *)ride {
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    // Break the date up into components
    NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:ride.departureTime];
    NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:ride.departureTime];
    
    NSNumber *hour = [[NSUserDefaults standardUserDefaults] valueForKey:@"reminderHour"];
    NSNumber *minute = [[NSUserDefaults standardUserDefaults] valueForKey:@"reminderMinute"];
    // Set up the fire time
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:([dateComponents day]-1)];
    [dateComps setMonth:[dateComponents month]];
    [dateComps setYear:[dateComponents year]];
    [dateComps setHour:[hour intValue]];
    // Notification will fire in one minute
    [dateComps setMinute:[minute intValue]];
    [dateComps setSecond:[timeComponents second]];
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    localNotif.fireDate = itemDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    // Notification details
    localNotif.alertBody = [NSString stringWithFormat:@"Reminder: Tomorrow you have a ride from %@ to %@ at %@", ride.departurePlace, ride.destination, ride.departureTime];
    // Set the action button
    localNotif.alertAction = @"View";
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

@end

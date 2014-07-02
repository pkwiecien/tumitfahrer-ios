//
//  CustomRepeatViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/22/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "CustomRepeatViewController.h"
#import "RMDateSelectionViewController.h"
#import "ActionManager.h"
#import "MultiSelectSegmentedControl.h"

@interface CustomRepeatViewController () <RMDateSelectionViewControllerDelegate, MultiSelectSegmentedControlDelegate>

@property (nonatomic, assign) NSInteger selectedDay;

@end

@implementation CustomRepeatViewController {
    RMDateSelectionViewController *fromSelectionVC;
    RMDateSelectionViewController *toSelectionVC;
    NSDate *fromDate;
    NSDate *toDate;
    NSMutableArray *selectedDays;
    MultiSelectSegmentedControl *multiSelectControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dayStepper.enabled = NO;
    self.dayStepper.minimumValue = 1;
    self.dayStepper.maximumValue = 7;
    self.dayStepper.tintColor = [UIColor lighterBlue];
    self.repeatDailySwitch.tintColor = [UIColor lighterBlue];
    self.repeatDailySwitch.onTintColor = [UIColor lighterBlue];
    self.repeatWeeklySwitch.tintColor = [UIColor lighterBlue];
    self.repeatWeeklySwitch.onTintColor = [UIColor lighterBlue];
    self.view.backgroundColor = [UIColor customLightGray];
    
    fromDate = [NSDate date];
    fromSelectionVC = [RMDateSelectionViewController dateSelectionController];
    fromSelectionVC.delegate = self;
    fromSelectionVC.datePicker.date = fromDate;
    
    toDate = [self dateInDays:7];
    
    toSelectionVC = [RMDateSelectionViewController dateSelectionController];
    toSelectionVC.delegate = self;
    toSelectionVC.datePicker.date = toDate;
    
    [self.fromButton setTitle:[ActionManager stringFromDate:fromDate] forState:UIControlStateNormal];
    [self.toButton setTitle:[ActionManager stringFromDate:toDate] forState:UIControlStateNormal];
    
    multiSelectControl = [[MultiSelectSegmentedControl alloc] initWithFrame:CGRectMake(25, 360, 270, 30)];
    multiSelectControl.delegate = self;
    [multiSelectControl insertSegmentWithTitle:@"M" atIndex:0 animated:YES];
    [multiSelectControl insertSegmentWithTitle:@"T" atIndex:1 animated:YES];
    [multiSelectControl insertSegmentWithTitle:@"W" atIndex:2 animated:YES];
    [multiSelectControl insertSegmentWithTitle:@"T" atIndex:3 animated:YES];
    [multiSelectControl insertSegmentWithTitle:@"F" atIndex:4 animated:YES];
    multiSelectControl.tintColor = [UIColor lighterBlue];
    multiSelectControl.enabled = NO;
    [self.view addSubview:multiSelectControl];
    selectedDays = [NSMutableArray arrayWithObjects: [NSNumber numberWithBool:0], [NSNumber numberWithBool:0], [NSNumber numberWithBool:0], [NSNumber numberWithBool:0], [NSNumber numberWithBool:0],[NSNumber numberWithBool:0], [NSNumber numberWithBool:0],  nil];
    
    if (self.values == nil) {
        self.values = [[NSMutableDictionary alloc] init];
        [self.values setObject:fromDate forKey:@"fromDate"];
        [self.values setObject:toDate forKey:@"toDate"];
        [self.values setObject:selectedDays forKey:@"selectedDays"];
        [self.values setObject:@NO forKey:@"shouldRepeatDaily"];
        [self.values setObject:@NO forKey:@"shouldRepeatWeekly"];
        [self.values setObject:[NSNumber numberWithInt:0] forKey:@"dailyFrequency"];
    }
}

-(NSDate *)dateInDays:(NSInteger)days {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = days;
    return [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.repeatDailySwitch setOn:[[self.values objectForKey:@"shouldRepeatDaily"] boolValue]];
    if (self.repeatDailySwitch.isOn) {
        self.dayStepper.enabled = YES;
    } else {
        self.dayStepper.enabled = NO;
    }
    [self.repeatWeeklySwitch setOn:[[self.values objectForKey:@"shouldRepeatWeekly"] boolValue]];
    if (self.repeatWeeklySwitch.isOn) {
        multiSelectControl.enabled = YES;
    } else {
        multiSelectControl.enabled = NO;
    }
    if ([self.values objectForKey:@"fromDate"] == nil) {
        fromDate = [NSDate date];
        [self.fromButton setTitle:[ActionManager stringFromDate:fromDate] forState:UIControlStateNormal];
    } else {
        [self.fromButton setTitle:[ActionManager stringFromDate:[self.values objectForKey:@"fromDate"]] forState:UIControlStateNormal];
    }
    if ([self.values objectForKey:@"toDate"] == nil) {
        toDate = [self dateInDays:7];
        [self.toButton setTitle:[ActionManager stringFromDate:toDate] forState:UIControlStateNormal];
    } else {
        [self.toButton setTitle:[ActionManager stringFromDate:[self.values objectForKey:@"toDate"]] forState:UIControlStateNormal];
    }
    selectedDays = [self.values objectForKey:@"selectedDays"];
    
    NSMutableIndexSet *mutableIndexSet = [[NSMutableIndexSet alloc] init];
    
    for (int i = 0; i<selectedDays.count; i++) {
        NSNumber *isSelected = [selectedDays objectAtIndex:i];
        if ([isSelected boolValue] && i >= 2) {
            [mutableIndexSet addIndex:(i-2)];
        }
    }
    [multiSelectControl setSelectedSegmentIndexes:mutableIndexSet];
    
    if ([self.repeatDailySwitch isOn]) {
        NSInteger dailyFrequency = [[self.values objectForKey:@"dailyFrequency"] integerValue];
        self.dayStepper.value = dailyFrequency;
        if (self.dayStepper.value == 1) {
            self.everyDayLabel.text = @"Every day";
        } else {
            self.everyDayLabel.text = [NSString stringWithFormat:@"Every %d days", (int)self.dayStepper.value];
        }
    }
}

- (IBAction)repeatDailySwitchChanged:(id)sender {
    UISwitch *switchControl = (UISwitch *)sender;
    if ([switchControl isOn]) {
        [self.repeatWeeklySwitch setOn:NO animated:YES];
        self.dayStepper.enabled = YES;
        multiSelectControl.enabled = NO;
    } else {
        self.dayStepper.enabled = NO;
    }
}

- (IBAction)repeatWeeklySwitchChanged:(id)sender {
    UISwitch *switchControl = (UISwitch *)sender;
    if ([switchControl isOn]) {
        [self.repeatDailySwitch setOn:NO animated:YES];
        multiSelectControl.enabled = YES;
        self.dayStepper.enabled = NO;
    } else {
        multiSelectControl.enabled = NO;
    }
    [self.values setObject:[NSNumber numberWithBool:switchControl.isOn] forKey:@"shouldRepeatWeekly"];
}

- (IBAction)dayStepperChanged:(id)sender {
    UIStepper *dayStepper = (UIStepper *)sender;
    if (dayStepper.value == 1) {
        self.everyDayLabel.text = @"Every day";
    } else {
        self.everyDayLabel.text = [NSString stringWithFormat:@"Every %d days", (int)dayStepper.value];
    }
    [self.values setObject:[NSNumber numberWithInt:dayStepper.value] forKey:@"dailyFrequency"];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    NSString *descriptionLabel = @"";
    NSMutableArray *repeatDatesArray = [[NSMutableArray alloc] init];
    if ([self.repeatDailySwitch isOn]) { // repeat daily
        for (NSDate *date = fromDate; [date compare:toDate] == NSOrderedAscending; date = [date dateByAddingTimeInterval:60*60*24*((int)self.dayStepper.value)]) {
            [repeatDatesArray addObject:date];
        }
        descriptionLabel = @"Daily";
    } else if([self.repeatWeeklySwitch isOn]) { // repeat weekly
        for (NSDate *date = fromDate; [date compare:toDate] == NSOrderedAscending; date = [date dateByAddingTimeInterval:60*60*24*((int)self.dayStepper.value)]) {
            NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
            NSInteger weekday = [weekdayComponents weekday]%7; // according to gregorian calendar, sunday = 1
            if (weekday <= 1 ) { // Sunday or Saturday, don't repeat a ride then
                continue;
            }
            
            if ([[selectedDays objectAtIndex:weekday] boolValue]) {
                [repeatDatesArray addObject:date];
            }
        }
        if (selectedDays.count > 0) {
            descriptionLabel = @"Weekly";
        }
        
        [self.values setObject:selectedDays forKey:@"selectedDays"];
    }
    
    [self.delegate didSelectRepeatDates:repeatDatesArray descriptionLabel:descriptionLabel selectedValues:self.values];
}


- (IBAction)fromButtonPressed:(id)sender {
    [fromSelectionVC show];
}

- (IBAction)toButtonPressed:(id)sender {
    [toSelectionVC show];
}

-(void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    
}

-(void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    NSString *dateString = [ActionManager stringFromDate:aDate];
    if (vc == fromSelectionVC) {
        if ([aDate compare:toDate] == NSOrderedDescending) {
            [ActionManager showAlertViewWithTitle:@"Problem" description:@"Start date can't be after finish date"];
            return;
        }
        fromDate = aDate;
        [self.values setObject:fromDate forKey:@"fromDate"];
        [self.fromButton setTitle:dateString forState:UIControlStateNormal];
    } else {
        if ([fromDate compare:aDate] == NSOrderedDescending) {
            [ActionManager showAlertViewWithTitle:@"Problem" description:@"End date can't be before start date"];
            return;
        }
        toDate = aDate;
        [self.values setObject:toDate forKey:@"toDate"];
        [self.toButton setTitle:dateString forState:UIControlStateNormal];
    }
}

-(void)horizontalControlChanged {
    
}

-(void)multiSelect:(MultiSelectSegmentedControl *)multiSelecSegmendedControl didChangeValue:(BOOL)value atIndex:(NSUInteger)index {
    [selectedDays replaceObjectAtIndex:(index+2) withObject:[NSNumber numberWithBool:value]];
}

@end

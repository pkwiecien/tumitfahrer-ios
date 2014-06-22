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
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = 7;
    toDate = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    
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
    selectedDays = [NSMutableArray arrayWithObjects: [NSNumber numberWithBool:0], [NSNumber numberWithBool:0], [NSNumber numberWithBool:0], [NSNumber numberWithBool:0], [NSNumber numberWithBool:0], [NSNumber numberWithBool:0], nil];
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
}

- (IBAction)dayStepperChanged:(id)sender {
    UIStepper *dayStepper = (UIStepper *)sender;
    if (dayStepper.value == 1) {
        self.everyDayLabel.text = @"Every day";
    } else {
        self.everyDayLabel.text = [NSString stringWithFormat:@"Every %d days", (int)dayStepper.value];
    }
}

- (IBAction)segmentedControlChanged:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    self.selectedDay = segmentedControl.selectedSegmentIndex;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    NSMutableArray *repeatDatesArray = [[NSMutableArray alloc] init];
    if ([self.repeatDailySwitch isOn]) { // repeat daily
        for (NSDate *date = fromDate; [date compare:toDate] == NSOrderedAscending; date = [date dateByAddingTimeInterval:60*60*24*((int)self.dayStepper.value)]) {
            [repeatDatesArray addObject:date];
        }
    } else if([self.repeatWeeklySwitch isOn]) { // repeat weekly
        for (NSDate *date = fromDate; [date compare:toDate] == NSOrderedAscending; date = [date dateByAddingTimeInterval:60*60*24*((int)self.dayStepper.value)]) {
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:date];
            NSInteger day = components.day;
            if ([[selectedDays objectAtIndex:day] boolValue]) {
                [repeatDatesArray addObject:date];
            }
        }
    }
    
    [self.delegate didSelectRepeatDates:repeatDatesArray];
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
        [self.fromButton setTitle:dateString forState:UIControlStateNormal];
    } else {
        if ([fromDate compare:aDate] == NSOrderedDescending) {
            [ActionManager showAlertViewWithTitle:@"Problem" description:@"End date can't be before start date"];
            return;
        }
        toDate = aDate;
        [self.toButton setTitle:dateString forState:UIControlStateNormal];
    }
}

-(void)horizontalControlChanged {
    
}

-(void)multiSelect:(MultiSelectSegmentedControl *)multiSelecSegmendedControl didChangeValue:(BOOL)value atIndex:(NSUInteger)index {
    [selectedDays replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:value]];
}

@end

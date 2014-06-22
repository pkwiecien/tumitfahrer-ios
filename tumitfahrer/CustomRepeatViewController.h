//
//  CustomRepeatViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/22/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomRepeatViewController <NSObject>

- (void)didSelectRepeatDates:(NSArray *)repeatDates descriptionLabel:(NSString *)descriptionLabel selectedValues:(NSMutableDictionary *)selectedValues;

@end

@interface CustomRepeatViewController : UIViewController

@property (nonatomic, strong) NSMutableDictionary *values;
@property (nonatomic, strong) id<CustomRepeatViewController> delegate;
@property (weak, nonatomic) IBOutlet UISwitch *repeatDailySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *repeatWeeklySwitch;
@property (weak, nonatomic) IBOutlet UIStepper *dayStepper;
@property (weak, nonatomic) IBOutlet UILabel *everyDayLabel;
@property (weak, nonatomic) IBOutlet UIButton *fromButton;
@property (weak, nonatomic) IBOutlet UIButton *toButton;

- (IBAction)dayStepperChanged:(id)sender;
- (IBAction)repeatDailySwitchChanged:(id)sender;
- (IBAction)repeatWeeklySwitchChanged:(id)sender;
- (IBAction)fromButtonPressed:(id)sender;
- (IBAction)toButtonPressed:(id)sender;

@end

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

@interface ReminderViewController () <SwitchTableViewCellDelegate>

@end

@implementation ReminderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor customLightGray]];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    self.tableView.tableHeaderView = headerView;
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
        
        return switchCell;
    } else if(indexPath.row == 2) {
        TimePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimePickerCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TimePickerCell" owner:self options:nil] firstObject];
        }
        return cell;
    }

    return cell;
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
    
}

@end

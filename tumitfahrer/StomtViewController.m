//
//  StomtViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 7/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "StomtViewController.h"
#import "StomtHeaderView.h"
#import "StomtCell.h"

@interface StomtViewController ()

@end

@implementation StomtViewController {
    NSArray *opinionArray;
    NSArray *targetsArray;
    UIPickerView *opinionPickerView;
    UIPickerView *targetsPickerView;
    UIView *headerView;
    UITextView *opinionTextView;
    UILabel *optionalTextLabel;
    UIButton *stomtButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        opinionArray = [NSArray arrayWithObjects:@"like",@"wished", nil];
        targetsArray = [NSArray arrayWithObjects:@"TUMitfahrer", @"design", @"activity rides", @"campus rides", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor customLightGray];
    
    headerView = [[StomtHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 270)];
    opinionPickerView = (UIPickerView *)[headerView viewWithTag:100];
    opinionPickerView.delegate = self;
    targetsPickerView = (UIPickerView *)[headerView viewWithTag:101];
    targetsPickerView.delegate = self;
    opinionTextView = (UITextView *)[headerView viewWithTag:102];
    opinionTextView.delegate = self;
    stomtButton = (UIButton *)[headerView viewWithTag:103];
    [stomtButton addTarget:self action:@selector(stomtButtonPressed) forControlEvents:UIControlEventTouchDown];
    optionalTextLabel = (UILabel *)[headerView viewWithTag:104];
    self.tableView.tableHeaderView = headerView;
    
    [self.tableView registerClass:[StomtCell class] forCellReuseIdentifier:@"StomtCell"];
}

-(void)stomtButtonPressed {
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL shouldChangeText = YES;
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        shouldChangeText = NO;  
    }  
    
    return shouldChangeText;  
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView isEqual:opinionPickerView]) {
        return [opinionArray count];
    } else {
        return [targetsArray count];
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickerView isEqual:opinionPickerView]) {
        return [opinionArray objectAtIndex:row];
    } else {
        return [targetsArray objectAtIndex:row];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView isEqual:opinionPickerView]) {
        if (row == 0) {
            optionalTextLabel.text = @"Optional text (100 characters):";
            opinionTextView.text = @"because: ";
        } else {
            optionalTextLabel.text = @"Reason (min 5 characters):";
            opinionTextView.text = @"";
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StomtCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StomtCell"];
    
    if(cell == nil){
        cell = [StomtCell stomtCell];
    }
    
    cell.stomtTextView.text = [NSString stringWithFormat:@"%d", (int)indexPath.row];

    return cell;
}

@end

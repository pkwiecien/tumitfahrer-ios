//
//  StomtViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 7/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "StomtViewController.h"
#import "StomtHeaderView.h"
#import "StomtExperimentalCell.h"
#import "StomtUtilities.h"
#import "Stomt.h"
#import "CurrentUser.h"
#import "StomtAgreement.h"

@interface StomtViewController () <StomtExperimentalCellDelegate>

@property (nonatomic, strong) NSMutableArray *stomts;
@property UIRefreshControl *refreshControl;

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        opinionArray = [NSArray arrayWithObjects:@"like",@"wished", nil];
        targetsArray = [NSArray arrayWithObjects:@"TUMitfahrer", @"design", @"activity rides", @"campus rides", nil];
    }
    return self;
}

- (void)viewDidLoad {
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
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing stomts"];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.tintColor = [UIColor darkestBlue];
    [self.refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self shouldReloadTable];
    
    UIImage* stomtLogo = [UIImage imageNamed:@"StomtLogo"];
    CGRect frameimg = CGRectMake(0, 0, 65, 38);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:stomtLogo forState:UIControlStateNormal];
    UIBarButtonItem *stomtLogoButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem=stomtLogoButton;
}

- (void)handleRefresh {
    [StomtUtilities getAllStomtsWithCompletionHandler:^(BOOL fetched) {
        if (fetched) {
            [self reloadStomts];
            [self.refreshControl endRefreshing];
        }
    }];
}

-(void)reloadStomts {
    self.stomts = [NSMutableArray arrayWithArray:[StomtUtilities fetchStomtsFromCoreData]];
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

-(void)stomtButtonPressed {
    if ([opinionPickerView selectedRowInComponent:0] == 1 && [opinionTextView.text length] < 5) {
        optionalTextLabel.textColor = [UIColor redColor];
        return;
    }
    
    NSNumber *isNegative = [NSNumber numberWithBool:NO];
    [opinionTextView resignFirstResponder];
    if ([opinionPickerView selectedRowInComponent:0]) {
        isNegative = [NSNumber numberWithBool:YES];
    }
    
    NSString *opinion = [opinionTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([opinion isEqualToString:@"because"]) {
        opinion = @"";
    }
    
    NSString *stomtText = [NSString stringWithFormat:@"I %@ %@ %@", [opinionArray objectAtIndex:[opinionPickerView selectedRowInComponent:0]], [targetsArray objectAtIndex:[targetsPickerView selectedRowInComponent:0]], opinion];
    [StomtUtilities postStomtWithText:stomtText isNegative:isNegative boolCompletionHandler:^(BOOL posted) {
        if (posted) {
            [self reloadStomts];
        }
    }];
    
    if ([opinionPickerView selectedRowInComponent:0] == 0) {
        opinionTextView.text = @"because ";
    } else {
        opinionTextView.text = @"";
    }
    optionalTextLabel.textColor = [UIColor blackColor];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL shouldChangeText = YES;
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        shouldChangeText = NO;
    }
    
    return shouldChangeText;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
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
            opinionTextView.text = @"because ";
        } else {
            optionalTextLabel.text = @"Reason (min. 5 characters):";
            opinionTextView.text = @"";
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.stomts count];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [StomtUtilities deleteStomt:[self.stomts objectAtIndex:indexPath.row] block:^(BOOL deleted) {
            if (deleted) {
                [self.stomts removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    Stomt *stomt = [self.stomts objectAtIndex:indexPath.row];
    if ([stomt.creator isEqualToString:[NSString stringWithFormat:@"%@", [CurrentUser sharedInstance].user.userId]]) {
        return YES;
    }
    return NO;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"StomtExperimentalCell";
    
    StomtExperimentalCell *cell = (StomtExperimentalCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StomtExperimentalCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Stomt *stomt = [self.stomts objectAtIndex:indexPath.row];
    cell.stomTextView.text = stomt.text;
    cell.stomt = stomt;
    NSInteger positiveStomtCounter = [stomt.agreements count] - 2*[self countNegativeAgreementsForStomt:stomt];
    cell.counterLabel.text = [NSString stringWithFormat:@"%d", (int)positiveStomtCounter];
    cell.stomtOpinionType = NoneStomt;
    cell.delegate = self;
    
    StomtOpinionType stomtOpinion = [self stomtOpinion:stomt];
    switch (stomtOpinion) {
        case PositiveStomt:
            cell.plusButton.backgroundColor = [UIColor customGreen];
            cell.minusButton.backgroundColor = [UIColor lightGrayColor];
            cell.stomtOpinionType = PositiveStomt;
            break;
        case NegativeStomt:
            cell.minusButton.backgroundColor = [UIColor lightRed];
            cell.plusButton.backgroundColor = [UIColor lightGrayColor];
            cell.stomtOpinionType = NegativeStomt;
            break;
        default:
            cell.plusButton.backgroundColor = [UIColor lightGrayColor];
            cell.minusButton.backgroundColor = [UIColor lightGrayColor];
            cell.stomtOpinionType = NoneStomt;
            break;
    }
    
    return cell;
}

-(NSInteger)countNegativeAgreementsForStomt:(Stomt *)stomt {
    NSInteger counter = 0;
    for (StomtAgreement *agreement in stomt.agreements) {
        if ([agreement.isNegative boolValue]) {
            counter++;
        }
    }
    return counter;
}

-(StomtOpinionType)stomtOpinion:(Stomt *)stomt {
    for (StomtAgreement *agreement in stomt.agreements) {

        if ([agreement.creator isEqualToString:stomt.creator]) {
            if ([agreement.isNegative boolValue]) {
                return NegativeStomt;
            } else {
                return PositiveStomt;
            }
        }
        
    }
    
    return NoneStomt;
}

-(void)shouldReloadTable {
    [StomtUtilities getAllStomtsWithCompletionHandler:^(BOOL fetched) {
        if (fetched) {
            [self reloadStomts];
        }
    }];
}

@end

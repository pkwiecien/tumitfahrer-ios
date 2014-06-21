//
//  OwnerRequestViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/14/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "OwnerRequestViewController.h"
#import "Ride.h"
#import "RideInformationCell.h"
#import "CurrentUser.h"
#import "RidesStore.h"
#import "RideSectionHeaderCell.h"
#import "HeaderContentView.h"
#import "RideRequestInformationCell.h"
#import "WebserviceRequest.h"
#import "RideDetailActionCell.h"
#import "EditRequestViewController.h"
#import "CustomIOS7AlertView.h"

@interface OwnerRequestViewController () <UIGestureRecognizerDelegate, RideStoreDelegate, HeaderContentViewDelegate, CustomIOS7AlertViewDelegate>

@end

@implementation OwnerRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _headerView.backgroundColor = [UIColor darkerBlue];
    [self.view bringSubviewToFront:_headerView];
    [[RidesStore sharedStore] addObserver:self];
    
    self.rideDetail.headerView = _headerView;
    self.rideDetail.tableView.backgroundColor = [UIColor customLightGray];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.headerViewLabel.text = [@"To " stringByAppendingString:self.ride.destination];
    self.headerTitles = [NSArray arrayWithObjects:@"Details", @"", nil];
    
    [self reloadTableAndRide];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == [self.headerTitles count] -1) {
        return 0;
    }
    return 30;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.headerTitles objectAtIndex:section];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    RideSectionHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RideNoticeCell"];
    if(cell == nil) {
        cell = [RideSectionHeaderCell rideSectionHeaderCell];
    }
    cell.noticeLabel.text = [self.headerTitles objectAtIndex:section];
    [cell.editButton addTarget:self action:@selector(editButtonTapped) forControlEvents:UIControlEventTouchDown];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *generalCell = [tableView dequeueReusableCellWithIdentifier:@"reusable"];
    if (!generalCell) {
        generalCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reusable"];
    }
    
    generalCell.textLabel.text = @"Default cell";
    
    if(indexPath.section == 0) {
        RideRequestInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RideRequestInformationCell"];
        if(cell == nil){
            cell = [RideRequestInformationCell rideRequestInformationCell];
        }
        cell.requestInfoLabel.text = self.ride.meetingPoint;
        return cell;
    } else {  // show delete button
        RideDetailActionCell *actionCell = [RideDetailActionCell offerRideCell];
        [actionCell.actionButton setTitle:@"Delete ride" forState:UIControlStateNormal];
        [actionCell.actionButton addTarget:self action:@selector(showCancelationAlertView) forControlEvents:UIControlEventTouchDown];
        return actionCell;
    }
    
    return generalCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)deleteRideButtonPressed {
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    [objectManager deleteObject:self.ride path:[NSString stringWithFormat:@"/api/v2/rides/%@", self.ride.rideId] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        [[CurrentUser sharedInstance].user removeRidesAsOwnerObject:self.ride];
        [[RidesStore sharedStore] deleteRideFromCoreData:self.ride];
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Load failed with error: %@", error);
    }];
}

-(void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (self.textView.text.length < 50) {
            self.counterLabel.textColor = [UIColor redColor];
        } else {
            [self deleteRideButtonPressed];
            [alertView close];
        }
    } else {
        [alertView close];
    }
}

-(void)editButtonTapped {
    EditRequestViewController *editRequestVC = [[EditRequestViewController alloc] init];
    editRequestVC.ride = self.ride;
    [self.navigationController pushViewController:editRequestVC animated:YES];
}

-(void)dealloc {
    [[RidesStore sharedStore] removeObserver:self];
}

@end

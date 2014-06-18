//
//  RideDetailViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "OfferViewController.h"
#import "RideInformationCell.h"
#import "ActionManager.h"
#import "Request.h"
#import "CurrentUser.h"
#import "KGStatusBar.h"
#import "RidesStore.h"
#import "HeaderContentView.h"
#import "CircularImageView.h"
#import "WebserviceRequest.h"
#import "RideDetailActionCell.h"
#import "ActivityStore.h"
#import "User.h"
#import "RidePersonCell.h"
#import "SimpleChatViewController.h"
#import "RideSectionHeaderCell.h"
#import "ProfileViewController.h"

@interface OfferViewController () <UIGestureRecognizerDelegate, RideStoreDelegate, HeaderContentViewDelegate>

@end

@implementation OfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _headerView.backgroundColor = [UIColor darkerBlue];
    [self.view bringSubviewToFront:_headerView];
    [[RidesStore sharedStore] addObserver:self];
    
    self.rideDetail.headerView = _headerView;
    self.rideDetail.delegate = self;
    
    self.headerTitles = [NSArray arrayWithObjects:@"Details", @"Driver", @"",nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.headerViewLabel.text = [@"To " stringByAppendingString:self.ride.destination];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 100.0f;
    } else if (indexPath.section == 1) {
        return 60;
    }
    
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
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
        RideInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RideInformationCell"];
        if(cell == nil){
            cell = [RideInformationCell rideInformationCell];
        }
        if (self.ride.rideOwner == nil || self.ride.rideOwner.car == nil) {
            cell.carLabel.text = @"Not specified";
        } else {
            cell.carLabel.text = self.ride.rideOwner.car;
        }
        cell.informationLabel.text = self.ride.meetingPoint;
        
        return cell;
    } else if (indexPath.section == 1) { // show driver

        RidePersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RidePersonCell"];
        if (cell == nil) {
            cell = [RidePersonCell ridePersonCell];
        }
        if (self.ride.rideOwner != nil) {
            cell.personNameLabel.text = [self.ride.rideOwner.firstName stringByAppendingString:[NSString stringWithFormat:@"\nRating: %@", self.ride.rideOwner.ratingAvg]];
            cell.personImageView.image = [UIImage imageWithData:self.ride.rideOwner.profileImageData];
            
//            CircularImageView *circularImageView = circularImageView = [[CircularImageView alloc] initWithFrame:CGRectMake(18, 15, 100, 100) image:[UIImage imageWithData:self.ride.rideOwner.profileImageData]];
//            [cell addSubview:circularImageView];
        }
        cell.leftButton.hidden = YES;
        [cell.rightButton addTarget:self action:@selector(contactPassengerButtonPressed) forControlEvents:UIControlEventTouchDown];
        
        return cell;
    } else if(indexPath.section == 2) { // show leave button
        
        RideDetailActionCell *actionCell = [RideDetailActionCell offerRideCell];
        [actionCell.actionButton addTarget:self action:@selector(joinButtonPressed) forControlEvents:UIControlEventTouchDown];
        Request *request = [self requestFoundInCoreData];
        
        if (request != nil) {
            [actionCell.actionButton setTitle:@"Leave ride" forState:UIControlStateNormal];
        } else if([self isPassengerOfRide]) {
            [actionCell.actionButton setTitle:@"Leave ride as passenger" forState:UIControlStateNormal];
        } else {
            [actionCell.actionButton setTitle:@"Join ride" forState:UIControlStateNormal];
        }
        return actionCell;
    }
    
    return generalCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ProfileViewController *profileVC = [[ProfileViewController alloc] init];
        profileVC.user = self.ride.rideOwner;
        profileVC.returnEnum = ViewController;
        [self.navigationController pushViewController:profileVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - LocationDetailViewDelegate

#pragma mark - Button actions

-(Request *)requestFoundInCoreData {
    for (Request *request in self.ride.requests) {
        if ([request.passengerId isEqualToNumber:[CurrentUser sharedInstance].user.userId]) {
            return request;
        }
    }
    return nil;
}

-(BOOL)isPassengerOfRide {
    if ([self.ride.passengers containsObject:[CurrentUser sharedInstance].user]) {
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - offer ride cell

-(void)joinButtonPressed {
    if (![self isPassengerOfRide]) {
        
        Request *request = [self requestFoundInCoreData];
        RKObjectManager *objectManager = [RKObjectManager sharedManager];
        
        if (request == nil) {
            NSDictionary *queryParams;
            // add enum
            NSString *userId = [NSString stringWithFormat:@"%@", [CurrentUser sharedInstance].user.userId];
            queryParams = @{@"passenger_id": userId};
            NSDictionary *requestParams = @{@"request": queryParams};
            
            [objectManager postObject:nil path:[NSString stringWithFormat:@"/api/v2/rides/%@/requests", self.ride.rideId] parameters:requestParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                [KGStatusBar showSuccessWithStatus:@"Request was sent"];
                
                Request *rideRequest = (Request *)[mappingResult firstObject];
                [[RidesStore sharedStore] addRideRequestToStore:rideRequest forRide:self.ride];
                
                [self.rideDetail.tableView reloadData];
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                [ActionManager showAlertViewWithTitle:@"Error" description:@"Could not send ride request"];
                RKLogError(@"Load failed with error: %@", error);
            }];
        } else {
            [objectManager deleteObject:request path:[NSString stringWithFormat:@"/api/v2/rides/%@/requests/%d", self.ride.rideId, [request.requestId intValue]] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                
                [KGStatusBar showSuccessWithStatus:@"Request canceled"];
                
                [[RidesStore sharedStore] deleteRideRequest:request];
                
                [self.rideDetail.tableView reloadData];
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                RKLogError(@"Load failed with error: %@", error);
            }];
        }
    } else {
        [WebserviceRequest removePassengerWithId:[CurrentUser sharedInstance].user.userId rideId:self.ride.rideId block:^(BOOL fetched) {
            if (fetched) {
                [[RidesStore sharedStore] removePassengerForRide:self.ride.rideId passenger:[CurrentUser sharedInstance].user];
                [self.rideDetail.tableView reloadData];
            }
        }];
    }
}

-(void)removeRideRequest:(NSIndexPath *)indexPath requestor:(Request *)request {
    if ([[RidesStore sharedStore] removeRequestForRide:self.ride.rideId request:request]) {
        [self.rideDetail.tableView reloadData];
    }
}

-(void)passengerCellChangedForPassenger:(User *)passenger {
    if ([[RidesStore sharedStore] removePassengerForRide:self.ride.rideId passenger:passenger]) {
        [self.rideDetail.tableView reloadData];
    }
}

-(void)contactPassengerButtonPressed {
    SimpleChatViewController *simpleChatVC = [[SimpleChatViewController alloc] init];
    simpleChatVC.user = self.ride.rideOwner;
    [self.navigationController pushViewController:simpleChatVC animated:YES];
}

-(void)dealloc {
    [[RidesStore sharedStore] removeObserver:self];
}

@end
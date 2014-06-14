//
//  RideDetailViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "OwnerOfferViewController.h"
#import "RideInformationCell.h"
#import "PassengersCell.h"
#import "ActionManager.h"
#import "CurrentUser.h"
#import "KGStatusBar.h"
#import "RidesStore.h"
#import "RideNoticeCell.h"
#import "HeaderContentView.h"
#import "RidesPageViewController.h"
#import "WebserviceRequest.h"
#import "OfferRideCell.h"
#import "RequestorCell.h"
#import "EmptyCell.h"

@interface OwnerOfferViewController () <UIGestureRecognizerDelegate, RideStoreDelegate, RideStoreDelegate, OfferRideCellDelegate, RequestorCellDelegate, PassengersCellDelegate, HeaderContentViewDelegate>

@end

@implementation OwnerOfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _headerView.backgroundColor = [UIColor darkerBlue];
    [self.view bringSubviewToFront:_headerView];
    [[RidesStore sharedStore] addObserver:self];
    
    self.rideDetail.headerView = _headerView;
    self.rideDetail.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.headerViewLabel.text = [@"To " stringByAppendingString:self.ride.destination];
    self.headerTitles = [NSArray arrayWithObjects:@"Details", @"Passengers", @"Requests", @"", nil];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    } else if (indexPath.section == 1) {
        return 60;
    } else if(indexPath.section == 2) {
        return 60;
    }
    
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1 && [self.ride.passengers count] > 0) {
        return [self.ride.passengers count];
    } else if(section == 2 && [self.ride.requests count] > 0) {
        return [self.ride.requests count];
    }
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
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
    RideNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RideNoticeCell"];
    if(cell == nil) {
        cell = [RideNoticeCell rideNoticeCell];
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
    } else if (indexPath.section == 1 && [self.ride.passengers count] > 0) { // show passengers
        return generalCell;
    } else if(indexPath.section == 1 && [self.ride.passengers count] == 0) {
        EmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
        if (cell == nil) {
            cell = [EmptyCell emptyCell];
        }
        cell.descriptionLabel.text = @"There are no passengers";
        return cell;
    } else if(indexPath.section == 2 && [self.ride.requests count] > 0) { // show requests
        return generalCell;
    } else if(indexPath.section == 2 && [self.ride.requests count] == 0) {
        EmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
        if (cell == nil) {
            cell = [EmptyCell emptyCell];
        }
        cell.descriptionLabel.text = @"There are no passengers";
        return cell;
    }else {  // show delete button
        
        OfferRideCell *actionCell = [OfferRideCell offerRideCell];
        actionCell.delegate = self;
        [actionCell.actionButton setTitle:@"Cancel ride" forState:UIControlStateNormal];
        return actionCell;
    }
    
    return generalCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && self.ride.passengers > 0) {
        User *passenger = [[self.ride.passengers allObjects] objectAtIndex:indexPath.row];
        [WebserviceRequest removePassengerWithId:passenger.userId rideId:self.ride.rideId block:^(BOOL fetched) {
            if (fetched) {
                [self passengerCellChangedForPassenger:passenger];
            }
        }];
    } else if(indexPath.section == 2 && self.ride.requests > 0) {
        Request *request = [[self.ride.requests allObjects] objectAtIndex:indexPath.row];
        
        [WebserviceRequest getUserWithId:request.passengerId block:^(User * user) {
            if (user != nil) {
                [WebserviceRequest acceptRideRequest:request isConfirmed:YES block:^(BOOL isAccepted) {
                    if (isAccepted) {
                        [self moveRequestorToPassengersFromIndexPath:indexPath requestor:user];
                    } else {
                        NSLog(@"could not be accepted");
                    }
                }];
            }
        }];
        
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - LocationDetailViewDelegate

#pragma mark - Button actions

- (void)back {
    if (self.shouldGoBackEnum == GoBackNormally) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (self.ride.rideType == ContentTypeCampusRides) {
            RidesPageViewController *campusRidesVC = [[RidesPageViewController alloc] initWithContentType:ContentTypeCampusRides];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:campusRidesVC];
            [self.sideBarController setCenterViewController:navController  withCloseAnimation:YES completion:nil];
        } else {
            RidesPageViewController *activityRidesVC = [[RidesPageViewController alloc] initWithContentType:ContentTypeActivityRides];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:activityRidesVC];
            [self.sideBarController setCenterViewController:navController withCloseAnimation:YES completion:nil];
        }
    }
}

-(Request *)requestFoundInCoreData {
    for (Request *request in self.ride.requests) {
        if ([request.passengerId isEqualToNumber:[CurrentUser sharedInstance].user.userId]) {
            return request;
        }
    }
    return nil;
}

#pragma mark - delegate methods

-(void)dealloc {
    [[RidesStore sharedStore] removeObserver:self];
}

#pragma mark - delegate methods

#pragma mark - driver action cell

-(void)deleteRide:(Ride *)ride {
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    [objectManager deleteObject:self.ride path:[NSString stringWithFormat:@"/api/v2/rides/%@", self.ride.rideId] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        [[CurrentUser sharedInstance].user removeRidesAsOwnerObject:self.ride];
        [[RidesStore sharedStore] deleteRideFromCoreData:self.ride];
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Load failed with error: %@", error);
    }];
}

-(void)joinJoinDriverCellButtonPressed {
    Request *request = [[RidesStore sharedStore] rideRequestInCoreData:[CurrentUser sharedInstance].user.userId];
    
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
            [ActionManager showAlertViewWithTitle:[error localizedDescription]];
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
}

#pragma mark - offer ride cell

-(void)offerRideButtonPressed {
    [self deleteRide:self.ride];
}

-(void)moveRequestorToPassengersFromIndexPath:(NSIndexPath *)indexPath requestor:(User *)requestor {
    if ([[RidesStore sharedStore] addPassengerForRideId:self.ride.rideId requestor:requestor]) {
        [self.rideDetail.tableView reloadData];
    }
}

-(void)removeRideRequest:(NSIndexPath *)indexPath requestor:(User *)requestor {
    if ([[RidesStore sharedStore] removeRequestForRide:self.ride.rideId requestor:requestor]) {
        [self.rideDetail.tableView reloadData];
    }
}

-(void)passengerCellChangedForPassenger:(User *)passenger {
    if ([[RidesStore sharedStore] removePassengerForRide:self.ride.rideId passenger:passenger]) {
        [self.rideDetail.tableView reloadData];
    }
}

@end

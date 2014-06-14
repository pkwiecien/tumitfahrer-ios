//
//  RideDetailViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "OwnerOfferViewController.h"
#import "RideInformationCell.h"
#import "ActionManager.h"
#import "CurrentUser.h"
#import "KGStatusBar.h"
#import "RidesStore.h"
#import "RideSectionHeaderCell.h"
#import "HeaderContentView.h"
#import "RidesPageViewController.h"
#import "WebserviceRequest.h"
#import "RideDetailActionCell.h"
#import "EmptyCell.h"
#import "RidePersonCell.h"
#import "Request.h"
#import "SimpleChatViewController.h"

@interface OwnerOfferViewController () <UIGestureRecognizerDelegate, RideStoreDelegate, HeaderContentViewDelegate, RidePersonCellDelegate>

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
        RidePersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RidePersonCell"];
        if (cell == nil) {
            cell = [RidePersonCell ridePersonCell];
        }
        User *passenger = [[self.ride.passengers allObjects] objectAtIndex:indexPath.row];
        cell.personNameLabel.text = passenger.firstName;
        cell.personImageView.image = [UIImage imageWithData:passenger.profileImageData];
        cell.delegate = self;
        cell.leftObject = passenger;
        cell.rightObject = passenger;
        cell.cellTypeEnum = PassengerCell;
        [cell.leftButton setBackgroundImage:[UIImage imageNamed:@"DeleteIconBlack"] forState:UIControlStateNormal];
        [cell.rightButton setBackgroundImage:[UIImage imageNamed:@"EmailIconBlack"] forState:UIControlStateNormal];
        return cell;
        
    } else if(indexPath.section == 1 && [self.ride.passengers count] == 0) {
        EmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
        if (cell == nil) {
            cell = [EmptyCell emptyCell];
        }
        cell.descriptionLabel.text = @"There are no passengers";
        return cell;
    } else if(indexPath.section == 2 && [self.ride.requests count] > 0) { // show requests
        
        RidePersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RidePersonCell"];
        if (cell == nil) {
            cell = [RidePersonCell ridePersonCell];
        }
        cell.delegate = self;
        
        Request *request = [[self.ride.requests allObjects] objectAtIndex:indexPath.row];
        User *user = [CurrentUser getUserWithIdFromCoreData:request.passengerId];
        if(user != nil) {
            cell.personNameLabel.text = user.firstName;
            cell.personImageView.image = [UIImage imageWithData:user.profileImageData];
        } else {
            [WebserviceRequest getUserWithIdFromWebService:request.passengerId block:^(User *user) {
                if (user != nil) {
                    [self.rideDetail.tableView reloadData];
                }
            }];
        }
        
        [cell.leftButton setBackgroundImage:[UIImage imageNamed:@"DeleteIconBlack"] forState:UIControlStateNormal];
        [cell.rightButton setBackgroundImage:[UIImage imageNamed:@"AcceptIconBlack"] forState:UIControlStateNormal];
        cell.leftObject = request;
        cell.rightObject = request;
        cell.cellTypeEnum = RequestCell;
        return cell;
    } else if(indexPath.section == 2 && [self.ride.requests count] == 0) {
        EmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
        if (cell == nil) {
            cell = [EmptyCell emptyCell];
        }
        cell.descriptionLabel.text = @"There are no passengers";
        return cell;
    }else {  // show delete button
        
        RideDetailActionCell *actionCell = [RideDetailActionCell offerRideCell];
        [actionCell.actionButton setTitle:@"Cancel ride" forState:UIControlStateNormal];
        [actionCell.actionButton addTarget:self action:@selector(deleteRideButtonPressed) forControlEvents:UIControlEventTouchDown];
        return actionCell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

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

#pragma mark - offer ride cell

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

-(void)removeRideRequest:(Request*)request {
    if ([[RidesStore sharedStore] removeRequestForRide:self.ride.rideId request:request]) {
        [self.rideDetail.tableView reloadData];
    }
}

-(void)updatePassengerCellsForPassenger:(User *)passenger {
    if ([[RidesStore sharedStore] removePassengerForRide:self.ride.rideId passenger:passenger]) {
        [self.rideDetail.tableView reloadData];
    }
}

-(void)moveRequestorToPassengers:(User *)requestor {
    if ([[RidesStore sharedStore] addPassengerForRideId:self.ride.rideId requestor:requestor]) {
        [self.rideDetail.tableView reloadData];
    }
}

-(void)contactPassengerButtonPressedForUser:(User *)user {
    SimpleChatViewController *chatVC = [[SimpleChatViewController alloc] init];
    [self.navigationController pushViewController:chatVC animated:YES];
}

// removing passenger or ride request
-(void)leftButtonPressedWithObject:(id)object cellType:(CellTypeEnum)cellType {
    
    if (cellType == PassengerCell) {
        User *user = (User *)object;
        [WebserviceRequest removePassengerWithId:user.userId rideId:self.ride.rideId block:^(BOOL fetched) {
            if (fetched) {
                [self updatePassengerCellsForPassenger:user];
            }
        }];
    } else if(cellType == RequestCell) {
        Request *request = (Request *)object;
        [WebserviceRequest acceptRideRequest:request isConfirmed:NO block:^(BOOL isAccepted) {
            if (isAccepted) {
                [self removeRideRequest:request];
            } else {
                NSLog(@"could not be accepted");
            }
        }];
    }
}

// accepting ride request or sending him a message
-(void)rightButtonPressedWithObject:(id)object cellType:(CellTypeEnum)cellType {
    if (cellType == PassengerCell) {
        
        User *user = (User *)object;
        [self contactPassengerButtonPressedForUser:user];
        
    } else if(cellType == RequestCell) {
        
        Request *request = (Request *)object;
        [WebserviceRequest getUserWithId:request.passengerId block:^(User * user) {
            if (user != nil) {
                [WebserviceRequest acceptRideRequest:request isConfirmed:YES block:^(BOOL isAccepted) {
                    if (isAccepted) {
                        [self moveRequestorToPassengers:user];
                    } else {
                        NSLog(@"could not be accepted");
                    }
                }];
            }
        }];
    }

}
-(void)dealloc {
    [[RidesStore sharedStore] removeObserver:self];
}

@end

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
#import "EditRideViewController.h"
#import "ProfileViewController.h"
#import "CustomIOS7AlertView.h"
#import "Rating.h"
#import "ConversationUtilities.h"
#import "AWSUploader.h"
#import "ActivityStore.h"

@interface OwnerOfferViewController () <UIGestureRecognizerDelegate, RideStoreDelegate, HeaderContentViewDelegate, RidePersonCellDelegate, CustomIOS7AlertViewDelegate, UITextViewDelegate>

@end

@implementation OwnerOfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _headerView.backgroundColor = [UIColor darkerBlue];
    [self.view bringSubviewToFront:_headerView];
    [[RidesStore sharedStore] addObserver:self];
    
    self.rideDetail.headerView = _headerView;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.screenName = @"Owner offer screen";
    
    self.headerViewLabel.text = [@"To " stringByAppendingString:self.ride.destination];
    self.headerTitles = [NSArray arrayWithObjects:@"Details", @"Passengers", @"Requests", @"", nil];

    if ([self isPastRide]) {
        editButton.hidden = YES;
    }
    [self markRequestsAsRead];
    [self markDeletedPassengersAsRead];
    
    [self reloadTableAndRide];
}

-(void)markRequestsAsRead {
    for (Request *request in self.ride.requests) {
        request.isSeen = [NSNumber numberWithBool:YES];
    }
    [[RidesStore sharedStore] saveToPersistentStore:self.ride];
}

-(void)markDeletedPassengersAsRead {
    
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
    // if past ride then don't show last section with action button
    if ([self isPastRide]) {
        return 3;
    }
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
        if (self.ride.car != nil) {
            cell.carLabel.text = self.ride.car;
        } else if (self.ride.rideOwner != nil && self.ride.rideOwner.car != nil) {
            cell.carLabel.text = self.ride.rideOwner.car;
        } else {
            cell.carLabel.text = @"Not specified";
        }
        cell.informationLabel.text = self.ride.meetingPoint;
        cell.freeSeatsLabel.text = [NSString stringWithFormat:@"%@", self.ride.freeSeats];
        
        return cell;
    } else if (indexPath.section == 1 && [self.ride.passengers count] > 0) { // show passengers
        RidePersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RidePersonCell"];
        if (cell == nil) {
            cell = [RidePersonCell ridePersonCell];
        }
        User *passenger = [[self.ride.passengers allObjects] objectAtIndex:indexPath.row];
        cell.personNameLabel.text = passenger.firstName;
        if (passenger.profileImageData != nil) {
            cell.personImageView.image = [UIImage imageWithData:passenger.profileImageData];
        } else {
            [[AWSUploader sharedStore] downloadProfilePictureForUser:passenger];
        }
        cell.delegate = self;
        cell.leftObject = passenger;
        cell.rightObject = passenger;
        cell.cellTypeEnum = PassengerCell;
        if ([self isPastRide]) {
            [cell.leftButton setBackgroundImage:[UIImage imageNamed:@"DislikeIconBlack"] forState:UIControlStateNormal];
            [cell.rightButton setBackgroundImage:[UIImage imageNamed:@"LikeIconBlack"] forState:UIControlStateNormal];
            
            Rating *rating = [self isRatingGivenForUserId:passenger.userId];
            if (rating != nil && [rating.ratingType boolValue]) {
                cell.leftButton.hidden = YES;
                cell.rightButton.enabled = NO;
            } else if(rating != nil && ![rating.ratingType boolValue]) {
                cell.leftButton.enabled = NO;
                cell.rightButton.hidden = YES;
            }
        } else {
            [cell.leftButton setBackgroundImage:[UIImage imageNamed:@"DeleteIconBlack"] forState:UIControlStateNormal];
            [cell.rightButton setBackgroundImage:[UIImage imageNamed:@"EmailIconBlack"] forState:UIControlStateNormal];
        }
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
        User *user = [CurrentUser fetchFromCoreDataUserWithId:request.passengerId];
        if(user != nil) {
            cell.personNameLabel.text = user.firstName;
            if (user.profileImageData != nil) {
                cell.personImageView.image = [UIImage imageWithData:user.profileImageData];
            } else {
                [[AWSUploader sharedStore] downloadProfilePictureForUser:user];
            }
        } else {
            [WebserviceRequest getUserWithIdFromWebService:request.passengerId block:^(User *user) {
                if (user != nil) {
                    [self.rideDetail.tableView reloadData];
                }
            }];
        }
        
        if ([self isPastRide]) {
            cell.leftButton.hidden = YES;
            cell.rightButton.hidden = YES;
        } else {
            [cell.leftButton setBackgroundImage:[UIImage imageNamed:@"DeleteIconBlack"] forState:UIControlStateNormal];
            [cell.rightButton setBackgroundImage:[UIImage imageNamed:@"AcceptIconBlack"] forState:UIControlStateNormal];
#ifdef DEBUG
            [cell.leftButton setAccessibilityLabel:@"Reject Button"];
            [cell.leftButton setIsAccessibilityElement:YES];
            [cell.rightButton setAccessibilityLabel:@"Accept Button"];
            [cell.rightButton setIsAccessibilityElement:YES];
#endif
        }
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
#ifdef DEBUG
        [actionCell.actionButton setAccessibilityLabel:@"Cancel Button"];
        [actionCell.actionButton setIsAccessibilityElement:YES];
#endif
        [actionCell.actionButton setTitle:@"Cancel ride" forState:UIControlStateNormal];
        [actionCell.actionButton addTarget:self action:@selector(showCancelationAlertView) forControlEvents:UIControlEventTouchDown];
        return actionCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    profileVC.returnEnum = ViewController;
    
    if (indexPath.section == 1 && [self.ride.passengers count] > 0) {
        profileVC.user = [[self.ride.passengers allObjects] objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:profileVC animated:YES];
    } else if(indexPath.section == 2 && [self.ride.requests count] > 0) {
        Request *request = [[self.ride.requests allObjects] objectAtIndex:indexPath.row];
        User *user = [CurrentUser fetchFromCoreDataUserWithId:request.passengerId];
        profileVC.user = user;
        [self.navigationController pushViewController:profileVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


#pragma mark - Button actions

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
    NSDictionary *queryParams = @{@"reason": self.textView.text};
    [objectManager deleteObject:self.ride path:[NSString stringWithFormat:@"/api/v2/rides/%@", self.ride.rideId] parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        [[CurrentUser sharedInstance].user removeRidesAsOwnerObject:self.ride];
        [[RidesStore sharedStore] deleteRideFromCoreData:self.ride];
        [KGStatusBar showWithStatus:@"Ride successfully deleted"];
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Load failed with error: %@", error);
    }];
}

-(void)removeRideRequest:(Request*)request {
    if ([[RidesStore sharedStore] removeRequestForRide:self.ride.rideId request:request]) {
        [self.rideDetail.tableView reloadData];
        [[ActivityStore sharedStore] deleteRequestFromActivites:request];
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
        [self findRequestForRide:self.ride requestor:requestor];
    }
}

-(void)findRequestForRide:(Ride *)ride requestor:(User *)requestor {
    for (Request *request in [self.ride.requests allObjects]) {
        if ([request.passengerId isEqualToNumber:requestor.userId]) {
            [[ActivityStore sharedStore] deleteRequestFromActivites:request];
            return;
        }
    }
}

-(void)contactPassengerButtonPressedForUser:(User *)user {
    SimpleChatViewController *chatVC = [[SimpleChatViewController alloc] init];
    chatVC.title = [NSString stringWithFormat:@"Chat with %@", user.firstName];
    chatVC.conversation = [ConversationUtilities findConversationBetweenUser:[CurrentUser sharedInstance].user otherUser:user conversationArray:[self.ride.conversations allObjects]];
    chatVC.otherUser = user;
    [self.navigationController pushViewController:chatVC animated:YES];
}

// removing passenger or ride request
-(void)leftButtonPressedWithObject:(id)object cellType:(CellTypeEnum)cellType {
    
    if (cellType == PassengerCell) {
        User *user = (User *)object;

        if ([self isPastRide]) {
            [WebserviceRequest giveRatingToUserWithId:user.userId rideId:self.ride.rideId ratingType:0 block:^(BOOL given) {
                if (given) {
                    [self updateRide];
                }
            }];
        } else {
            [WebserviceRequest removePassengerWithId:user.userId rideId:self.ride.rideId block:^(BOOL fetched) {
                if (fetched) {
                    [self updatePassengerCellsForPassenger:user];
                }
            }];
        }
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

        if ([self isPastRide]) {
            [WebserviceRequest giveRatingToUserWithId:user.userId rideId:self.ride.rideId ratingType:1 block:^(BOOL given) {
                if (given) {
                    [self updateRide];
                }
            }];
        } else {
            [self contactPassengerButtonPressedForUser:user];
        }
        
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

-(void)editButtonTapped {
    EditRideViewController *editRideVC = [[EditRideViewController alloc] init];
    editRideVC.ride = self.ride;
    [self.navigationController pushViewController:editRideVC animated:YES];
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

-(void)dealloc {
    [[RidesStore sharedStore] removeObserver:self];
}

@end

//
//  RideDetailViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "OfferViewController.h"
#import "RideInformationCell.h"
#import "PassengersCell.h"
#import "DriverCell.h"
#import "MessagesOverviewViewController.h"
#import "ActionManager.h"
#import "User.h"
#import "Request.h"
#import "CurrentUser.h"
#import "KGStatusBar.h"
#import "Ride.h"
#import "RidesStore.h"
#import "RideNoticeCell.h"
#import "HeaderContentView.h"
#import "RideDetailMapViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "RidesPageViewController.h"
#import "RideRequestInformationCell.h"
#import "CircularImageView.h"
#import "WebserviceRequest.h"
#import "OfferRideCell.h"
#import "SimpleChatViewController.h"
#import "EditRequestViewController.h"
#import "EditRideViewController.h"
#import "AddRideViewController.h"
#import "ActivityStore.h"
#import "RequestorCell.h"
#import "EmptyCell.h"

@interface OfferViewController () <UIGestureRecognizerDelegate, RideStoreDelegate, RideStoreDelegate, OfferRideCellDelegate, RequestorCellDelegate, PassengersCellDelegate, HeaderContentViewDelegate>

@property (strong, nonatomic) NSDictionary *backLinkInfo;
@property (weak, nonatomic) UIView *backLinkView;
@property (weak, nonatomic) UILabel *backLinkLabel;
@property (strong, nonatomic) NSArray *headerTitles;

@end

@implementation OfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.rideDetail = [[HeaderContentView alloc] initWithFrame:self.view.bounds];
    self.rideDetail.tableViewDataSource = self;
    self.rideDetail.tableViewDelegate = self;
    self.rideDetail.parallaxScrollFactor = 0.3; // little slower than normal.
    [self.view addSubview:self.rideDetail];
    
    _headerView.backgroundColor = [UIColor darkerBlue];
    [self.view bringSubviewToFront:_headerView];
    [[RidesStore sharedStore] addObserver:self];
    
    
    UIView *gradientViewFlipped = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 320, 180)];
    UIImageView *gradientImageView = [[UIImageView alloc] initWithFrame:gradientViewFlipped.frame];
    gradientImageView.image = [UIImage imageNamed:@"GradientWideFlipped"];
    [gradientViewFlipped addSubview:gradientImageView];
    [self.view addSubview:gradientViewFlipped];
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.frame = CGRectMake(200, 20, 44, 44);
    [refreshButton setImage:[UIImage imageNamed:@"RefreshIcon"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshRideButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshButton];
    
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame = CGRectMake(10, 25, 30, 30);
    [buttonBack setImage:[UIImage imageNamed:@"BackIcon"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mapButton.frame = CGRectMake(230, 20, 44, 44);
    [mapButton setImage:[UIImage imageNamed:@"MapIcon"] forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(mapButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mapButton];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(280, 25, 30, 30);
    [editButton setImage:[UIImage imageNamed:@"EditIcon"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editButton];
    
    
    self.rideDetail.shouldDisplayGradient = YES;
    self.rideDetail.headerView = _headerView;
    self.rideDetail.delegate = self;
    self.view.backgroundColor = [UIColor customLightGray];
    
    self.headerTitles = [NSArray arrayWithObjects:@"Details", @"Driver", @"",nil];
}

-(void)refreshRideButtonPressed {
    [[RidesStore sharedStore] fetchSingleRideFromWebserviceWithId:self.ride.rideId block:^(BOOL fetched) {
        [self.rideDetail.tableView reloadData];
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    
    if (self.ride.rideOwner == nil) {
        [[RidesStore sharedStore] fetchSingleRideFromWebserviceWithId:self.ride.rideId block:^(BOOL fetched) {
            [self.rideDetail.tableView reloadData];
        }];
    }
    
    if (self.ride.destinationImage == nil) {
        [RidesStore initRide:self.ride block:^(BOOL fetched) { }];
    } else {
        self.rideDetail.selectedImageData = self.ride.destinationImage;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.headerViewLabel.text = [@"To " stringByAppendingString:self.ride.destination];
    
}

-(void)viewDidAppear:(BOOL)animated {
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
        DriverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DriverCell"];
        if (cell == nil) {
            cell = [DriverCell driverCell];
        }
        
        if (self.ride.rideOwner != nil) {
            cell.driverNameLabel.text = self.ride.rideOwner.firstName;
            cell.driverRatingLabel.text = [NSString stringWithFormat:@"%.01f", [self.ride.rideOwner.ratingAvg floatValue]];
            CircularImageView *circularImageView = circularImageView = [[CircularImageView alloc] initWithFrame:CGRectMake(18, 15, 100, 100) image:[UIImage imageWithData:self.ride.rideOwner.profileImageData]];
            [cell addSubview:circularImageView];
        }
        
        return cell;
    } else if(indexPath.section == 2) { // show leave button
        
        OfferRideCell *actionCell = [OfferRideCell offerRideCell];
        actionCell.delegate = self;
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

-(BOOL)isPassengerOfRide {
    if ([self.ride.passengers containsObject:[CurrentUser sharedInstance].user]) {
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - map view methods

-(void)didReceivePhotoForRide:(NSNumber *)rideId {
    UIImage *img = [UIImage imageWithData:self.ride.destinationImage];
    [self.rideDetail.rideDetailHeaderView replaceMainImage:img];
}

-(void)dealloc {
    [[RidesStore sharedStore] removeObserver:self];
}

-(void)editDriverActionCellButtonPressed {
    EditRideViewController *editRideVC = [[EditRideViewController alloc] init];
    editRideVC.ride = self.ride;
    [self.navigationController pushViewController:editRideVC animated:YES];
}

-(void)contactDriverActionCellButtonPressed {
    MessagesOverviewViewController *messageOverviewVC = [[MessagesOverviewViewController alloc] init];
    messageOverviewVC.ride = self.ride;
    [self.navigationController pushViewController:messageOverviewVC animated:YES];
}

#pragma mark - requestor action cell

-(void)editRequestorActionCellButtonPressed {
    EditRequestViewController *editRequest = [[EditRequestViewController alloc] init];
    editRequest.ride = self.ride;
    [self.navigationController pushViewController:editRequest animated:YES];
}

#pragma mark - join driver cell

-(void)contactJoinDriverCellButtonPressed {
    SimpleChatViewController *chatVC = [[SimpleChatViewController alloc] init];
    [self.navigationController pushViewController:chatVC animated:YES];
}

-(void)joinJoinDriverCellButtonPressed {
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
    } else {
        
    }
}

#pragma mark - offer ride cell

-(void)offerRideButtonPressed {
    [self joinJoinDriverCellButtonPressed];
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

-(void)headerViewTapped {
    
}

-(void)editButtonTapped {
    
}

-(void)mapButtonTapped {
    RideDetailMapViewController *rideDetailMapVC = [[RideDetailMapViewController alloc] init];
    rideDetailMapVC.selectedRide = self.ride;
    [self.navigationController pushViewController:rideDetailMapVC animated:YES];
}

-(void)initFields {
    [self.rideDetail.refreshButton addTarget:self action:@selector(refreshRideButtonPressed) forControlEvents:UIControlEventTouchDown];
    self.rideDetail.departureLabel.text = self.ride.departurePlace;
    self.rideDetail.destinationLabel.text = self.ride.destination;
    self.rideDetail.timeLabel.text = [ActionManager timeStringFromDate:self.ride.departureTime];
    self.rideDetail.calendarLabel.text = [ActionManager dateStringFromDate:self.ride.departureTime];
}

@end
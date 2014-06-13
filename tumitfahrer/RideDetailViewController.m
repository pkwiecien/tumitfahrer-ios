//
//  RideDetailViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RideDetailViewController.h"
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
#import "ManageDriverRideViewController.h"
#import "RequestorActionCell.h"
#import "JoinDriverCell.h"
#import "OfferRideCell.h"
#import "SimpleChatViewController.h"
#import "EditRequestViewController.h"
#import "EditRideViewController.h"
#import "AddRideViewController.h"
#import "ActivityStore.h"
#import "RequestorCell.h"

@interface RideDetailViewController () <UIGestureRecognizerDelegate, RideStoreDelegate, RideStoreDelegate, RequestorActionCellDelegate, JoinDriverCellDelegate, OfferRideCellDelegate, RequestorCellDelegate, PassengersCellDelegate>

@property (strong, nonatomic) NSDictionary *backLinkInfo;
@property (weak, nonatomic) UIView *backLinkView;
@property (weak, nonatomic) UILabel *backLinkLabel;

@end

@implementation RideDetailViewController

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
    
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame = CGRectMake(10, 25, 30, 30);
    [buttonBack setImage:[UIImage imageNamed:@"BackIcon"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    
    self.rideDetail.shouldDisplayGradient = YES;
    self.rideDetail.headerView = _headerView;
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
        [RidesStore initRide:self.ride block:^(BOOL fetched) {
            
        }];
    } else {
        self.rideDetail.selectedImageData = self.ride.destinationImage;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.headerViewLabel.text = [@"To " stringByAppendingString:self.ride.destination];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.refererAppLink) {
        self.backLinkInfo = delegate.refererAppLink;
        [self _showBackLink];
    }
    delegate.refererAppLink = nil;
    [self initRideTypeEnum];
}

-(void)viewDidAppear:(BOOL)animated {
    if (self.displayEnum == ShouldShareRideOnFacebook) {
        [self shareLinkWithShareDialog];
        self.displayEnum = ShouldDisplayNormally;
    }
}

-(void)initRideTypeEnum {
    
    if (![self.ride.rideOwner.userId isEqualToNumber:[CurrentUser sharedInstance].user.userId] && [self.ride.isRideRequest boolValue]) {
        self.rideTypeEnum = CurrentUserIsNotRideOwnerAndRequests;
    } else if(![self.ride.rideOwner.userId isEqualToNumber:[CurrentUser sharedInstance].user.userId] && ![self.ride.isRideRequest boolValue]) {
        self.rideTypeEnum = CurrentUserIsNotRideOwnerAndDriver;
    } else if([self.ride.rideOwner.userId isEqualToNumber:[CurrentUser sharedInstance].user.userId] && ![self.ride.isRideRequest boolValue]) {
        self.rideTypeEnum = CurrentUserIsRideOwnerAndDriver;
    } else {
        self.rideTypeEnum = CurrentUserIsRideOwnerAndRequests;
    }
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 44.0f;
    } else if(indexPath.section == 1){
        return 44.0f;
    } else if(indexPath.section == 2){
        if ([self.ride.isRideRequest boolValue]) {
            return 160.0f;
        }
        return 240.0f;
    } else if(indexPath.section == 3){
        return 170.0f;
    } else if(indexPath.section == 4) {
        return 60;
    } else
        return 100.0f; //cell for comments, in reality the height has to be adjustable
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < 4) {
        return 1;
    } else if(section == 4) {
        return [self.ride.passengers count];
    } else if(section == 5) {
        return [self.ride.requests count];
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.rideTypeEnum == CurrentUserIsRideOwnerAndDriver) {
        return 6;
    } else if(self.rideTypeEnum == CurrentUserIsRideOwnerAndRequests) {
        return 4;
    } else if(self.rideTypeEnum == CurrentUserIsNotRideOwnerAndDriver) {
        return 4;
    } else {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *generalCell = [tableView dequeueReusableCellWithIdentifier:@"reusable"];
    if (!generalCell) {
        generalCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reusable"];
    }
    
    generalCell.textLabel.text = @"Default cell";
    
    if (indexPath.section == 0) {
        
        RideNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RideNoticeCell"];
        if(cell == nil){
            cell = [RideNoticeCell rideNoticeCell];
        }
        if ([self.ride.isRideRequest boolValue]) {
            cell.noticeLabel.text = @"Ride Request";
        } else if(self.ride.rideType == 0) {
            cell.noticeLabel.text = @"Campus Ride";
        } else {
            cell.noticeLabel.text = @"Activity Ride";
        }
        [cell.refreshButton addTarget:self action:@selector(refreshRideButtonPressed) forControlEvents:UIControlEventTouchDown];
        [cell.mapButton addTarget:self action:@selector(mapViewTap) forControlEvents:UIControlEventTouchDown];
        return cell;
    }
    else if(indexPath.section == 1) {
        if (self.rideTypeEnum == CurrentUserIsNotRideOwnerAndDriver) {
            JoinDriverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JoinDriverCell"];
            if(cell == nil){
                cell = [JoinDriverCell joinDriverCell];
            }
            cell.delegate = self;
            return cell;
        } else if(self.rideTypeEnum == CurrentUserIsNotRideOwnerAndRequests) {
            OfferRideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OfferRideCell"];
            if(cell == nil){
                cell = [OfferRideCell offerRideCell];
            }
            
            cell.delegate = self;
            return cell;
        }
        else if (self.rideTypeEnum == CurrentUserIsRideOwnerAndRequests) {
            
            RequestorActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RequestorActionCell"];
            if(cell == nil){
                cell = [RequestorActionCell requestorActionCell];
            }
            
            cell.delegate = self;
            return cell;
            
        } else {
            DriverActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailsMessagesChoiceCell"];
            if(cell == nil){
                cell = [DriverActionCell driverActionCell];
            }
            
            cell.delegate = self;
            return cell;
        }
    }
    else if(indexPath.section == 2) {
        if (![self.ride.isRideRequest boolValue]) {
            RideInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RideInformationCell"];
            if(cell == nil){
                cell = [RideInformationCell rideInformationCell];
            }
            cell.departurePlaceLabel.text = self.ride.departurePlace;
            cell.destinationLabel.text = self.ride.destination;
            cell.timeLabel.text = [ActionManager timeStringFromDate:self.ride.departureTime];
            cell.dateLabel.text = [ActionManager dateStringFromDate:self.ride.departureTime];
            if (self.ride.rideOwner == nil || self.ride.rideOwner.car == nil) {
                cell.carLabel.text = @"Not specified";
            } else {
                cell.carLabel.text = self.ride.rideOwner.car;
            }
            cell.informationLabel.text = self.ride.meetingPoint;
            
            return cell;
        } else {
            RideRequestInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RideRequestInformationCell"];
            if(cell == nil){
                cell = [RideRequestInformationCell rideRequestInformationCell];
            }
            cell.departurePlaceLabel.text = self.ride.departurePlace;
            cell.destinationLabel.text = self.ride.destination;
            cell.timeLabel.text = [ActionManager timeStringFromDate:self.ride.departureTime];
            cell.dateLabel.text = [ActionManager dateStringFromDate:self.ride.departureTime];
            
            return cell;
        }
    } else if(indexPath.section == 3) {
        
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
    } else if(indexPath.section == 4) { // passenger cell
        
        PassengersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PassengersCell"];
        if (cell == nil) {
            cell = [PassengersCell passengersCell];
        }
        cell.indexPath = indexPath;
        
        User *user =[[self.ride.passengers allObjects] objectAtIndex:indexPath.row];
        cell.passengerName.text = user.firstName;
        cell.user = user;
        cell.rideId = self.ride.rideId;
        return cell;
    } else { // request cell
        
        RequestorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RequestorCell"];
        if (cell == nil) {
            cell = [RequestorCell requestorCell];
        }
        cell.rideId = self.ride.rideId;
        cell.indexPath = indexPath;
        cell.delegate = self;
        
        Request *request =[[self.ride.requests allObjects] objectAtIndex:indexPath.row];
        [WebserviceRequest getUserWithId:request.passengerId block:^(User * user) {
            cell.request = request;
            cell.user = user;
            [self.rideDetail.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        return cell;
    }
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

#pragma mark - map view methods

-(void)mapViewTap {
    RideDetailMapViewController *rideDetailMapVC = [[RideDetailMapViewController alloc] init];
    rideDetailMapVC.selectedRide = self.ride;
    [self.navigationController pushViewController:rideDetailMapVC animated:YES];
}

-(void)didReceivePhotoForRide:(NSNumber *)rideId {
    UIImage *img = [UIImage imageWithData:self.ride.destinationImage];
    [self.rideDetail.rideDetailHeaderView replaceMainImage:img];
}

-(void)dealloc {
    [[RidesStore sharedStore] removeObserver:self];
}

#pragma mark - Facebook sharing methods

//------------------Sharing a link using the share dialog------------------
- (void)shareLinkWithShareDialog
{
    
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        
        // Put together the dialog parameters
        NSString *caption = [NSString stringWithFormat:@"TUMitfahrer - carsharing platform for students"];
        NSString *departurePlaceName  = [self.ride.departurePlace componentsSeparatedByString: @","][0];
        NSString *destinationName  = [self.ride.destination componentsSeparatedByString: @","][0];
        
        NSString *description = [NSString stringWithFormat:@"I've just created a ride from %@ to %@, on %@. Join me!", departurePlaceName, destinationName, [ActionManager stringFromDate:self.ride.departureTime]];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"TUMitfaher", @"name",
                                       caption, @"caption",
                                       description, @"description",
                                       @"https://developers.facebook.com/docs/ios/share/", @"link",
                                       @"https://raw.githubusercontent.com/pkwiecien/tumitfahrer/develop/public/TUMitfahrer-logo-small.png", @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }
}

//------------------------------------




//------------------------------------

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

//------------------------------------

//------------------Handling links back to app link launching app------------------

- (void) _showBackLink {
    if (nil == self.backLinkView) {
        // Set up the view
        UIView *backLinkView = [[UIView alloc] initWithFrame:
                                CGRectMake(0, 30, 320, 40)];
        backLinkView.backgroundColor = [UIColor darkGrayColor];
        UILabel *backLinkLabel = [[UILabel alloc] initWithFrame:
                                  CGRectMake(2, 2, 316, 36)];
        backLinkLabel.textColor = [UIColor whiteColor];
        backLinkLabel.textAlignment = NSTextAlignmentCenter;
        backLinkLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        [backLinkView addSubview:backLinkLabel];
        self.backLinkLabel = backLinkLabel;
        [self.view addSubview:backLinkView];
        self.backLinkView = backLinkView;
    }
    // Show the view
    self.backLinkView.hidden = NO;
    // Set up the back link label display
    self.backLinkLabel.text = [NSString
                               stringWithFormat:@"Touch to return to %@", self.backLinkInfo[@"app_name"]];
    // Set up so the view can be clicked
    UITapGestureRecognizer *tapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(_returnToLaunchingApp:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.backLinkView addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
}

- (void)_returnToLaunchingApp:(id)sender {
    // Open the app corresponding to the back link
    NSURL *backLinkURL = [NSURL URLWithString:self.backLinkInfo[@"url"]];
    if ([[UIApplication sharedApplication] canOpenURL:backLinkURL]) {
        [[UIApplication sharedApplication] openURL:backLinkURL];
    }
    self.backLinkView.hidden = YES;
}


#pragma mark - delegate methods

#pragma mark - driver action cell

-(void)peopleDriverActionCellButtonPressed {
    ManageDriverRideViewController *manageRideVC = [[ManageDriverRideViewController alloc] init];
    manageRideVC.ride = self.ride;
    [self.navigationController pushViewController:manageRideVC animated:YES];
}

-(void)deleteDriverActionCellButtonPressed {
    [self deleteRide:self.ride];
}

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

-(void)deleteRequestorActionCellButtonPressed {
    [self deleteRide:self.ride];
}

#pragma mark - join driver cell

-(void)contactJoinDriverCellButtonPressed {
    SimpleChatViewController *chatVC = [[SimpleChatViewController alloc] init];
    [self.navigationController pushViewController:chatVC animated:YES];
}

-(void)joinJoinDriverCellButtonPressed {
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
            [[RidesStore sharedStore] addRideRequestToStore:rideRequest];
            NSLog(@"Ride request: %@", rideRequest);
            [self.ride addRequestsObject:rideRequest];
            [self.rideDetail.tableView reloadData];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [ActionManager showAlertViewWithTitle:[error localizedDescription]];
            RKLogError(@"Load failed with error: %@", error);
        }];
    } else {
        [objectManager deleteObject:request path:[NSString stringWithFormat:@"/api/v2/rides/%@/requests/%d", self.ride.rideId, [request.requestId intValue]] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            
            [KGStatusBar showSuccessWithStatus:@"Request canceled"];
            
            [self.ride removeRequestsObject:request];
            [[RidesStore sharedStore] deleteRideRequestFromCoreData:request];
            
            [self.rideDetail.tableView reloadData];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            RKLogError(@"Load failed with error: %@", error);
        }];
    }
}

#pragma mark - offer ride cell

-(void)offerRideButtonPressed {
    AddRideViewController *addRideVC = [[AddRideViewController alloc] init];
    addRideVC.RideType = [self.ride.rideType intValue];
    addRideVC.RideDisplayType = ShowAsViewController;
    [self.navigationController pushViewController:addRideVC animated:YES];
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

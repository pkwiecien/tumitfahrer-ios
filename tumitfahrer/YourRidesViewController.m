//
//  YourRidesViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/4/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "YourRidesViewController.h"
#import "ActionManager.h"
#import "YourRidesCell.h"
#import "NavigationBarUtilities.h"
#import "CurrentUser.h"
#import "Ride.h"
#import "RidesStore.h"
#import "CustomUILabel.h"
#import "MMDrawerBarButtonItem.h"
#import "WebserviceRequest.h"
#import "ControllerUtilities.h"
#import "RideSectionHeaderCell.h"
#import "EmptyCell.h"
#import "Request.h"
#import "PanoramioUtilities.h"
#import "ConversationUtilities.h"
#import "Conversation.h"
#import "Message.h"

@interface YourRidesViewController () <PanoramioUtilitiesDelegate>

@property (nonatomic, retain) UILabel *zeroRidesLabel;
@property CGFloat previousScrollViewYOffset;
@property UIImage *passengerIcon;
@property UIImage *driverIcon;
@property (nonatomic, strong) NSMutableArray *arrayWithSections;
@property (nonatomic, strong) NSMutableArray *arrayWithHeaders;
@property (nonatomic, strong) NSArray *emptyCellDescriptionsArray;
@property NSCache *imageCache;
@property UIRefreshControl *refreshControl;

@end

@implementation YourRidesViewController {
    UIImage *placeholderImage;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareZeroRidesLabel];
    [self.view setBackgroundColor:[UIColor customLightGray]];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    CGRect frame = CGRectMake (120.0, 185.0, 80, 80);
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    self.activityIndicatorView.color = [UIColor redColor];
    [self.view addSubview:self.activityIndicatorView];
    self.passengerIcon = [UIImage imageNamed:@"PassengerIconBlack"];
    self.driverIcon = [UIImage imageNamed:@"DriverIconBlack"];
    
    UIView *footerView = [[[NSBundle mainBundle] loadNibNamed:@"BrowseRidesPanoramioFooter" owner:self options:nil] objectAtIndex:0];
    self.tableView.tableFooterView = footerView;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing rides"];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.tintColor = [UIColor lightestBlue];
    [self.refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    NSArray *emptyCreated = [NSArray arrayWithObjects:@"No rides as driver", @"No requests for your rides", nil];
    NSArray *emptyJoined = [NSArray arrayWithObjects:@"No upcoming rides as passenger", @"No pending ride requests", nil];
    NSArray *emptyPast = [NSArray arrayWithObjects:@"You don't have any past rides", nil];
    self.emptyCellDescriptionsArray = [NSArray arrayWithObjects:emptyCreated, emptyJoined, emptyPast, nil];
    [[PanoramioUtilities sharedInstance] addObserver:self];
    self.imageCache = [[NSCache alloc] init];
    placeholderImage = [UIImage imageNamed:@"Placeholder"];

}

-(void)handleRefresh {
    [[RidesStore sharedStore] fetchRidesForCurrentUser:^(BOOL isFetched) {
        if (isFetched) {
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = [NSString stringWithFormat:@"Your rides: %d", (int)self.index];
    
    [self.delegate willAppearViewWithIndex:self.index];
    
    [self setupNavigationBar];
    [self setupLeftMenuButton];
    [self initRidesForCurrentSection];
    [self initTitlesForCurrentSection];
    [self.tableView reloadData];
    [self checkIfAnyRides];
    [self addToImageCache];
}

-(void)addToImageCache {
    
    int table = 0;
    for (NSArray *sectionArray in self.arrayWithSections) {
        int counter = 0;
        for (Ride *ride in sectionArray) {
            UIImage *image = [UIImage imageWithData:ride.destinationImage];
            if (image == nil) {
                image = placeholderImage;
                if (self.index != 2) {
                    [RidesStore initRide:ride block:^(BOOL fetched) {
                        if(fetched) {
                            [self initRidesForCurrentSection];
                            UIImage *image = [UIImage imageWithData:ride.destinationImage];
                            [self addImageToCache:image indexPath:[NSIndexPath indexPathForRow:counter inSection:table]];
                            [self.tableView reloadData];
                        }
                    }];
                }
            }
            [self addImageToCache:image indexPath:[NSIndexPath indexPathForRow:counter inSection:table]];
            counter++;
        }
        table++;
    }
}

-(void)addImageToCache:(UIImage *)image indexPath:(NSIndexPath *)indexPath {
    if (image == nil) {
        image = placeholderImage;
    }
    [_imageCache setObject:image forKey:indexPath];
}


-(void)checkIfAnyRides {
    int ridesCount = 0;
    for (NSArray *array in self.arrayWithSections) {
        ridesCount += [array count];
    }
    
    if (ridesCount == 0) {
        self.tableView.tableFooterView.hidden = YES;
    } else {
        self.tableView.tableFooterView.hidden = NO;
    }
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupNavigationBar {
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor lightestBlue]];
}

-(void)prepareZeroRidesLabel {
    self.zeroRidesLabel = [[CustomUILabel alloc] initInMiddle:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height) text:@"You don't have any rides" viewWithNavigationBar:self.navigationController.navigationBar];
    self.zeroRidesLabel.textColor = [UIColor blackColor];
}

-(void)initTitlesForCurrentSection {
    if(self.index == 0) {
        self.arrayWithHeaders = [[NSMutableArray alloc] initWithObjects:@"Rides as a Driver", @"Ride Requests", nil];
    } else if(self.index == 1) {
        self.arrayWithHeaders = [[NSMutableArray alloc] initWithObjects:@"Confirmed Rides as Passenger", @"Pending Ride Requests", nil];
    } else if(self.index == 2) {
        self.arrayWithHeaders = [[NSMutableArray alloc] initWithObjects:@"Past Rides", nil];
    }
}

-(void)initRidesForCurrentSection {
    NSDate *now = [ActionManager currentDate];
    self.arrayWithSections = [[NSMutableArray alloc] init];
    
    if (self.index == 0) {
        NSMutableArray *ridesAsOwner = [[NSMutableArray alloc] init];
        NSMutableArray *rideRequests = [[NSMutableArray alloc] init];
        
        for (Ride *ride in [CurrentUser sharedInstance].user.ridesAsOwner) {
            if (![ride.isRideRequest boolValue] && [ride.departureTime compare:now] == NSOrderedDescending) {
                [ridesAsOwner addObject:ride];
            } else if([ride.isRideRequest boolValue] && [ride.departureTime compare:now] == NSOrderedDescending) {
                [rideRequests addObject:ride];
            }
        }
        [self.arrayWithSections addObject:ridesAsOwner];
        [self.arrayWithSections addObject:rideRequests];
    } else if(self.index == 1) {
        
        NSMutableArray *ridesAsPassenger = [[NSMutableArray alloc] init];
        // should be: confirmed rides as passenger, pending requests
        for (Ride *ride in [CurrentUser sharedInstance].user.ridesAsPassenger) {
            if ([ride.departureTime compare:now] == NSOrderedDescending) {
                [ridesAsPassenger addObject:ride];
            }
        }
        
        NSMutableArray *requestedRides = [[NSMutableArray alloc] init];
        NSArray *currentUserRequests = [[CurrentUser sharedInstance] requests];
        for(Request *request in currentUserRequests) {
            if ([request.requestedRide.departureTime compare:now] == NSOrderedDescending) {
                [requestedRides addObject:request.requestedRide];
            }
        }
        
        [self.arrayWithSections addObject:ridesAsPassenger];
        [self.arrayWithSections addObject:requestedRides];
        
    } else  if(self.index == 2) {
        [[RidesStore sharedStore] fetchPastRidesFromCoreData];
        
        if ([[RidesStore sharedStore] pastRides].count == 0) {
            
            [WebserviceRequest getPastRidesForCurrentUserWithBlock:^(NSArray * fetchedRides) {
                [self initPastRidesWithRides:fetchedRides];
                [self stopActivityIndicator];
                [self.zeroRidesLabel removeFromSuperview];
            }];
        } else {
            self.arrayWithSections = [NSMutableArray arrayWithObject:[[RidesStore sharedStore] pastRides]];
        }
    }
}

-(void)initPastRidesWithRides:(NSArray *)fetchedRides {
    self.arrayWithSections = [NSMutableArray arrayWithObject:fetchedRides];
    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.arrayWithSections count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.arrayWithHeaders objectAtIndex:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    RideSectionHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RideNoticeCell"];
    if(cell == nil) {
        cell = [RideSectionHeaderCell rideSectionHeaderCell];
    }
    cell.noticeLabel.text = [self.arrayWithHeaders objectAtIndex:section];
    cell.contentView.backgroundColor = [UIColor lightestBlue];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = [[self.arrayWithSections objectAtIndex:section] count];
    if (rows > 0) {
        return rows;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([[self.arrayWithSections objectAtIndex:indexPath.section] count] == 0) { // just an empty cell
        
        EmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
        if(cell == nil){
            cell = [EmptyCell emptyCell];
        }
        cell.descriptionLabel.text = [[self.emptyCellDescriptionsArray objectAtIndex:self.index] objectAtIndex:indexPath.section];
        return cell;
        
    } else {
        YourRidesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YourRidesCell"];
        
        if(cell == nil){
            cell = [YourRidesCell yourRidesCell];
        }
        Ride *ride = [[self.arrayWithSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.departurePlaceLabel.text = ride.departurePlace;
        cell.destinationLabel.text = ride.destination;
        cell.departureTimeLabel.text = [ActionManager stringFromDate:ride.departureTime];
        if (self.index == 0) { // display new message, deleted or new request icon
            if([self rideHasUnseenMessage:ride]) {
                cell.firstImageView.hidden = NO;
            } else {
                cell.firstImageView.hidden =YES;
            }
            if ([self rideHasUnseenRequest:ride]) {
                cell.secondImageView.hidden = NO;
            } else {
                cell.secondImageView.hidden = YES;
            }
            if ([self rideHasUnseenCancelations:ride]) {
                cell.thirdImageView.hidden = NO;
            } else {
                cell.thirdImageView.hidden = YES;
            }
        } else if (self.index == 1) { // new message icon
            if([self rideHasUnseenMessage:ride]) {
                cell.firstImageView.hidden = NO;
            } else {
                cell.firstImageView.hidden =YES;
            }
        }
        
        UIImage *image = [_imageCache objectForKey:indexPath];
        cell.destinationImage.image = image;
        cell.destinationImage.clipsToBounds = YES;
        
        return cell;
    }
}

-(BOOL)rideHasUnseenMessage:(Ride *)ride {
    
    for (Conversation *conversation in ride.conversations) {
        NSLog(@"conversaion last seen: %@", conversation.lastMessageTime);
        if (((conversation.lastMessageTime != nil && conversation.seenTime == nil) || ([conversation.lastMessageTime compare:conversation.seenTime] == NSOrderedDescending)) && ![conversation.lastSenderId isEqualToNumber:[CurrentUser sharedInstance].user.userId]) {
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)rideHasUnseenRequest:(Ride *)ride {
    for (Request *request in ride.requests) {
        if (![request.isSeen boolValue]) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)rideHasUnseenCancelations:(Ride *)ride {
    if (ride.lastCancelTime != nil && [ride.lastCancelTime compare:ride.lastSeenTime] == NSOrderedDescending) {
        return YES;
    }
    return NO;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self.arrayWithSections objectAtIndex:indexPath.section] count] == 0) { // just an empty cell
        return;
    }
    UIViewController *vc = [ControllerUtilities viewControllerForRide:[[self.arrayWithSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Button Handlers

-(void)didReceivePhotoForLocation:(UIImage *)image rideId:(NSNumber *)rideId {
    // TODO: make smarter algorithm that will update only one cell
    [self.tableView reloadData];
}

-(void)leftDrawerButtonPress:(id)sender{
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)startActivityIndicator {
    [self.activityIndicatorView startAnimating];
}

- (void)stopActivityIndicator {
    [self.activityIndicatorView stopAnimating];
}

-(void)dealloc {
    self.delegate = nil;
    [self.imageCache removeAllObjects];
    [[PanoramioUtilities sharedInstance] removeObserver:self];
}

@end

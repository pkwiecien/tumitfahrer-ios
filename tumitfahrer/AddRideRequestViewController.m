//
//  AddRideRequestViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/1/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "AddRideRequestViewController.h"
#import "ActionManager.h"
#import "CustomBarButton.h"
#import "RideSearch.h"
#import "RideSearchResultsViewController.h"
#import "LocationController.h"
#import "RideSearchStore.h"
#import "NavigationBarUtilities.h"
#import "CurrentUser.h"
#import "RidesStore.h"
#import "Ride.h"
#import "RideDetailViewController.h"

@interface AddRideRequestViewController ()

@end


@implementation AddRideRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.departureTextField.delegate = self;
    self.destinationTextField.delegate = self;
    self.dateTextField.delegate = self;
    
    UIColor *iOSgreenColor = [UIColor colorWithRed:0.298 green:0.851 blue:0.392 alpha:1]; /*#4cd964*/
    UIImage *greanButtonImage = [ActionManager colorImage:[UIImage imageNamed:@"blueButton"] withColor:iOSgreenColor];
    [self.requestButton setBackgroundImage:greanButtonImage forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated {
    [self setupView];
}

-(void)setupView {
    self.view = [NavigationBarUtilities makeBackground:self.view];
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController];
    self.title = @"ADD RIDE REQUEST";
}

- (IBAction)requestRideButtonPressed:(id)sender {
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSDictionary *queryParams;
    // add enum
    NSString *departurePlace = self.departureTextField.text;
    NSString *destination = self.destinationTextField.text;
    NSString *freeSeats = @"1";
    NSString *meetingPoint = @"any";
    if (!departurePlace || !destination || !meetingPoint) {
        return;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    NSString *now = [formatter stringFromDate:[NSDate date]];
    
    queryParams = @{@"departure_place": departurePlace, @"destination": destination, @"departure_time": now, @"free_seats": freeSeats, @"meeting_point": meetingPoint, @"ride_type": [NSString stringWithFormat:@"%d", (int)ContentTypeExistingRequests]};
    NSDictionary *rideParams = @{@"ride": queryParams};
    
    [[[RKObjectManager sharedManager] HTTPClient] setDefaultHeader:@"apiKey" value:[[CurrentUser sharedInstance] user].apiKey];
    
    [objectManager postObject:nil path:@"/api/v2/rides" parameters:rideParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        Ride *ride = (Ride *)[mappingResult firstObject];
        [[RidesStore sharedStore] addRideToStore:ride];
        [[LocationController sharedInstance] fetchLocationForAddress:ride.destination rideId:ride.rideId];
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
        NSLog(@"This is ride: %@", ride);
        NSLog(@"This is driver: %@", ride.driver);
        RideDetailViewController *rideDetailVC = [[RideDetailViewController alloc] init];
        rideDetailVC.ride = ride;
        [self.navigationController pushViewController:rideDetailVC animated:YES];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [ActionManager showAlertViewWithTitle:[error localizedDescription]];
        RKLogError(@"Load failed with error: %@", error);
    }];
}

#pragma mark - RMDateSelectionViewController Delegates

- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    self.dateTextField.text = [ActionManager stringFromDate:aDate];
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    //Do something else
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField.tag ==3) {
        [self dismissKeyboard:nil];
        RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
        dateSelectionVC.delegate = self;
        
        [dateSelectionVC show];
        return false;
    }
    return true;
}

-(BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}


@end

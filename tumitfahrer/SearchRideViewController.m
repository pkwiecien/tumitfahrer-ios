//
//  SearchRideViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "SearchRideViewController.h"
#import "ActionManager.h"
#import "CustomBarButton.h"
#import "RideSearch.h"
#import "RideSearchResultsViewController.h"
#import "LocationController.h"
#import "RideSearchStore.h"
#import "NavigationBarUtilities.h"

@interface SearchRideViewController ()

@property (nonatomic) UIColor *customGrayColor;

@end

@implementation SearchRideViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.departureTextField.delegate = self;
    self.destinationTextField.delegate = self;
    self.dateTextField.delegate = self;
    
    UIColor *iOSgreenColor = [UIColor colorWithRed:0.298 green:0.851 blue:0.392 alpha:1]; /*#4cd964*/
    UIImage *greanButtonImage = [ActionManager colorImage:[UIImage imageNamed:@"blueButton"] withColor:iOSgreenColor];
    [self.searchButton setBackgroundImage:greanButtonImage forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated {
    [self setupView];
}

-(void)setupView {
    self.view = [NavigationBarUtilities makeBackground:self.view];
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController];
    self.title = @"SEARCH RIDES";
}

- (IBAction)searchButtonPressed:(id)sender {
    
    if (self.departureTextField.text.length >0 && self.departureTextField.text.length>0 && self.dateTextField.text != nil) {
        
        RKObjectManager *objectManager = [RKObjectManager sharedManager];
        
        NSDictionary *queryParams;
        // add enum
        queryParams = @{@"start_carpool": self.departureTextField.text, @"end_carpool": self.destinationTextField.text, @"ride_date":@"2012-02-02"};
        
        [objectManager postObject:nil path:API_SEARCH parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            
            NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
            NSArray* rides = [mappingResult array];
            
            for (RideSearch *rideSearchResult in rides) {
                [[RideSearchStore sharedStore] addSearchResult:rideSearchResult];
            }
            RideSearchResultsViewController *searchResultsVC = [[RideSearchResultsViewController alloc] init];
            [self.navigationController pushViewController:searchResultsVC animated:YES];
            
            for (RideSearch *rideSearchResult in rides) {
                [[LocationController sharedInstance] fetchPhotoURLForAddress:rideSearchResult.destination rideId:rideSearchResult.rideId completionHandler:^(CLLocation *location, NSURL * photoUrl) {
                    RideSearch *ride = [[RideSearchStore sharedStore] rideWithId:rideSearchResult.rideId];
                    ride.destinationLatitude = location.coordinate.latitude;
                    ride.destinationLongitude = location.coordinate.longitude;
                    ride.destinationImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:photoUrl]];
                    [searchResultsVC reloadDataAtIndex:0];
                }];
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [ActionManager showAlertViewWithTitle:[error localizedDescription]];
            RKLogError(@"Load failed with error: %@", error);
        }];
    }
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

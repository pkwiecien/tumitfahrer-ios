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
#import "CurrentUser.h"
#import "MMDrawerBarButtonItem.h"

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
    
    [self.view setBackgroundColor:[UIColor customLightGray]];
    UIImage *greanButtonImage = [ActionManager colorImage:[UIImage imageNamed:@"blueButton"] withColor:[UIColor lighterBlue]];
    [self.searchButton setBackgroundImage:greanButtonImage forState:UIControlStateNormal];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.detailsView.backgroundColor = [UIColor lighterBlue];
    self.detailsImageView.image = [ActionManager colorImage:[UIImage imageNamed:@"DetailsIcons"] withColor:[UIColor whiteColor]];
    self.rideTypeSegmentedControl.tintColor = [UIColor lighterBlue];
}

-(void)viewWillAppear:(BOOL)animated {
    [self setupNavigationBar];

    if(self.SearchDisplayType == ShowAsViewController)
        [self setupLeftMenuButton];
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupNavigationBar {
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor colorWithRed:0 green:0.463 blue:0.722 alpha:1] ];
    self.title = @"Search rides";
    
    UIButton *settingsView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [settingsView addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [settingsView setBackgroundImage:[ActionManager colorImage:[UIImage imageNamed:@"DeleteIcon2"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:settingsView];
    [self.navigationItem setLeftBarButtonItem:settingsButton];
}

- (IBAction)searchButtonPressed:(id)sender {
    
    if (self.departureTextField.text.length >0 && self.departureTextField.text.length>0 && self.dateTextField.text != nil) {
        
        RKObjectManager *objectManager = [RKObjectManager sharedManager];
        
        NSDictionary *queryParams;
        // add enum
        queryParams = @{@"start_carpool": self.departureTextField.text, @"end_carpool": self.destinationTextField.text, @"ride_date":@"2012-02-02", @"user_id": [NSNumber numberWithInt:[CurrentUser sharedInstance].user.userId], @"ride_type": [NSNumber numberWithInt:self.rideTypeSegmentedControl.selectedSegmentIndex]};
        
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
                    UIImage *image =[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:photoUrl]];
                    if(image) {
                        ride.destinationImage = UIImagePNGRepresentation(image);
                    }
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

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

-(void)closeButtonPressed {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Button Handlers

-(void)leftDrawerButtonPress:(id)sender{
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end

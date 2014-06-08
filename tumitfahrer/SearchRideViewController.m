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
#import "LocationController.h"
#import "RideSearchStore.h"
#import "NavigationBarUtilities.h"
#import "CurrentUser.h"
#import "MMDrawerBarButtonItem.h"
#import "SegmentedControlCell.h"
#import "SearchItemCell.h"
#import "ButtonCell.h"
#import "DestinationViewController.h"

@interface SearchRideViewController () <SementedControlCellDelegate, DestinationViewControllerDelegate, RMDateSelectionViewControllerDelegate>

@property (nonatomic) UIColor *customGrayColor;
@property (nonatomic, assign) NSInteger searchType;
@property (nonatomic, strong) NSDictionary *searchValues;
@property (nonatomic, strong) NSArray *icons;

@end

@implementation SearchRideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.searchValues = @{@"departure_place": @"", @"destination": @"", @"departure_time": @"", @"is_driver": [NSNumber numberWithBool:FALSE]};
    self.icons = @[[UIImage imageNamed:@"DepartureIconBlack"], [UIImage imageNamed:@"DestinationIconBlack"], [UIImage imageNamed:@"CalendarIconBlack"]];
    [self.view setBackgroundColor:[UIColor customLightGray]];
    
    UIView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"AddRideTableHeader" owner:self options:nil] objectAtIndex:0];
    self.tableView.tableHeaderView = headerView;
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
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor lighterBlue]];
    self.title = @"Search rides";
    
    UIButton *settingsView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [settingsView addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [settingsView setBackgroundImage:[UIImage imageNamed:@"DeleteIcon"] forState:UIControlStateNormal];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:settingsView];
    [self.navigationItem setLeftBarButtonItem:settingsButton];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    if (indexPath.row == 0) {
        
        SegmentedControlCell *cell = [SegmentedControlCell segmentedControlCell];
        cell.delegate = self;
        [cell setFirstSegmentTitle:@"I am Passenger" secondSementTitle:@"I am Driver"];
        [cell addHandlerToSegmentedControl];
        cell.controlId = 0;
        return cell;
    } else if(indexPath.row < 4) {
        SearchItemCell *cell = [SearchItemCell searchItemCell];
        cell.searchItemImageView.image = [self.icons objectAtIndex:(indexPath.row-1)];
        cell.index = indexPath.row -1;
        cell.searchItemTextField.tag = indexPath.row-1;
        return cell;
    } else if(indexPath.row == 4) {
        ButtonCell *cell = [ButtonCell buttonCell];
        [cell.cellButton addTarget:self action:@selector(searchButtonPressed) forControlEvents:UIControlEventAllEvents];
        return cell;
    }
 
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row <=2) {
        DestinationViewController *destinationVC = [[DestinationViewController alloc] init];
        destinationVC.rideTableIndexPath = indexPath;
        destinationVC.delegate = self;
        [self.navigationController pushViewController:destinationVC animated:YES];
    } else if (indexPath.row == 3) {
        RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
        dateSelectionVC.delegate = self;
        [dateSelectionVC show];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40.0)];
    headerView.backgroundColor = [UIColor lighterBlue];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 20, 20)];
    imageView.image = [UIImage imageNamed:@"DetailsIcon"];
    [headerView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 10, 10)];
    label.text = @"Details";
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    [headerView addSubview:label];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        return 60;
    }
    return 44;
}

-(void)searchButtonPressed {
    NSString *destination = self.searchValues[@"destination"];
    NSString *departurePlace = self.searchValues[@"departure_place"];
    NSString *departureTime = self.searchValues[@"departure_time"];
    
    if (departurePlace.length >0 && destination.length>0 && departureTime.length > 0) {
        
        RKObjectManager *objectManager = [RKObjectManager sharedManager];
        
        // add enum
//        queryParams = @{@"start_carpool": self.departureTextField.text, @"end_carpool": self.destinationTextField.text, @"ride_date":@"2012-02-02", @"user_id": [CurrentUser sharedInstance].user.userId, @"ride_type": [NSNumber numberWithInt:self.rideTypeSegmentedControl.selectedSegmentIndex]};
        
        [objectManager postObject:nil path:API_SEARCH parameters:self.searchValues success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            
            NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
            NSArray* rides = [mappingResult array];
            
            for (RideSearch *rideSearchResult in rides) {
                [[RideSearchStore sharedStore] addSearchResult:rideSearchResult];
            }
            
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [ActionManager showAlertViewWithTitle:[error localizedDescription]];
            RKLogError(@"Load failed with error: %@", error);
        }];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField.tag == 3) {
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
    [self.navigationController popViewControllerWithFade];
}

#pragma mark - Button Handlers

-(void)leftDrawerButtonPress:(id)sender{
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)selectedDestination:(NSString *)destination indexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - RMDateSelectionViewController Delegates

- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    NSString *dateString = [ActionManager stringFromDate:aDate];
    [self.searchValues setValue:dateString forKey:@"departure_time"];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    
}

-(void)segmentedControlChangedToIndex:(NSInteger)index segmentedControlId:(NSInteger)controlId {
    self.searchType = index;
}

@end

//
//  DestinationViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/25/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "DestinationViewController.h"
#import "ActionManager.h"
#import "CustomBarButton.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"
#import "LocationController.h"
#import "NavigationBarUtilities.h"

@interface DestinationViewController ()

@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *predefinedDestinations;

@end

@implementation DestinationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        searchQuery = [SPGooglePlacesAutocompleteQuery query];
        searchQuery.radius = 100.0;
        self.predefinedDestinations = [NSMutableArray arrayWithObjects:@"Arcistraße 21, München", @"Garching-Hochbrück", @"Garching Forschungszentrum", nil];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = NO;
    self.searchBar.placeholder = @"Search Address";
    self.searchBar.tintColor = [UIColor blueColor];
    NSDictionary *attributes =
    [NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
     setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
     setTitleTextAttributes:attributes forState:UIControlStateHighlighted];
    self.navigationItem.titleView = self.searchBar;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.searchBar becomeFirstResponder];
    self.view.backgroundColor = [UIColor customLightGray];
}

-(void)saveButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.predefinedDestinations count];
    } else
    return [searchResultPlaces count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"TUM Campuses";
    } else
        return @"Other Locations";
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (SPGooglePlacesAutocompletePlace *)placeAtIndexPath:(NSIndexPath *)indexPath {
    return [searchResultPlaces objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SPGooglePlacesAutocompleteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Thin" size:16.0];
    cell.textLabel.textColor = [UIColor blackColor];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [self.predefinedDestinations objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [self placeAtIndexPath:indexPath].name;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:70 green:30 blue:180 alpha:0.3];
    bgColorView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)dismissSearchControllerWhileStayingActive {
    // Animate out the table view.
    NSTimeInterval animationDuration = 0.3;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.searchDisplayController.searchResultsTableView.alpha = 0.0;
    [UIView commitAnimations];
    
    [self.searchDisplayController.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchDisplayController.searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *addressString = [self.predefinedDestinations objectAtIndex:indexPath.row];
        [self.delegate selectedDestination:addressString indexPath:self.rideTableIndexPath];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
       SPGooglePlacesAutocompletePlace *place = [self placeAtIndexPath:indexPath];
        
       [place resolveToPlacemark:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
            if (error) {
                SPPresentAlertViewWithErrorAndTitle(error, @"Could not map selected Place");
            } else if (placemark) {
                [self.delegate selectedDestination:addressString indexPath:self.rideTableIndexPath];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

#pragma mark -
#pragma mark UISearchDisplayDelegate

- (void)handleSearchForSearchString:(NSString *)searchString {
    
    searchQuery.input = searchString;
    searchQuery.location = [[LocationController sharedInstance] currentLocation].coordinate ;
    searchQuery.types = SPPlaceTypeGeocode; // Only return geocoding (address) results.
    searchQuery.radius = 100.0;
    searchQuery.language = @"en";
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
        if (error) {
            SPPresentAlertViewWithErrorAndTitle(error, @"Could not fetch Places");
        } else {
            searchResultPlaces = places;
            [self.tableView reloadData];
        }
        
    }];
}

#pragma mark -
#pragma mark UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self handleSearchForSearchString:searchText];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
}


@end

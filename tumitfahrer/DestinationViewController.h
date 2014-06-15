//
//  DestinationViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/25/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class SPGooglePlacesAutocompleteQuery;

@protocol DestinationViewControllerDelegate

-(void)selectedDestination:(NSString *)destination coordinate:(CLLocationCoordinate2D)coordinate indexPath:(NSIndexPath*)indexPath;

@end

@interface DestinationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
    
    NSArray *searchResultPlaces;
    SPGooglePlacesAutocompleteQuery *searchQuery;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) id <DestinationViewControllerDelegate> delegate;
@property (nonatomic) NSIndexPath *rideTableIndexPath;

@end

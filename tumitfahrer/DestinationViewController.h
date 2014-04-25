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

@interface DestinationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
    
    NSArray *searchResultPlaces;
    SPGooglePlacesAutocompleteQuery *searchQuery;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

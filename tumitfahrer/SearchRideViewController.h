//
//  SearchRideViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMDateSelectionViewController.h"

@interface SearchRideViewController : UIViewController <RMDateSelectionViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, assign) DisplayType SearchDisplayType;
@property (weak, nonatomic) IBOutlet UITextField *departureTextField;
@property (weak, nonatomic) IBOutlet UITextField *destinationTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *rideTypeSegmentedControl;

- (IBAction)searchButtonPressed:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end

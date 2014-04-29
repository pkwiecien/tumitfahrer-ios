//
//  SearchRideViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMDateSelectionViewController.h"
#import "SlideNavigationController.h"

@interface SearchRideViewController : UIViewController <RMDateSelectionViewControllerDelegate, UITextFieldDelegate, SlideNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *departureTextField;
@property (weak, nonatomic) IBOutlet UITextField *destinationTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
- (IBAction)dismissKeyboard:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
- (IBAction)searchButtonPressed:(id)sender;

@end

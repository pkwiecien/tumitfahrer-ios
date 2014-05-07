//
//  AddRideRequestViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/1/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMDateSelectionViewController.h"
#import "SlideNavigationController.h"

@interface AddRideRequestViewController : UIViewController <RMDateSelectionViewControllerDelegate, UITextFieldDelegate, SlideNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *departureTextField;
@property (weak, nonatomic) IBOutlet UITextField *destinationTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UIButton *requestButton;

- (IBAction)requestRideButtonPressed:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end

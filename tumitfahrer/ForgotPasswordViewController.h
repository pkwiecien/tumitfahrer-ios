//
//  ForgotPasswordViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 3/29/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController<UITextFieldDelegate>
- (IBAction)backToLoginButtonPressed:(id)sender;
- (IBAction)sendReminderButtonPressed:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end

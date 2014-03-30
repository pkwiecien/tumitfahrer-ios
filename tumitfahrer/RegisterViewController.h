//
//  RegisterViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 3/29/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UITextFieldDelegate>
- (IBAction)registerButtonPressed:(id)sender;
- (IBAction)backToLoginButtonPressed:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end

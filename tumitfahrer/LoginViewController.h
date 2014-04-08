//
//  LoginViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 3/29/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (strong) MPMoviePlayerController *moviePlayerController;

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)registerButtonPressed:(id)sender;
- (IBAction)forgotPasswordButtonPressed:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end

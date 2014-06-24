//
//  LoginViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 3/29/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "GAITrackedViewController.h"

@interface LoginViewController : GAITrackedViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (strong) MPMoviePlayerController *moviePlayerController;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)registerButtonPressed:(id)sender;
- (IBAction)forgotPasswordButtonPressed:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end

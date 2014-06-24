//
//  FeedbackViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/9/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface FeedbackViewController : GAITrackedViewController

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
- (IBAction)sendButtonPressed:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end

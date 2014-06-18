//
//  FeedbackViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/9/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "FeedbackViewController.h"
#import "KGStatusBar.h"
#import "ActionManager.h"
#import "CurrentUser.h"

@interface FeedbackViewController () <UIGestureRecognizerDelegate, UITextViewDelegate, UITextFieldDelegate>

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor customLightGray]];
    self.contentTextView.delegate = self;
    self.titleTextField.delegate = self;
    if (iPhone5) {
        self.sendButton.frame = CGRectMake(self.sendButton.frame.origin.x, [UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.frame.size.height - 120, 238, 38);
        self.contentTextView.frame = CGRectMake(self.contentTextView.frame.origin.x, self.contentTextView.frame.origin.y, self.contentTextView.frame.size.width, [UIScreen mainScreen].bounds.size.height - 200);
    } else {
        self.contentTextView.frame = CGRectMake(self.contentTextView.frame.origin.x, self.contentTextView.frame.origin.y, self.contentTextView.frame.size.width, [UIScreen mainScreen].bounds.size.height - 70);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqual:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.titleTextField) {
        [self.titleTextField resignFirstResponder];
        [self.contentTextView becomeFirstResponder];
        return NO;
    }
    return YES;
}

-(IBAction)sendButtonPressed:(id)sender {
    if (self.titleTextField.text.length == 0) {
        [ActionManager showAlertViewWithTitle:@"No description" description:@"Please describe your feedback"];
        return;
    }
    
    NSString *urlString = [API_ADDRESS stringByAppendingString:[NSString stringWithFormat:@"/api/v2/feedback"]];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"title=%@&content=%@&user_id=%@", self.titleTextField.text, self.contentTextView.text, [CurrentUser sharedInstance].user.userId];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError) {
            NSLog(@"Could not send feedback");
        } else {
            NSLog(@"Feedback sent!");
        }}];
    
    [KGStatusBar showSuccessWithStatus:@"Message sent. Thank you!"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

@end

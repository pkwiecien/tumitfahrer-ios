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

@interface FeedbackViewController () <UIGestureRecognizerDelegate, UITextViewDelegate>

@end

@implementation FeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor customLightGray]];
    self.contentTextView.delegate = self;
    [self addGestureRecognizerToTextField];
}

-(void)addGestureRecognizerToTextField {
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapRecognized)];
    singleTap.numberOfTapsRequired = 1;
    [self.contentTextView addGestureRecognizer:singleTap];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}



-(void)singleTapRecognized {
    if ([self.contentTextView isFirstResponder]) {
        [self.contentTextView endEditing:YES];
    } else {
        [self.contentTextView becomeFirstResponder];
    }
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

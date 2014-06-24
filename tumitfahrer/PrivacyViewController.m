//
//  PrivacyViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/9/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "PrivacyViewController.h"

@interface PrivacyViewController ()

@property NSArray *licensesArray;
@property NSArray *privacyArray;

@end

@implementation PrivacyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        NSString* license1 = [[NSBundle mainBundle] pathForResource:@"afnetworking" ofType:@"txt"];
        NSString* license2 = [[NSBundle mainBundle] pathForResource:@"EAIntroView" ofType:@"txt"];
        NSString* license4 = [[NSBundle mainBundle] pathForResource:@"JSMessagesViewController" ofType:@"txt"];
        NSString* license5 = [[NSBundle mainBundle] pathForResource:@"KGStatusBar" ofType:@"txt"];
        NSString* license6 = [[NSBundle mainBundle] pathForResource:@"KIF" ofType:@"txt"];
        NSString* license7 = [[NSBundle mainBundle] pathForResource:@"Facebook-iOS-SDK" ofType:@"txt"];
        NSString* license8 = [[NSBundle mainBundle] pathForResource:@"KIF" ofType:@"txt"];
        NSString* license9 = [[NSBundle mainBundle] pathForResource:@"MMDrawerController" ofType:@"txt"];
        NSString* license10 = [[NSBundle mainBundle] pathForResource:@"restkit" ofType:@"txt"];
        NSString* license11 = [[NSBundle mainBundle] pathForResource:@"RMDateSelectionViewController" ofType:@"txt"];
        NSString* license12 = [[NSBundle mainBundle] pathForResource:@"SocketRocket" ofType:@"txt"];
        NSString* license13 = [[NSBundle mainBundle] pathForResource:@"SPGooglePlacesAutocompletePlace" ofType:@"txt"];
        self.licensesArray = [NSArray arrayWithObjects:license1, license2, license4, license5, license6, license7, license8, license9, license10, license11, license12, license13, nil];
        NSString* privacy1 = [[NSBundle mainBundle] pathForResource:@"Privacy" ofType:@"txt"];
        self.privacyArray = [NSArray arrayWithObjects:privacy1, nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor customLightGray]];
    
    if (self.privacyViewTypeEnum == Licenses) {
        for(int i = 0; i< self.licensesArray.count; i++) {
            NSString *license = [NSString stringWithContentsOfFile:[self.licensesArray objectAtIndex:i] encoding:NSUTF8StringEncoding error:nil];
            
            self.contentTextView.text = [self.contentTextView.text stringByAppendingString:license];
        }
    } else {
        for(int i = 0; i< self.privacyArray.count; i++) {
            NSString *privacy = [NSString stringWithContentsOfFile:[self.privacyArray objectAtIndex:i] encoding:NSUTF8StringEncoding error:nil];
            
            self.contentTextView.text = [self.contentTextView.text stringByAppendingString:privacy];
        }
    }
}

@end

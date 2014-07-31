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
        
        NSString* license = [[NSBundle mainBundle] pathForResource:@"OpenSourceProjects" ofType:@"txt"];
        self.licensesArray = [NSArray arrayWithObjects:license, nil];
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

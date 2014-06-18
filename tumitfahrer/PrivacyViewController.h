//
//  PrivacyViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/9/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivacyViewController : UIViewController

typedef enum privacyViewType : NSUInteger {
    Privacy = 0,
    Licenses = 1
} PrivacyViewTypeEnum;

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (assign, nonatomic) PrivacyViewTypeEnum privacyViewTypeEnum;

@end

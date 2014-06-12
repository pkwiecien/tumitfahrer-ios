//
//  EditProfileFieldViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/12/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileFieldViewController : UIViewController <UITextViewDelegate>

typedef enum {
    FirstName = 0,
    LastName = 1,
    Email = 2,
    Phone = 3,
    Car = 4,
    Password = 5,
    Department = 6
} UpdateField;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSString *initialDescription;
@property (assign, nonatomic) UpdateField updatedFiled;

@end

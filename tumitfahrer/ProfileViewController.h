//
//  ProfileViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/5/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderContentView.h"
#import "GAITrackedViewController.h"

@class User;

@interface ProfileViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

typedef enum {
    Menu = 0,
    ViewController = 1
} ReturnEnum;

@property (nonatomic, strong) HeaderContentView *profileImageContentView;
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) ReturnEnum returnEnum;

@end

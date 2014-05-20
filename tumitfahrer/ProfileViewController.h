//
//  ProfileViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/5/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderContentView.h"

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, HeaderContentViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) HeaderContentView *profileImageContentView;

@end

//
//  ProfileViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/5/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SlideNavigationController.h>

@interface ProfileViewController : UIViewController<SlideNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *friendsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *ridesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *friendsButton;
@property (weak, nonatomic) IBOutlet UIButton *ridesButton;
@property (weak, nonatomic) IBOutlet UIButton *projectsButton;
@property (weak, nonatomic) IBOutlet UIButton *ratingButton;

- (IBAction)friendsButtonPressed:(id)sender;
- (IBAction)ridesButtonPressed:(id)sender;
- (IBAction)projectsButtonPressed:(id)sender;
- (IBAction)ratingButtonPressed:(id)sender;

@end

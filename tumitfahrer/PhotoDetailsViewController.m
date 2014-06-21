//
//  PhotoDetailsViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/21/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "PhotoDetailsViewController.h"
#import "NavigationBarUtilities.h"
#import "Photo.h"
#import "ActionManager.h"

@interface PhotoDetailsViewController ()

@end

@implementation PhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor customLightGray];
    
    self.photoImageView.image = self.photo;
}

-(void)viewWillAppear:(BOOL)animated {
    [self setupNavigationBar];
    [self setupLabels];
}

-(void)setupLabels {
    if (self.photoInfo.photoTitle.length == 0) {
        self.titleLabel.text = @"Unknown";
    } else {
        self.titleLabel.text = self.photoInfo.photoTitle;
    }
    if (self.photoInfo.ownerName.length == 0) {
        self.authorLabel.text = @"Unknown";
    } else {
        self.authorLabel.text = self.photoInfo.ownerName;
    }
    if (self.photoInfo.uploadDate.length == 0) {
        self.dateLabel.text = @"Unknown";
    } else {
        self.dateLabel.text = self.photoInfo.uploadDate;
    }
}

-(void)setupNavigationBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor darkerBlue]];
}

- (IBAction)linkButtonPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.photoInfo.photoUrl]];
}
@end

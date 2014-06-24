//
//  MeetingPointViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/25/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "MeetingPointViewController.h"
#import "ActionManager.h"
#import "CustomBarButton.h"

@interface MeetingPointViewController ()

@end

@implementation MeetingPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavbar];
}

-(void)viewWillAppear:(BOOL)animated {
    self.textView.text = self.startText;
    [self.textView becomeFirstResponder];
}

-(void)setupNavbar {
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor customLightGray];
    
    // right button of the navigation bar
    CustomBarButton *searchButton = [[CustomBarButton alloc] initWithTitle:@"Save"];
    [searchButton addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = searchButtonItem;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

- (void)saveButtonPressed {
    [self.selectedValueDelegate didSelectValue:self.textView.text forIndexPath:self.indexPath];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

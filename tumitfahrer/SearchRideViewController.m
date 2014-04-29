//
//  SearchRideViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "SearchRideViewController.h"
#import "ActionManager.h"
#import "CustomBarButton.h"

@interface SearchRideViewController ()

@property (nonatomic) UIColor *customGrayColor;

@end

@implementation SearchRideViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.customGrayColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    [self.view setBackgroundColor:self.customGrayColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self makeBackground];
    
    self.departureTextField.delegate = self;
    self.destinationTextField.delegate = self;
    self.dateTextField.delegate = self;
    
    UIColor *iOSgreenColor = [UIColor colorWithRed:0.298 green:0.851 blue:0.392 alpha:1]; /*#4cd964*/
    UIImage *greanButtonImage = [ActionManager colorImage:[UIImage imageNamed:@"blueButton"] withColor:iOSgreenColor];
    [self.searchButton setBackgroundImage:greanButtonImage forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated {
    [self setupNavbar];
}

-(void)makeBackground {
    UIImageView *imgBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gradientBackground"]];
    imgBackgroundView.frame = self.view.bounds;
    [self.view addSubview:imgBackgroundView];
    [self.view sendSubviewToBack:imgBackgroundView];
}

-(void)setupNavbar {
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBarHidden = NO;
    self.title = @"SEARCH A RIDE";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}


-(void)searchButtonPressed {
    
    if (self.departureTextField.text.length >0 && self.departureTextField.text.length>0 && self.dateTextField.text != nil) {
        
    }
    
}

-(void)closeButtonPressed {
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
}

#pragma mark - RMDateSelectionViewController Delegates

- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM"];
    NSString *stringFromDate = [formatter stringFromDate:aDate];
    self.dateTextField.text = stringFromDate;
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    //Do something else
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField.tag ==3) {
        
        RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
        dateSelectionVC.delegate = self;
        
        [dateSelectionVC show];
        return false;
    }
    return true;
}

-(BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)searchButtonPressed:(id)sender {
}
@end

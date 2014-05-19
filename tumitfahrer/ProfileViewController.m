//
//  ProfileViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/5/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ProfileViewController.h"
#import "ActionManager.h"
#import "NavigationBarUtilities.h"
#import "EditProfileViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "CustomBarButton.h"
#import "HeaderContentView.h"
#import "GeneralInfoCell.h"
#import "ProfileInfoCell.h"
#import "CurrentUser.h"

@interface ProfileViewController ()

@property (strong, nonatomic) NSMutableArray *cellDescriptions;
@property (strong, nonatomic) NSMutableArray *cellImages;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.cellImages = [[NSMutableArray alloc] initWithObjects:@"", [UIImage imageNamed:@"EmailIcon"], [UIImage imageNamed:@"PhoneIcon"], [UIImage imageNamed:@"CarIcon"], nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor customLightGray]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.profileImageContentView = [[HeaderContentView alloc] initWithFrame:self.view.bounds];
    self.profileImageContentView.tableViewDataSource = self;
    self.profileImageContentView.tableViewDelegate = self;
    self.profileImageContentView.parallaxScrollFactor = 0.3; // little slower than normal.
    self.profileImageContentView.circularImage = [UIImage imageNamed:@"Face"];
    [self.view addSubview:self.profileImageContentView];
    
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame = CGRectMake(10, 10, 30, 30);
    [buttonBack setImage:[ActionManager colorImage:[UIImage imageNamed:@"ArrowLeft"]  withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-40, 10, 30, 30);
    [editButton setImage:[ActionManager colorImage:[UIImage imageNamed:@"EditIcon"]  withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(displayEditProfilePage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editButton];
    
    self.cellDescriptions = [[NSMutableArray alloc] initWithObjects:@"", [CurrentUser sharedInstance].user.email, [CurrentUser sharedInstance].user.phoneNumber, [CurrentUser sharedInstance].user.car,  nil];
    
    UIImage *bluredImage = [ActionManager applyBlurFilterOnImage:[UIImage imageNamed:@"Face"]];
    self.profileImageContentView.selectedImageData = UIImagePNGRepresentation(bluredImage);
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        GeneralInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GeneralInfoCell"];
        
        if(cell == nil){
            cell = [GeneralInfoCell generalInfoCell];
        }

        cell.driverLabel.text = [NSString stringWithFormat:@"%d", [[CurrentUser sharedInstance].user.ridesAsDriver count]];
        cell.passengerLabel.text = [NSString stringWithFormat:@"%d", [[CurrentUser sharedInstance].user.ridesAsPassenger count]];
        cell.ratingLabel.text = [NSString stringWithFormat:@"%d", [[CurrentUser sharedInstance].user.ridesAsDriver count]];
        
        return cell;

    } else {
        ProfileInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileInfoCell"];
        if (cell == nil) {
            cell = [ProfileInfoCell profileInfoCell];
        }
        
        cell.cellDescription.text = [self.cellDescriptions objectAtIndex:indexPath.row];
        cell.cellImageView.image = [self.cellImages objectAtIndex:indexPath.row];
        return cell;
    }
}

#pragma mark - Button handlers

- (void)back {
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)displayEditProfilePage {
    EditProfileViewController *editProfileVC = [[EditProfileViewController alloc] init];
    UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:editProfileVC];
    [self.navigationController presentViewController:navBar animated:YES completion:nil];
}

@end

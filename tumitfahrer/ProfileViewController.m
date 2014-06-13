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
#import "MMDrawerBarButtonItem.h"
#import "CustomBarButton.h"
#import "GeneralInfoCell.h"
#import "CurrentUser.h"
#import "EditProfileFieldViewController.h"
#import "FacultyManager.h"
#import "EditDepartmentViewController.h"

@interface ProfileViewController ()

@property (strong, nonatomic) NSArray *cellDescriptions;
@property (strong, nonatomic) NSArray *cellImages;
@property (strong, nonatomic) NSArray *editDescriptions;
@property (nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.cellImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"ProfileIconBlack"], [UIImage imageNamed:@"ProfileIconBlack"], [UIImage imageNamed:@"EmailIconBlackSmall"], [UIImage imageNamed:@"PhoneIconBlack"], [UIImage imageNamed:@"CarIconBlack"], [UIImage imageNamed:@"PasswordIconBlack"],  [UIImage imageNamed:@"CarIconBlack"], nil];
        self.editDescriptions = [NSArray arrayWithObjects:@"First Name",@"Last Name", @"Email", @"Phone", @"Car", @"Password", @"Department", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor customLightGray]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.profileImageContentView = [[HeaderContentView alloc] initWithFrame:self.view.bounds];
    self.profileImageContentView.delegate = self;
    self.profileImageContentView.tableViewDataSource = self;
    self.profileImageContentView.tableViewDelegate = self;
    self.profileImageContentView.parallaxScrollFactor = 0.3; // little slower than normal.
    self.profileImageContentView.circularImage = [UIImage imageNamed:@"MainCampus"];
    self.profileImageContentView.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.profileImageContentView];
    
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame = CGRectMake(10, 10, 30, 30);
    [buttonBack setImage:[UIImage imageNamed:@"BackIcon"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-40, 10, 33, 25);
    [editButton setImage:[UIImage imageNamed:@"CameraIcon"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(headerViewTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editButton];
    
    UIImage *bluredImage = [ActionManager applyBlurFilterOnImage:[UIImage imageNamed:@"MainCampus"]];
    self.profileImageContentView.selectedImageData = UIImagePNGRepresentation(bluredImage);
    if ([CurrentUser sharedInstance].user.profileImageData != nil) {
        UIImage *profilePic = [UIImage imageWithData:[CurrentUser sharedInstance].user.profileImageData];
        if(profilePic.imageOrientation == UIImageOrientationUp) {
            NSLog(@"image orientation up");
        } else {
            NSLog(@"image orientation different");
        }
        self.profileImageContentView.circularImage = profilePic;
    } else {
        //        self.profileImageContentView.circularImage = [UIImage imageNamed:@"CircleBlue"];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self updateCellDescriptions];
    [self.profileImageContentView.tableView reloadData];
}

-(void)updateCellDescriptions {
    NSString *phoneNumber = @"Not defined";
    if ([CurrentUser sharedInstance].user.phoneNumber != nil) {
        phoneNumber = [CurrentUser sharedInstance].user.phoneNumber;
    }
    NSString *car = @"Not defined";
    if ([CurrentUser sharedInstance].user.car != nil) {
        car = [CurrentUser sharedInstance].user.car;
    }
    
    NSString *department = [NSString stringWithFormat:@"%@", [[FacultyManager sharedInstance] nameOfFacultyAtIndex:[[CurrentUser sharedInstance].user.department intValue]]];
    self.cellDescriptions = [[NSArray alloc] initWithObjects:[CurrentUser sharedInstance].user.firstName, [CurrentUser sharedInstance].user.lastName, [CurrentUser sharedInstance].user.email, phoneNumber, car, @"●●●●●●", department, nil];
}

-(void)oneFingerTwoTaps {
    
}
#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else
        return [self.cellDescriptions count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        GeneralInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GeneralInfoCell"];
        
        if(cell == nil){
            cell = [GeneralInfoCell generalInfoCell];
        }
        
        cell.driverLabel.text = [NSString stringWithFormat:@"%d", (int)[[CurrentUser sharedInstance].user.ridesAsOwner count]];
        cell.passengerLabel.text = [NSString stringWithFormat:@"%d", (int)[[CurrentUser sharedInstance].user.ridesAsPassenger count]];
        cell.ratingLabel.text = [NSString stringWithFormat:@"%d", (int)[CurrentUser sharedInstance].user.ratingAvg];
        return cell;
        
    } else{
        NSString *CellIdentifier = @"GeneralCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.imageView.image = [self.cellImages objectAtIndex:indexPath.row];
        cell.textLabel.text = [self.cellDescriptions objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor customLightGray];
        if (![[self.cellDescriptions objectAtIndex:indexPath.row] isEqualToString:[CurrentUser sharedInstance].user.email]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.profileImageContentView.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0 || [[self.cellDescriptions objectAtIndex:indexPath.row] isEqualToString:[CurrentUser sharedInstance].user.email]) {
        // do nothing
    } else if(indexPath.row == [self.cellDescriptions count]-1) {
        EditDepartmentViewController *editDepartmentVC = [[EditDepartmentViewController alloc] init];
        editDepartmentVC.title = @"Department";
        [self.navigationController pushViewController:editDepartmentVC animated:YES];
    } else {
        EditProfileFieldViewController *editProfileVC = [[EditProfileFieldViewController alloc] init];
        editProfileVC.title = [self.editDescriptions objectAtIndex:indexPath.row];
        editProfileVC.initialDescription = [self.cellDescriptions objectAtIndex:indexPath.row];
        editProfileVC.updatedFiled = indexPath.row;
        [self.navigationController pushViewController:editProfileVC animated:YES];
    }
}

#pragma mark - Button handlers

- (void)back {
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)headerViewTapped {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Change profile picture:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Take a photo",
                            @"Select a photo",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self takePhoto];
                    break;
                case 1:
                    [self selectPhoto];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

- (void)takePhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = NO;
    self.imagePickerController = picker;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)selectPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.profileImageContentView.rideDetailHeaderView.circularImage = chosenImage;
    [self.profileImageContentView.rideDetailHeaderView replaceImage:chosenImage];
    [CurrentUser sharedInstance].user.profileImageData = UIImageJPEGRepresentation(chosenImage, 1.0f);
    [picker dismissViewControllerAnimated:YES completion:NULL];
    NSError *error;
    if (![[CurrentUser sharedInstance].user.managedObjectContext saveToPersistentStore:&error]) {
        NSLog(@"Whoops");
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end

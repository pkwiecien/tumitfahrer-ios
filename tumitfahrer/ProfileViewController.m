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
#import "RidesStore.h"
#import "User.h"
#import "AWSUploader.h"

@interface ProfileViewController () <AWSUploaderDelegate, HeaderContentViewDelegate>

@property (strong, nonatomic) NSArray *cellDescriptions;
@property (strong, nonatomic) NSArray *ownerCellImages;
@property (strong, nonatomic) NSArray *otherCellImages;
@property (strong, nonatomic) NSArray *cellImages;
@property (strong, nonatomic) NSArray *editDescriptions;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) NSData *initialImageData;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.ownerCellImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"ProfileIconBlack"], [UIImage imageNamed:@"ProfileIconBlack"], [UIImage imageNamed:@"EmailIconBlackSmall"], [UIImage imageNamed:@"PhoneIconBlackSmall"], [UIImage imageNamed:@"CarIconBlack"], [UIImage imageNamed:@"PasswordIconBlackMedium"],  [UIImage imageNamed:@"CampusIconBlack"],[UIImage imageNamed:@"CampusIconBlack"], nil];
        self.otherCellImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"ProfileIconBlack"], [UIImage imageNamed:@"EmailIconBlackSmall"], [UIImage imageNamed:@"PhoneIconBlackSmall"], [UIImage imageNamed:@"CarIconBlack"], [UIImage imageNamed:@"CampusIconBlack"], nil];
        self.editDescriptions = [NSArray arrayWithObjects:@"First Name",@"Last Name", @"Email", @"Phone", @"Car", @"Password", @"Department", nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (iPhone5) {
        self.view.frame = CGRectMake(0, 0, 320, 568);
    } else {
        self.view.frame = CGRectMake(0, 0, 320, 480);
    }
    [self.view setBackgroundColor:[UIColor customLightGray]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.profileImageContentView = [[HeaderContentView alloc] initWithFrame:self.view.bounds];
    self.profileImageContentView.delegate = self;
    self.profileImageContentView.tableViewDataSource = self;
    self.profileImageContentView.tableViewDelegate = self;
    self.profileImageContentView.parallaxScrollFactor = 0.3; // little slower than normal.
    self.profileImageContentView.circularImage = [UIImage imageNamed:@"MainCampus.jpg"];
    self.profileImageContentView.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.profileImageContentView];
    
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame = CGRectMake(10, 10, 30, 30);
    [buttonBack setImage:[UIImage imageNamed:@"BackIcon"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    
    [[RidesStore sharedStore] fetchPastRidesFromCoreData];
    [AWSUploader sharedStore].delegate = self;
    
    self.initialImageData = [CurrentUser sharedInstance].user.profileImageData;
}


-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (self.user == nil) {
        self.user = [CurrentUser sharedInstance].user;
    }
    [self initProfilePic];
    
    [self updateCellDescriptions];
    [self.profileImageContentView.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
    if(self.user.profileImageData == nil) {
        [[AWSUploader sharedStore] downloadProfilePictureForUser:self.user];
    }
}

-(void)didDownloadImageData:(NSData *)imageData user:(User *)user {
    UIImage *profileImage = [UIImage imageWithData:imageData];
    self.profileImageContentView.rideDetailHeaderView.circularImage = profileImage;
    [self.profileImageContentView.rideDetailHeaderView replaceImage:profileImage];
    self.user.profileImageData = imageData;
    self.initialImageData = imageData;
    [CurrentUser saveUserToPersistentStore:[CurrentUser sharedInstance].user];
}

-(void)initProfilePic {
    self.profileImageContentView.selectedImageData = UIImagePNGRepresentation([UIImage imageNamed:@"bg1.jpg"]);
    if (self.user.profileImageData != nil) {
        UIImage *profilePic = [UIImage imageWithData:self.user.profileImageData];
        self.profileImageContentView.circularImage = profilePic;
    } else {
    }
}

-(void)updateCellDescriptions {
    
    NSString *phoneNumber = @"Not defined";
    if (self.user.phoneNumber != nil) {
        phoneNumber = self.user.phoneNumber;
    }
    NSString *car = @"Not defined";
    if (self.user.car != nil) {
        car = self.user.car;
    }
    
    NSString *department = [NSString stringWithFormat:@"%@", [[FacultyManager sharedInstance] nameOfFacultyAtIndex:[self.user.department intValue]]];
    if ([self.user.userId isEqualToNumber:[CurrentUser sharedInstance].user.userId]) {
        self.cellDescriptions = [[NSArray alloc] initWithObjects:self.user.firstName, self.user.lastName, self.user.email, phoneNumber, car, @"●●●●●●", department, nil];
        self.cellImages = self.ownerCellImages;
        UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cameraButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-40, 10, 33, 25);
        [cameraButton setImage:[UIImage imageNamed:@"CameraIcon"] forState:UIControlStateNormal];
        [cameraButton addTarget:self action:@selector(headerViewTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cameraButton];
        
    } else {
        self.cellDescriptions = [[NSArray alloc] initWithObjects:self.user.firstName, self.user.email, phoneNumber, car, department, nil];
        self.cellImages = self.otherCellImages;
    }
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else
        return [self.cellDescriptions count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        GeneralInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GeneralInfoCell"];
        
        if(cell == nil){
            cell = [GeneralInfoCell generalInfoCell];
        }
        
        NSInteger totalRidesAsDriver = [self ridesAsOwnerAndIsDriving:NO rides:[self.user.ridesAsOwner allObjects]] + [self ridesAsOwnerAndIsDriving:NO rides:[[RidesStore sharedStore] pastRides]];
        
        NSInteger totalRidesAsPassenger = [self ridesAsOwnerAndIsDriving:YES rides:[self.user.ridesAsOwner allObjects]] + [self ridesAsOwnerAndIsDriving:YES rides:[[RidesStore sharedStore] pastRides]] + [self.user.ridesAsPassenger count];
        
        cell.driverLabel.text = [NSString stringWithFormat:@"%d", (int)totalRidesAsDriver];
        cell.passengerLabel.text = [NSString stringWithFormat:@"%d", (int)totalRidesAsPassenger];
        if ([self.user.ratingAvg doubleValue] < 0) {
            cell.ratingLabel.text = @"-";
        } else {
            NSInteger rating = [self.user.ratingAvg doubleValue]*100;
            cell.ratingLabel.text = [NSString stringWithFormat:@"%d %%", (int)rating];
        }
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
        if (![[self.cellDescriptions objectAtIndex:indexPath.row] isEqualToString:self.user.email] && [self.user.userId isEqualToNumber:[CurrentUser sharedInstance].user.userId]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return cell;
    }
}

-(NSInteger)ridesAsOwnerAndIsDriving:(BOOL)isRideRequest rides:(NSArray *)rides {
    int rideCount = 0;
    for (Ride *ride in rides) {
        if ([ride.isRideRequest boolValue] == isRideRequest) {
            rideCount++;
        }
    }
    return rideCount;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.profileImageContentView.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (![self.user.userId isEqualToNumber:[CurrentUser sharedInstance].user.userId]) { // we can't edit other user
        return;
    }
    
    if (indexPath.section == 0 || [[self.cellDescriptions objectAtIndex:indexPath.row] isEqualToString:self.user.email]) {
        // do nothing
    } else if(indexPath.row == [self.cellDescriptions count]-1) {
        EditDepartmentViewController *editDepartmentVC = [[EditDepartmentViewController alloc] init];
        editDepartmentVC.title = @"Department";
        [self.navigationController pushViewController:editDepartmentVC animated:YES];
    } else {
        EditProfileFieldViewController *editProfileVC = [[EditProfileFieldViewController alloc] init];
        editProfileVC.title = [self.editDescriptions objectAtIndex:indexPath.row];
        editProfileVC.initialDescription = [self.cellDescriptions objectAtIndex:indexPath.row];
        editProfileVC.updatedFiled = (int)indexPath.row;
        [self.navigationController pushViewController:editProfileVC animated:YES];
    }
}

#pragma mark - Button handlers

- (void)back {
    if(self.returnEnum == ViewController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
}

-(void)headerViewTapped {
    if (![self.user.userId isEqualToNumber:[CurrentUser sharedInstance].user.userId]) {
        return;
    }
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
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = NO;
    } else {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    self.imagePickerController = picker;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)selectPhoto {
    if ([self.user.userId isEqualToNumber:[CurrentUser sharedInstance].user.userId]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    UIImage *resizedImage = [ActionManager imageWithImage:chosenImage scaledToSize:CGSizeMake(100, 135)];
    NSData *chosenImageData = UIImageJPEGRepresentation(chosenImage, 1.0);
    NSData *resizedImageData = UIImageJPEGRepresentation(resizedImage, 1.0);
    
    NSLog(@"size of original : %lu, size of cropped: %lu", (unsigned long)[chosenImageData length], (unsigned long)[resizedImageData length]);
    
    self.profileImageContentView.rideDetailHeaderView.circularImage = resizedImage;
    [self.profileImageContentView.rideDetailHeaderView replaceImage:resizedImage];
    self.user.profileImageData = UIImageJPEGRepresentation(resizedImage, 1.0f);
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    NSError *error;
    if (![self.user.managedObjectContext saveToPersistentStore:&error]) {
        NSLog(@"Whoops");
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    if ([self.user.userId isEqualToNumber:[CurrentUser sharedInstance].user.userId] && self.initialImageData.length != self.user.profileImageData.length) {
        [[AWSUploader sharedStore] uploadImageData:[CurrentUser sharedInstance].user.profileImageData user:self.user];
        self.initialImageData = self.user.profileImageData;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)dealloc {
    [AWSUploader sharedStore].delegate = nil;
}

@end

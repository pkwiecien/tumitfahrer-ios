//
//  MainRideDetailViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/14/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "MainRideDetailViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Ride.h"
#import "HeaderContentView.h"
#import "RidesStore.h"
#import "RidesPageViewController.h"
#import "ActionManager.h"
#import "RideDetailMapViewController.h"
#import "AppDelegate.h"
#import "CustomIOS7AlertView.h"
#import "Rating.h"
#import "PhotoDetailsViewController.h"
#import "AWSUploader.h"
#import "User.h"
#import "CurrentUser.h"

@interface MainRideDetailViewController () <RideStoreDelegate, HeaderContentViewDelegate, UIGestureRecognizerDelegate, UITextViewDelegate, CustomIOS7AlertViewDelegate, AWSUploaderDelegate>

@property (strong, nonatomic) NSDictionary *backLinkInfo;
@property (weak, nonatomic) UIView *backLinkView;
@property (weak, nonatomic) UILabel *backLinkLabel;

@end

@implementation MainRideDetailViewController {
    UITapGestureRecognizer *doubleTapGestureRecognizer;
    UIView *headerFlippedGradientView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.rideDetail = [[HeaderContentView alloc] initWithFrame:self.view.bounds];
    self.rideDetail.tableViewDataSource = self;
    self.rideDetail.tableViewDelegate = self;
    self.rideDetail.parallaxScrollFactor = 0.3; // little slower than normal.
    self.rideDetail.delegate = self;
    [self.view addSubview:self.rideDetail];
    
    [[RidesStore sharedStore] addObserver:self];
    
    headerFlippedGradientView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 320, 180)];
    UIImageView *gradientImageView = [[UIImageView alloc] initWithFrame:headerFlippedGradientView.frame];
    gradientImageView.image = [UIImage imageNamed:@"GradientWideFlipped"];
    [headerFlippedGradientView addSubview:gradientImageView];
    [self.view addSubview:headerFlippedGradientView];
    
    doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTappedTwice)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [headerFlippedGradientView addGestureRecognizer:doubleTapGestureRecognizer];
    
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame = CGRectMake(10, 25, 30, 30);
    [buttonBack setImage:[UIImage imageNamed:@"BackIcon"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
#ifdef DEBUG
    // set label for kif test
    [buttonBack setAccessibilityLabel:@"Back Button"];
    [buttonBack setIsAccessibilityElement:YES];
#endif
    [self.view addSubview:buttonBack];
    
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mapButton.frame = CGRectMake(260, 20, 44, 44);
    [mapButton setImage:[UIImage imageNamed:@"MapIcon"] forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(mapButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mapButton];
    
    editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(220, 25, 30, 30);
    [editButton setImage:[UIImage imageNamed:@"EditIcon"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editButton];
    
    self.rideDetail.shouldDisplayGradient = YES;
    self.view.backgroundColor = [UIColor customLightGray];
    
    [AWSUploader sharedStore].delegate = self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    if (self.ride.rideOwner == nil) {
        [[RidesStore sharedStore] fetchSingleRideFromWebserviceWithId:self.ride.rideId block:^(BOOL fetched) {
            [self.rideDetail.tableView reloadData];
        }];
    }
    
    if (self.ride.destinationImage == nil) {
        [RidesStore initRide:self.ride block:^(BOOL fetched) { }];
    } else {
        self.rideDetail.selectedImageData = self.ride.destinationImage;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.refererAppLink) {
        self.backLinkInfo = delegate.refererAppLink;
        [self _showBackLink];
    }
    delegate.refererAppLink = nil;
}

-(void)viewDidAppear:(BOOL)animated {
    if (self.displayEnum == ShouldShareRideOnFacebook) {
        [self shareLinkWithShareDialog];
        self.displayEnum = ShouldDisplayNormally;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *generalCell = [tableView dequeueReusableCellWithIdentifier:@"reusable"];
    if (!generalCell) {
        generalCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reusable"];
    }
    return generalCell;
}

- (void)back {
    if (self.shouldGoBackEnum == GoBackNormally) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if ([self.ride.rideType intValue] == ContentTypeCampusRides) {
            RidesPageViewController *campusRidesVC = [[RidesPageViewController alloc] initWithContentType:ContentTypeCampusRides];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:campusRidesVC];
            [self.sideBarController setCenterViewController:navController  withCloseAnimation:YES completion:nil];
        } else {
            RidesPageViewController *activityRidesVC = [[RidesPageViewController alloc] initWithContentType:ContentTypeActivityRides];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:activityRidesVC];
            [self.sideBarController setCenterViewController:navController withCloseAnimation:YES completion:nil];
        }
    }
}

-(void)refreshRideButtonPressed {
    [[RidesStore sharedStore] fetchSingleRideFromWebserviceWithId:self.ride.rideId block:^(BOOL fetched) {
        [self.rideDetail.tableView reloadData];
    }];
}

-(void)headerViewTappedTwice {
    PhotoDetailsViewController *photoDetailsVC = [[PhotoDetailsViewController alloc] init];
    photoDetailsVC.photoInfo = self.ride.photo;
    photoDetailsVC.photo = [UIImage imageWithData:self.ride.destinationImage];
    photoDetailsVC.title = @"Photo Details";
    [self.navigationController pushViewController:photoDetailsVC animated:YES];
}

-(void)didReceivePhotoForRide:(NSNumber *)rideId {
    UIImage *img = [UIImage imageWithData:self.ride.destinationImage];
    [self.rideDetail.rideDetailHeaderView replaceMainImage:img];
}


-(void)initFields {
    self.rideDetail.departureLabel.text = self.ride.departurePlace;
    self.rideDetail.destinationLabel.text = self.ride.destination;
    self.rideDetail.timeLabel.text = [ActionManager timeStringFromDate:self.ride.departureTime];
    self.rideDetail.calendarLabel.text = [ActionManager dateStringFromDate:self.ride.departureTime];
}

-(void)dealloc {
    [[RidesStore sharedStore] removeObserver:self];
    [headerFlippedGradientView removeGestureRecognizer:doubleTapGestureRecognizer];
}

-(void)editButtonTapped {
    
}

-(void)mapButtonTapped {
    RideDetailMapViewController *rideDetailMapVC = [[RideDetailMapViewController alloc] init];
    rideDetailMapVC.selectedRide = self.ride;
    [self.navigationController pushViewController:rideDetailMapVC animated:YES];
}

- (void)showCancelationAlertView {
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    [alertView setContainerView:[self prepareReasonView]];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel", @"Select", nil]];
    [alertView setDelegate:self];
    [alertView setUseMotionEffects:false];
    [alertView show];
}

-(UIView *)prepareReasonView {
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, mainView.frame.size.width, 20)];
    titleLabel.text = @"Cancel ride";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [mainView addSubview:titleLabel];
    UILabel *reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 290, 20)];
    reasonLabel.text = @"Please give a reason for canceletion";
    reasonLabel.textAlignment = NSTextAlignmentCenter;
    reasonLabel.textColor = [UIColor blackColor];
    reasonLabel.font = [UIFont systemFontOfSize:14];
    [mainView addSubview:reasonLabel];
    self.counterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, mainView.frame.size.width, 20)];
    self.counterLabel.text = @"0 / 50 characters (required)";
    self.counterLabel.textAlignment = NSTextAlignmentCenter;
    self.counterLabel.font = [UIFont systemFontOfSize:14];
    [mainView addSubview:self.counterLabel];
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 90, 270, 100)];
    self.textView.delegate = self;
    [mainView addSubview:self.textView];
    
    return mainView;
    
}

-(void)textViewDidChange:(UITextView *)textView {
    self.counterLabel.textColor = [UIColor blackColor];
    int len = textView.text.length;
    self.counterLabel.text=[NSString stringWithFormat:@"%i / 50 characters (required)", len];
}

-(void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}


-(BOOL)isPastRide {
    if ([[ActionManager localDateWithDate:self.ride.departureTime] compare:[ActionManager currentDate]] == NSOrderedAscending) {
        return YES;
    } else {
        return NO;
    }
}

-(Rating *)isRatingGivenForUserId:(NSNumber *)otherUserId {
    for (Rating *rating  in [self.ride.ratings allObjects]) {
        if ([rating.toUserId isEqualToNumber:otherUserId]) {
            return rating;
        }
    }
    return nil;
}


-(void)updateRide {
    [[RidesStore sharedStore] fetchSingleRideFromWebserviceWithId:self.ride.rideId block:^(BOOL fetched) {
        [self reloadTableAndRide];
    }];
}

-(void)reloadTableAndRide {
    self.ride = [[RidesStore sharedStore] fetchRideFromCoreDataWithId:self.ride.rideId];
    [self initFields];
    [self.rideDetail.tableView reloadData];
}

-(void)didDownloadImageData:(NSData *)imageData user:(User *)user{
    user.profileImageData = imageData;
    [CurrentUser saveUserToPersistentStore:user];
    [self reloadTableAndRide];
}


#pragma mark - Facebook sharing methods

//------------------Sharing a link using the share dialog------------------

- (void)shareLinkWithShareDialog
{
    
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        
        // Put together the dialog parameters
        NSString *caption = [NSString stringWithFormat:@"TUMitfahrer - carsharing platform for students"];
        NSString *departurePlaceName  = [self.ride.departurePlace componentsSeparatedByString: @","][0];
        NSString *destinationName  = [self.ride.destination componentsSeparatedByString: @","][0];
        
        NSString *description = [NSString stringWithFormat:@"I've just created a ride from %@ to %@, on %@. Join me!", departurePlaceName, destinationName, [ActionManager stringFromDate:self.ride.departureTime]];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"TUMitfaher", @"name",
                                       caption, @"caption",
                                       description, @"description",
                                       @"https://developers.facebook.com/docs/ios/share/", @"link",
                                       @"https://raw.githubusercontent.com/pkwiecien/tumitfahrer/develop/public/TUMitfahrer-logo-small.png", @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }
}

//------------------------------------

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

//------------------Handling links back to app link launching app------------------

- (void) _showBackLink {
    if (nil == self.backLinkView) {
        // Set up the view
        UIView *backLinkView = [[UIView alloc] initWithFrame:
                                CGRectMake(0, 30, 320, 40)];
        backLinkView.backgroundColor = [UIColor darkGrayColor];
        UILabel *backLinkLabel = [[UILabel alloc] initWithFrame:
                                  CGRectMake(2, 2, 316, 36)];
        backLinkLabel.textColor = [UIColor whiteColor];
        backLinkLabel.textAlignment = NSTextAlignmentCenter;
        backLinkLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        [backLinkView addSubview:backLinkLabel];
        self.backLinkLabel = backLinkLabel;
        [self.view addSubview:backLinkView];
        self.backLinkView = backLinkView;
    }
    // Show the view
    self.backLinkView.hidden = NO;
    // Set up the back link label display
    self.backLinkLabel.text = [NSString
                               stringWithFormat:@"Touch to return to %@", self.backLinkInfo[@"app_name"]];
    // Set up so the view can be clicked
    UITapGestureRecognizer *tapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(_returnToLaunchingApp:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.backLinkView addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
}

- (void)_returnToLaunchingApp:(id)sender {
    // Open the app corresponding to the back link
    NSURL *backLinkURL = [NSURL URLWithString:self.backLinkInfo[@"url"]];
    if ([[UIApplication sharedApplication] canOpenURL:backLinkURL]) {
        [[UIApplication sharedApplication] openURL:backLinkURL];
    }
    self.backLinkView.hidden = YES;
}



@end

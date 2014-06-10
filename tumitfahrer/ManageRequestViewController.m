//
//  ManageRequestViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/10/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "ManageRequestViewController.h"
#import "NavigationBarUtilities.h"
#import "RideActionCell.h"
#import "Ride.h"
#import "CurrentUser.h"

@interface ManageRequestViewController () <RideActionCellDelegate>

@end

@implementation ManageRequestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
}

-(void)setupNavigationBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor darkerBlue]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationController.navigationBar.translucent = NO;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0) {
        RideActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailsMessagesChoiceCell"];
        
        if(cell == nil){
            cell = [RideActionCell detailsMessagesChoiceCell];
        }
                [cell.joinRideButton setTitle:@"Delete request" forState:UIControlStateNormal];
                [cell.contactDriverButton setTitle:@"Edit request" forState:UIControlStateNormal];
        cell.delegate = self;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reusable"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reusable"];
        }
        
        cell.textLabel.text = @"Default cell";
        
        return cell;
    }
}

-(void)secondButtonPressed {
    
}
-(void)firstButtonPressed {
    
}



//        [objectManager deleteObject:self.ride path:[NSString stringWithFormat:@"/api/v2/rides/%@", self.ride.rideId] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//
//            [[CurrentUser sharedInstance].user removeRidesAsOwnerObject:self.ride];
//            [[RidesStore sharedStore] deleteRideFromCoreData:self.ride];
//
//            [self.navigationController popViewControllerAnimated:YES];
//        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//            RKLogError(@"Load failed with error: %@", error);
//        }];

@end

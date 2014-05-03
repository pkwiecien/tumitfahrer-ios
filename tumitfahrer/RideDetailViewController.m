//
//  RideDetailViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RideDetailViewController.h"
#import "RideDetailView.h"
#import "RideInformationCell.h"
#import "PassengersCell.h"
#import "DriverCell.h"
#import "ChatViewController.h"
#import "ActionManager.h"

@interface RideDetailViewController ()

@end

@implementation RideDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.rideDetail = [[RideDetailView alloc] initWithFrame:self.view.bounds];
    self.rideDetail.tableViewDataSource = self;
    self.rideDetail.tableViewDelegate = self;
    
    self.rideDetail.parallaxScrollFactor = 0.3; // little slower than normal.
    
    [self.view addSubview:self.rideDetail];
    
    [self.view bringSubviewToFront:_headerView];
    
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame = CGRectMake(10, 22, 44, 44);
    [buttonBack setImage:[UIImage imageNamed:@"ArrowLeft"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    
    self.rideDetail.headerView = _headerView;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 44.0f;
    }
    else if(indexPath.row == 1){
        return 159.0f;
    }
    else if(indexPath.row == 2){
        return 120.0f;
    }
    else if(indexPath.row == 3) {
        return 124.0f;
    } else if(indexPath.row == 4) {
        return 343.0f;
    }else
        return 100.0f; //cell for comments, in reality the height has to be adjustable
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
    if(indexPath.row == 0) {
        
        DetailsMessagesChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailsMessagesChoiceCell"];
        
        if(cell == nil){
            cell = [DetailsMessagesChoiceCell detailsMessagesChoiceCell];
        }
        
        cell.delegate = self;
        return cell;
    }
    else if(indexPath.row == 1) {
        RideInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RideInformationCell"];
        if(cell == nil){
            cell = [RideInformationCell rideInformationCell];
        }
        cell.departurePlaceLabel.text = self.ride.departurePlace;
        cell.destinationLabel.text = self.ride.destination;
        cell.timeLabel.text = [ActionManager stringFromDate:self.ride.departureTime];
        
        return cell;
    } else if(indexPath.row == 2) {
        DriverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DriverCell"];
        if (cell == nil) {
            cell = [DriverCell driverCell];
        }
        return cell;
    } else if(indexPath.row == 3) {
        PassengersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PassengersCell"];
        if (cell == nil) {
            cell = [PassengersCell passengersCell];
        }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.contentView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - LocationDetailViewDelegate

#pragma mark - MKMap View methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (annotation == mapView.userLocation)
        return nil;
    
    static NSString *MyPinAnnotationIdentifier = @"Pin";
    MKPinAnnotationView *pinView =
    (MKPinAnnotationView *) [self.map dequeueReusableAnnotationViewWithIdentifier:MyPinAnnotationIdentifier];
    if (!pinView){
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                        reuseIdentifier:MyPinAnnotationIdentifier];
        
        annotationView.image = [UIImage imageNamed:@"pin_map_blue"];
        
        return annotationView;
        
    }else{
        
        pinView.image = [UIImage imageNamed:@"pin_map_blue"];
        
        return pinView;
    }
    
    return nil;
}

#pragma mark - Button actions

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)contactDriverButtonPressed {
    ChatViewController *chatVC = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:chatVC animated:YES];
}

@end

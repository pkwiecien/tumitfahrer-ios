//
//  RideDetailViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RideDetailViewController.h"
#import "RideDetailView.h"

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
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.view bringSubviewToFront:_headerView];
    
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame = CGRectMake(10, 22, 44, 44);
    [buttonBack setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    
    UIButton *buttonPost = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonPost.frame = CGRectMake(self.view.bounds.size.width - 44, 18, 44, 44);
    [buttonPost setImage:[UIImage imageNamed:@"btn_post"] forState:UIControlStateNormal];
    [buttonPost addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonPost];
    
    self.rideDetail.headerView = _headerView;
    
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 138.0f;
    }
    else if(indexPath.row == 1){
        return 171.0f;
    }
    else if(indexPath.row == 2){
        return 138.0f;
    }
    else
        return 100.0f; //cell for comments, in reality the height has to be adjustable
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reusable"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reusable"];
    }
    
    cell.textLabel.text = @"Default cell";
    
    return cell;
    
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
}

- (void)post
{
}

@end

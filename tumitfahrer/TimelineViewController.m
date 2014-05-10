//
//  TimelineViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/10/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "TimelineViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "TimelineCell.h"
#import "LogoView.h"

@interface TimelineViewController ()

@end

@implementation TimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupLeftMenuButton];
    [self setupNavigationBar];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.contentInset = inset;
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupNavigationBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    UIColor * barColor = [UIColor colorWithRed:0 green:0.384 blue:0.58 alpha:1];
    [self.navigationController.navigationBar setBarTintColor:barColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    LogoView *logo = [[LogoView alloc] initWithFrame:CGRectMake(0, 0, 200, 41) titile:@"Timeline"];
    [self.navigationItem setTitleView:logo];
    
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimelineCell"];
    
    if(cell == nil){
        cell = [TimelineCell timelineCell];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end

//
//  CampusRidesViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/1/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "SettingsViewController.h"
#import "ActionManager.h"
#import "LoginViewController.h"
#import "NavigationBarUtilities.h"

@interface SettingsViewController ()

@property (nonatomic, strong) NSArray *tableOptions;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tableOptions = [[NSArray alloc] initWithObjects:@"Reminder", @"Help", @"Contribution", @"Report a problem", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeButtons];
    self.tableView = [self makeTableView];
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setupView];
}

-(void)setupView {
    self.view = [NavigationBarUtilities makeBackground:self.view];
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController];
    self.title = @"SETTINGS";
}

-(void)makeButtons
{
    UIImage *orangeButtonImage = [ActionManager colorImage:[UIImage imageNamed:@"blueButton"] withColor:[UIColor orangeColor]];
    [self.sendFeedbackButton setBackgroundImage:orangeButtonImage forState:UIControlStateNormal];
    
    UIImage *grayButtonImage = [ActionManager colorImage:[UIImage imageNamed:@"blueButton"] withColor:[UIColor grayColor]];
    [self.logoutButton setBackgroundImage:grayButtonImage forState:UIControlStateNormal];
}

-(UITableView*)makeTableView
{
    CGFloat x = 0;
    CGFloat y = 150;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = TableSingleRowHeight*([self.tableOptions count]+1)+TableFooterHeight+TableHeaderHeight;
    CGRect tableFrame = CGRectMake(x, y, width, height);
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    
    tableView.rowHeight = TableSingleRowHeight;
    tableView.sectionFooterHeight = TableFooterHeight;
    tableView.sectionHeaderHeight = TableHeaderHeight;
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;
    tableView.bounces = NO;
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    return tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableOptions count];;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"SettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.tableOptions objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:70 green:30 blue:180 alpha:0.3];
    bgColorView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    UILabel *label= [[UILabel alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,40)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"TUMitfahrer";
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]];//font size and style
    [label setTextColor:[UIColor whiteColor]];
    
    CGRect resultFrame = CGRectMake(0.0f,
                                    0.0f,
                                    label.frame.size.width,
                                    label.frame.size.height);
    UIView *result = [[UIView alloc] initWithFrame:resultFrame];
    [result addSubview:label];
    
    return result;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"GENERAL";
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}


- (IBAction)sendFeedbackButtonPressed:(id)sender {
}
- (IBAction)logoutButtonPressed:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"emailLoggedInUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:loginVC animated:YES completion:nil];
}

@end

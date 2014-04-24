//
//  AddRideViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "AddRideViewController.h"
#import "CustomBarButton.h"
#import "ActionManager.h"
#import "CurrentUser.h"
#import "Ride.h"
#import "ActionManager.h"
#import "LocationController.h"
#import "SwitchTableViewCell.h"
#import "FreeSeatsTableViewCell.h"

@interface AddRideViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic) UIColor *customGrayColor;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSArray *tablePlaceholders;
@property (nonatomic, strong) NSMutableArray *tableValues;
@property (nonatomic, strong) NSMutableArray *shareValues;
@property (nonatomic, strong) NSMutableArray *passengerValues;

@end

@implementation AddRideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tablePlaceholders = [[NSArray alloc] initWithObjects:@"Departure", @"Destination", @"Free Seats", @"Meeting Point", nil];
        self.tableValues = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", nil];
        self.shareValues = [[NSMutableArray alloc] initWithObjects:@"Facebook", @"Email", nil];
        self.passengerValues = [[NSMutableArray alloc] initWithObjects:@"Add a passenger", nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customGrayColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    [self.view setBackgroundColor:self.customGrayColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setupNavbar];
    [self makeBackground];
    self.tableView = [self makeTableView];
    [self.view addSubview:self.tableView];
    [self.tableValues replaceObjectAtIndex:0 withObject:[LocationController sharedInstance].currentAddress];
}

-(void)makeBackground
{
    UIImageView *imgBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gradientBackground"]];
    imgBackgroundView.frame = self.view.bounds;
    [self.view addSubview:imgBackgroundView];
    [self.view sendSubviewToBack:imgBackgroundView];
}

-(UITableView*)makeTableView {
    CGFloat x = 0;
    CGFloat y = 90;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = TableSingleRowHeight*([self.tablePlaceholders count])+TableSingleRowHeight*([self.shareValues count])+TableSingleRowHeight*[self.passengerValues count] +TableHeaderHeight*2;
    CGRect tableFrame = CGRectMake(x, y, width, height);
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    
    tableView.rowHeight = TableSingleRowHeight;
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

-(void)viewWillAppear:(BOOL)animated {
}

//-(void)setupNavbar
//{
//    UIColor *navBarColor = [UIColor colorWithRed:0 green:0.361 blue:0.588 alpha:1]; /*#0e3750*/
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setBarTintColor:navBarColor];
//    [self.navigationController.navigationBar setBackgroundImage:[[ActionManager sharedManager] imageWithColor:navBarColor] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBarHidden = NO;
//    self.navigationController.navigationBar.translucent = NO;
//
//
//    // right button of the navigation bar
//    CustomBarButton *searchButton = [[CustomBarButton alloc] initWithTitle:@"Add"];
//    [searchButton addTarget:self action:@selector(addRideButtonPressed) forControlEvents:UIControlEventTouchDown];
//    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
//    self.navigationItem.rightBarButtonItem = searchButtonItem;
//
//    // title of the navigation bar
//    self.title = @"Add a Ride";
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
//}

-(void)setupNavbar {
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    // left button of the navigation bar
    
    UIButton *settingsView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [settingsView addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [settingsView setBackgroundImage:[[ActionManager sharedManager] colorImage:[UIImage imageNamed:@"DeleteIcon2"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:settingsView];
    [self.navigationItem setLeftBarButtonItem:settingsButton];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"ADD RIDE";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.tablePlaceholders count];
    } else if (section == 1){
        return [self.shareValues count];
    } else {
        return [self.passengerValues count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"SettingsCell";
    NSString *SwitchIdentifier = @"SwitchCell";
    NSString *FreeSeatsIdentifier = @"FreeSeatsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    SwitchTableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:SwitchIdentifier];
    FreeSeatsTableViewCell *freeSeatsCell = [tableView dequeueReusableCellWithIdentifier:FreeSeatsIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    if (switchCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SwitchTableViewCell" owner:self options:nil];
        switchCell = [nib objectAtIndex:0];
    }
    if(freeSeatsCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FreeSeatsTableViewCell" owner:self options:nil];
        freeSeatsCell = [nib objectAtIndex:0];
    }
    
    if (indexPath.section == 0) {
        cell.detailTextLabel.text = [self.tableValues objectAtIndex:indexPath.row];
        cell.textLabel.text = [self.tablePlaceholders objectAtIndex:indexPath.row];
        if (indexPath.row ==2) {
            freeSeatsCell.stepperLabelText = [self.tablePlaceholders objectAtIndex:indexPath.row];
        }
    } else if(indexPath.section == 1) {
        switchCell.switchCellTextLabel.text = [self.shareValues objectAtIndex:indexPath.row];
    } else if(indexPath.section == 2) {
        cell.textLabel.text = [self.passengerValues objectAtIndex:indexPath.row];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    switchCell.switchCellTextLabel.textColor = [UIColor whiteColor];
    switchCell.backgroundColor = [UIColor clearColor];
    switchCell.contentView.backgroundColor = [UIColor clearColor];
    
    freeSeatsCell.backgroundColor = [UIColor clearColor];
    freeSeatsCell.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:70 green:30 blue:180 alpha:0.3];
    bgColorView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:bgColorView];
    
    switchCell.selectionStyle = UITableViewCellSelectionStyleNone;
    freeSeatsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section == 1)
        return switchCell;
    if (indexPath.section == 0 && indexPath.row ==2) {
       return freeSeatsCell;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Details";
    } else if (section ==1)
    {
        return @"Share a ride";
    } else if(section == 2) {
        return @"Passengers";
    }
    return @"Default";
}

-(void)addRideButtonPressed {
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSDictionary *queryParams;
    // add enum
    queryParams = @{@"departure_place": @"Gdynia", @"destination": @"Sopot", @"departure_time": @"2012-02-03 12:20", @"free_seats": @"3", @"meeting_point": @"Parking lot"};
    NSDictionary *rideParams = @{@"ride": queryParams};
    
    [[[RKObjectManager sharedManager] HTTPClient] setDefaultHeader:@"apiKey" value:[[CurrentUser sharedInstance] user].apiKey];
    NSLog(@"Setting api key: %@", [[CurrentUser sharedInstance] user].apiKey);
    
    [objectManager postObject:nil path:@"/api/v2/rides" parameters:rideParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        Ride *ride = (Ride *)[mappingResult firstObject];
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
        NSLog(@"This is ride: %@", ride);
        NSLog(@"This is driver: %@", ride.driver);
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [[ActionManager sharedManager] showAlertViewWithTitle:[error localizedDescription]];
        RKLogError(@"Load failed with error: %@", error);
    }];
    
}

-(void)closeButtonPressed {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(NSFetchedResultsController *)fetchedResultsController {
    
    if (self.fetchedResultsController != nil) {
        return self.fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Ride"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    fetchRequest.sortDescriptors = @[descriptor];
    NSError *error = nil;
    
    // Setup fetched results
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fetchRequest
                                     managedObjectContext:[RKManagedObjectStore defaultStore].
                                     mainQueueManagedObjectContext
                                     sectionNameKeyPath:nil cacheName:@"Ride"];
    self.fetchedResultsController.delegate = self;
    
    if (![self.fetchedResultsController performFetch:&error]) {
        [[ActionManager sharedManager] showAlertViewWithTitle:[error localizedDescription]];
    }
    
    return self.fetchedResultsController;
    
}

@end

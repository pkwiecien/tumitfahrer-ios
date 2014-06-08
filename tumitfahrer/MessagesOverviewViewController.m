//
//  MessagesOverviewViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "MessagesOverviewViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "NavigationBarUtilities.h"
#import "ChatViewController.h"
#import "MessageListCell.h"
#import "WebserviceRequest.h"
#import "Conversation.h"
#import "CurrentUser.h"
#import "User.h"
#import "Message.h"
#import "ActionManager.h"

@interface MessagesOverviewViewController ()

@property (nonatomic, strong) NSMutableArray *conversations;

@end

@implementation MessagesOverviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.tableView.delegate = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [WebserviceRequest getMessagesforRideId:[self.ride.rideId intValue] block:^(BOOL fetched) {
        if (fetched) {
            [self reloadTable];
        }
    }];
    
    [self setupNavigationBar];
}

-(void)reloadTable {
    self.conversations = [NSMutableArray arrayWithArray:[self.ride.conversations allObjects]];
    [self.tableView reloadData];
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupNavigationBar {
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor darkerBlue]];
    self.title = @"Messages Overview";
}

#pragma mark - Button Handlers

-(void)leftDrawerButtonPress:(id)sender{
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.conversations count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageListCell"];
    
    if(cell == nil)
    {
        cell = [MessageListCell messageListCell];
    }
    Conversation *conversation = [self.conversations objectAtIndex:indexPath.section];
    NSNumber *otherUserId = nil;
    if ([conversation.userId isEqualToNumber:[CurrentUser sharedInstance].user.userId]) {
        otherUserId = conversation.otherUserId;
    } else {
        otherUserId = conversation.userId;
    }
    User *otherUser = [CurrentUser getuserWithId:otherUserId];
    cell.passengerNameLabel.text = [NSString stringWithFormat:@"%@ %@", otherUser.firstName, otherUser.lastName] ;
    
    Message *lastMesage = [conversation.messages lastObject];
    cell.lastMessageLabel.text = lastMesage.content;
    cell.lastMessageDateLabel.text = [ActionManager dateStringFromDate:lastMesage.createdAt];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatViewController *chatVC = [[ChatViewController alloc] init];
    Conversation *conversation = [self.conversations objectAtIndex:indexPath.row];
    chatVC.conversation = conversation;
    [self.navigationController pushViewController:chatVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

@end

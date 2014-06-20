//
//  ChatControllerViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/3/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "SimpleChatViewController.h"
#import "JSMessage.h"
#import "ActionManager.h"
#import "Message.h"
#import "User.h"
#import "CurrentUser.h"
#import "WebserviceRequest.h"
#import "Ride.h"
#import "ConversationUtilities.h"

@interface SimpleChatViewController ()

@property (nonatomic, strong) NSNumber *receiverId;
@property (nonatomic, strong) NSMutableArray *conversationArray;

@end

@implementation SimpleChatViewController

- (void)viewDidLoad {
    self.delegate = self;
    self.dataSource = self;
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    [[JSBubbleView appearance] setFont:[UIFont systemFontOfSize:16.0f]];
    
    self.title = @"Messages";
    self.messageInputView.textView.placeHolder = @"New Message";
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [super viewWillAppear:animated];
    [self setupNavbar];
    if (self.conversation != nil && [self.conversation.userId isEqualToNumber:[CurrentUser sharedInstance].user.userId]) {
        self.receiverId = self.conversation.otherUserId;
    } else if(self.conversation != nil) {
        self.receiverId = self.conversation.userId;
    }
    [self refreshButtonPressed];
    
    // scroll to bottom before the view appears
    [self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
}

-(void)setupNavbar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor darkerBlue]];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    
    if (self.conversation == nil) {
        self.title = @"Message to all";
    } else {
        self.title = [NSString stringWithFormat:@"Chat with %@", self.otherUser.firstName];
    }
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    UIBarButtonItem *refreshButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed)];
    [self.navigationItem setRightBarButtonItem:refreshButtonItem];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.conversationArray count];
}

#pragma mark - Messages view delegate: REQUIRED

- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    
    [JSMessageSoundEffect playMessageSentSound];
    
    [WebserviceRequest postMessageForConversation:self.conversation message:text senderId:[CurrentUser sharedInstance].user.userId receiverId:self.receiverId rideId:self.conversation.ride.rideId block:^(Message *result) {
        if (result!=nil) {
            [self inserObject:result];
        }
        [self finishSend];
        [self scrollToBottomAnimated:YES];
    }];
}

-(void)inserObject:(Message *)message {
    message.conversation = self.conversation;
    [self.conversation addMessagesObject:message];
    [self.conversationArray addObject:message];
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = [self.conversationArray objectAtIndex:indexPath.row];
    if ([message.senderId isEqualToNumber:[CurrentUser sharedInstance].user.userId]) {
        return JSBubbleMessageTypeOutgoing;
    }
    return JSBubbleMessageTypeIncoming;
}

- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type
                       forRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = [self.conversationArray objectAtIndex:indexPath.row];
    if ([message.senderId isEqualToNumber:[CurrentUser sharedInstance].user.userId]) {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                          color:[UIColor js_bubbleBlueColor]];
    }
    return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                      color:[UIColor js_bubbleLightGrayColor]];
}

- (JSMessageInputViewStyle)inputViewStyle {
    return JSMessageInputViewStyleFlat;
}

#pragma mark - Messages view delegate: OPTIONAL

- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 3 == 0) {
        return YES;
    }
    return NO;
}

//
//  *** Implement to customize cell further
//
- (void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell messageType] == JSBubbleMessageTypeOutgoing) {
        cell.bubbleView.textView.textColor = [UIColor whiteColor];
        
        if ([cell.bubbleView.textView respondsToSelector:@selector(linkTextAttributes)]) {
            NSMutableDictionary *attrs = [cell.bubbleView.textView.linkTextAttributes mutableCopy];
            [attrs setValue:[UIColor blueColor] forKey:NSForegroundColorAttributeName];
            
            cell.bubbleView.textView.linkTextAttributes = attrs;
        }
    }
    
    if (cell.timestampLabel) {
        cell.timestampLabel.textColor = [UIColor lightGrayColor];
        cell.timestampLabel.shadowOffset = CGSizeZero;
    }
    
    if (cell.subtitleLabel) {
        cell.subtitleLabel.textColor = [UIColor lightGrayColor];
    }
    
#if TARGET_IPHONE_SIMULATOR
    cell.bubbleView.textView.dataDetectorTypes = UIDataDetectorTypeNone;
#else
    cell.bubbleView.textView.dataDetectorTypes = UIDataDetectorTypeAll;
#endif
}

//  *** Implement to use a custom send button
//
//  The button's frame is set automatically for you
//
//  - (UIButton *)sendButtonForInputView
//

//  *** Implement to prevent auto-scrolling when message is added
//
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling {
    return YES;
}

// *** Implemnt to enable/disable pan/tap todismiss keyboard
//
- (BOOL)allowsPanToDismissKeyboard {
    return YES;
}

#pragma mark - Messages view data source: REQUIRED

- (JSMessage *)messageForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = [self.conversationArray objectAtIndex:indexPath.row];
    JSMessage *jsMessage = nil;
    if ([message.senderId isEqualToNumber:[CurrentUser sharedInstance].user.userId]) {
        jsMessage = [[JSMessage alloc] initWithText:message.content sender:[CurrentUser sharedInstance].user.firstName date:message.createdAt];
    } else {
        jsMessage = [[JSMessage alloc] initWithText:message.content sender:self.otherUser.firstName date:message.createdAt];
    }
    
    return jsMessage;
}

- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath sender:(NSString *)sender
{
//    UIImage *image = [self.avatars objectForKey:sender];
    return [UIImageView new];
}

-(void)refreshButtonPressed {
    [WebserviceRequest getConversationForRideId:self.conversation.ride.rideId conversationId:self.conversation.conversationId block:^(BOOL fetched) {
        if (fetched) {
            [self reloadTableWithConversationId:self.conversation.conversationId];
        }
    }];
}

-(void)reloadTableWithConversationId:(NSNumber *)conversationId {
    self.conversation = [ConversationUtilities fetchConversationFromCoreDataWithId:conversationId];
    NSArray *sortedArray = [[self.conversation.messages allObjects] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [a createdAt];
        NSDate *second = [b createdAt];
        return [first compare:second] == NSOrderedDescending;
    }];
    
    self.conversationArray = [NSMutableArray arrayWithArray:sortedArray];
    [self.tableView reloadData];
}

-(void)dealloc {
    self.delegate = nil;
}

@end

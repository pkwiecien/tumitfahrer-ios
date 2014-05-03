//
//  ChatControllerViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/3/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "ChatViewController.h"
#import "JSMessage.h"

#define kSubtitleJobs @"Jobs"
#define kSubtitleWoz @"Steve Wozniak"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad
{
    self.delegate = self;
    self.dataSource = self;
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    [[JSBubbleView appearance] setFont:[UIFont systemFontOfSize:16.0f]];
    
    self.title = @"Messages";
    self.messageInputView.textView.placeHolder = @"New Message";
    self.sender = @"Jobs";
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.messages = [[NSMutableArray alloc] init];
    
    self.avatars = [[NSDictionary alloc] initWithObjectsAndKeys:
                    [JSAvatarImageFactory avatarImageNamed:@"futureAvatar1" croppedToCircle:YES], kSubtitleJobs,
                    [JSAvatarImageFactory avatarImageNamed:@"futureAvatar2" croppedToCircle:YES], kSubtitleWoz,nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self scrollToBottomAnimated:NO];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

#pragma mark - Messages view delegate: REQUIRED

- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date
{
    if ((self.messages.count - 1) % 2) {
        [JSMessageSoundEffect playMessageSentSound];
    }
    else {
        // for demo purposes only, mimicing received messages
        [JSMessageSoundEffect playMessageReceivedSound];
        sender = kSubtitleWoz;
    }
    
    [self.messages addObject:[[JSMessage alloc] initWithText:text sender:sender date:date]];
    
    [self finishSend];
    [self scrollToBottomAnimated:YES];
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row % 2) ? JSBubbleMessageTypeIncoming : JSBubbleMessageTypeOutgoing;
}

- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type
                       forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2) {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                          color:[UIColor js_bubbleLightGrayColor]];
    }
    
    return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                      color:[UIColor js_bubbleBlueColor]];
}

- (JSMessageInputViewStyle)inputViewStyle
{
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
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
    return YES;
}

// *** Implemnt to enable/disable pan/tap todismiss keyboard
//
- (BOOL)allowsPanToDismissKeyboard
{
    return YES;
}

#pragma mark - Messages view data source: REQUIRED

- (JSMessage *)messageForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.row];
}

- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath sender:(NSString *)sender
{
    UIImage *image = [self.avatars objectForKey:sender];
    return [[UIImageView alloc] initWithImage:image];
}


@end

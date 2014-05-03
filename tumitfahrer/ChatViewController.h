//
//  ChatControllerViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/3/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "JSMessagesViewController.h"

@interface ChatViewController : JSMessagesViewController <JSMessagesViewDataSource, JSMessagesViewDelegate>

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSDictionary *avatars;

@end

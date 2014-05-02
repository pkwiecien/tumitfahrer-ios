//
//  ChatCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatInput.h"

@interface ChatCell : UITableViewCell <ChatInputDelegate>

+ (ChatCell*)chatCell;

-(void)addChatInput;

@end

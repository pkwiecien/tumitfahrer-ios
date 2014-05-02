//
//  ChatInput.h
//  ChatInput
//
//  Created by Logan Wright on 2/6/14.
//  Copyright (c) 2014 Logan Wright. All rights reserved.
//


/*
 Mozilla Public License
 Version 2.0
 */


#import <UIKit/UIKit.h>

@protocol ChatInputDelegate

/*!
 The user has sent a message
 */
@required - (void) chatInputNewMessageSent:(NSString *)messageString;

@end

@interface ChatInput : UIView <UITextViewDelegate>

// -- DELEGATE -- //

/*!
 Delegate
 */
@property (retain, nonatomic) id<ChatInputDelegate>delegate;

// -- CUSTOMIZATION PROPERTIES -- //

/*!
 Set text property to show placeholder
 */
@property (strong, nonatomic) UILabel * placeholderLabel;
/*!
 The color of the send btn - Active State
 */
@property (strong, nonatomic) UIColor * sendBtnActiveColor;
/*!
 The color of the send btn - Inactive State
 */
@property (strong, nonatomic) UIColor * sendBtnInactiveColor;

// -- BEHAVIOR CUSTOMIZATION -- //

/*!
 Set to YES to prevent auto close behavior
 */
@property BOOL stopAutoClose;
/*!
 The maximum point on the Y axis that simpleInput can extend to - default: 60
 */
@property (strong, nonatomic) NSNumber * maxY;
/*!
 Maximum character count allowed
 */
@property (strong, nonatomic) NSNumber * maxCharacters;

// -- CLOSING | OPENING -- //

/*!
 Closes keyboard and resigns first responder
 */
- (void) close;
/*!
 Opens keyboard and makes simple input first responder.
 */
- (void) open;

/*!
 Autocorrect throws keyboard notifications.  This is used to ignore them.
 */
@property BOOL shouldIgnoreKeyboardNotifications;

@end

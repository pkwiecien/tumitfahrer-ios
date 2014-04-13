//
//  CustomTextField.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 3/29/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomTextField : UITextField<UITextFieldDelegate, UIGestureRecognizerDelegate>

- (instancetype)initWithFrame:(CGRect)frame placeholderText:(NSString*)placeholderText customIcon:(UIImage *)customIcon returnKeyType:(UIReturnKeyType)returnKeyType keyboardType:(UIKeyboardType)keyboardType shouldStartWithCapital:(BOOL)shouldStartWithCapital;

- (instancetype)initWithFrame:(CGRect)frame placeholderText:(NSString*)placeholderText customIcon:(UIImage *)customIcon returnKeyType:(UIReturnKeyType)returnKeyType keyboardType:(UIKeyboardType)keyboardType secureInput:(BOOL)secureInput;

-(instancetype)initNotEditableButton:(CGRect)frame placeholderText:(NSString *)placeholderText customIcon:(UIImage *)customIcon;

@end

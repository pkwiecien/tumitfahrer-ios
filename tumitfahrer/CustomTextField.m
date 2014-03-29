//
//  CustomTextField.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 3/29/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (instancetype)initWithFrame:(CGRect)frame placeholderText:(NSString*)placeholderText customIconName:(NSString *)customIconName returnKeyType:(UIReturnKeyType)returnKeyType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.background = [UIImage imageNamed:@"inputTextBox"];
        self.font = [UIFont systemFontOfSize:15];
        self.textColor = [UIColor whiteColor];
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.keyboardType = UIKeyboardTypeDefault;
        self.returnKeyType = returnKeyType;
//        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        UIImageView *clearButtonVIew = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        clearButtonVIew.image = [UIImage imageNamed:@"customIcon"];
        self.rightView = clearButtonVIew;
        self.rightViewMode = UITextFieldViewModeWhileEditing;
        
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        imageView.image = [UIImage imageNamed:customIconName];
        
        /*UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 60, 25)];
         [lbl setText:@"Partenza:"];
         [lbl setFont:[UIFont fontWithName:@"Verdana" size:12]];
         [lblselfsetTextColor:[UIColor grayColor]];*/
        self.leftView = imageView;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.delegate = self;
    }
    return self;
}


// padding of the input text and placeholder
-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 30, 0);
}

// padding of the input text while editing
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 30, 0);
}

// padding of the icon in input box
-(CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect textRect = [super leftViewRectForBounds:bounds];
    textRect.origin.x += 10;
    return textRect;
}

-(CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect textRect = [super rightViewRectForBounds:bounds];
    textRect.origin.x -= 10;
    return textRect;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

@end

//
//  CustomTextField.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 3/29/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "CustomTextField.h"
#import "ActionManager.h"

#define kLeftPadding 30

@interface CustomTextField ()

@property (nonatomic, strong) NSString *placeholderText;
@property (nonatomic) BOOL isEditable;

@end

@implementation CustomTextField

#pragma mark - button initializer

- (instancetype)initWithFrame:(CGRect)frame placeholderText:(NSString*)placeholderText customIcon:(UIImage *)customIcon returnKeyType:(UIReturnKeyType)returnKeyType keyboardType:(UIKeyboardType)keyboardType shouldStartWithCapital:(BOOL)shouldStartWithCapital {
    self = [super initWithFrame:frame];
    if (self) {
        self.background = [UIImage imageNamed:@"InputTextBox"];
        self.font = [UIFont systemFontOfSize:15];
        self.textColor = [UIColor whiteColor];
        self.isEditable = true;
        
        self.placeholderText = placeholderText;
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholderText attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.keyboardType = UIKeyboardTypeDefault;
        self.returnKeyType = returnKeyType;
        if (shouldStartWithCapital) {
            self.autocapitalizationType = UITextAutocapitalizationTypeWords;
        } else {
            self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        }
        self.keyboardType = keyboardType;
        
        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [clearButton setImage:[UIImage imageNamed:@"DeleteIcon"] forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(resetBox) forControlEvents:UIControlEventTouchUpInside];
        self.rightViewMode = UITextFieldViewModeWhileEditing;
        self.rightView = clearButton;
        
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        imageView.image = customIcon;
    
        self.leftView = imageView;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.delegate = self;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame placeholderText:(NSString *)placeholderText customIcon:(UIImage *)customIcon returnKeyType:(UIReturnKeyType)returnKeyType keyboardType:(UIKeyboardType)keyboardType secureInput:(BOOL)secureInput {
    self = [self initWithFrame:frame placeholderText:placeholderText customIcon:customIcon returnKeyType:returnKeyType keyboardType:keyboardType shouldStartWithCapital:NO];
    
    self.secureTextEntry = secureInput;
    
    return self;
}

-(instancetype)initNotEditableButton:(CGRect)frame placeholderText:(NSString *)placeholderText customIcon:(UIImage *)customIcon {
    self = [self initWithFrame:frame placeholderText:placeholderText customIcon:customIcon returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeAlphabet shouldStartWithCapital:NO];
    self.isEditable = false;
    return self;
}

#pragma mark - button delegate methods

-(BOOL)canBecomeFirstResponder {
    if(self.isEditable)
        return YES;
    return NO;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    // by default switch off following actions in the input field
    if (action == @selector(paste:) || action == @selector(cut:) || action ==  @selector(select:) || action ==  @selector(selectAll:))
        return NO;
    return [super canPerformAction:action withSender:sender];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

-(void)resetBox {
    self.text = @"";
}

// padding of the input text and placeholder
-(CGRect)textRectForBounds:(CGRect)bounds {
    
    CGFloat x = bounds.origin.x + kLeftPadding;
    CGFloat y = bounds.origin.y;
    return CGRectMake(x,y,bounds.size.width-2*kLeftPadding, bounds.size.height);
}

// padding of the input text while editing
-(CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

// padding of the icon in input box
-(CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect textRect = [super leftViewRectForBounds:bounds];
    textRect.origin.x += 10;
    return textRect;
}

-(CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGRect textRect = [super rightViewRectForBounds:bounds];
    textRect.origin.x -= 10;
    return textRect;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if([self.text length]==0)
        self.placeholder =  @"";
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if([self.text length] == 0)
    {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholderText attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignFirstResponder];
    return YES;
}

-(void)dealloc {
    self.delegate = nil;
}

@end

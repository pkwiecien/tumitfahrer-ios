//
//  HeaderView.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CircularImageView;

@interface HeaderImageView : UIView

@property (nonatomic, strong) NSData *selectedImageData;
@property (nonatomic, strong) UIImage *circularImage;
@property (nonatomic, strong) CircularImageView *circularImageView;
@property (nonatomic, strong) UIButton *myButton;

-(void)replaceImage:(UIImage *)image;
-(void)replaceMainImage:(UIImage *)image;

@end

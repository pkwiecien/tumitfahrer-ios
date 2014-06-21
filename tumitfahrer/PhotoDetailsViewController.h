//
//  PhotoDetailsViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/21/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;

@interface PhotoDetailsViewController : UIViewController

@property (nonatomic, strong) Photo *photoInfo;
@property (nonatomic, strong) UIImage *photo;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *linkButton;
- (IBAction)linkButtonPressed:(id)sender;


@end

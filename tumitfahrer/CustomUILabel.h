//
//  CustomUILabel.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/6/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomUILabel : UILabel

- (instancetype)initInMiddle:(CGRect)frame text:(NSString *)text viewWithNavigationBar:(UINavigationBar *)navigationBar;

@end

//
//  UnimplementedActionManager.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/5/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionManager : NSObject

+(instancetype)sharedManager;
-(void)showAlertViewWithTitle:(NSString *)title;
- (UIImage *)colorImage:(UIImage *)origImage withColor:(UIColor *)color;

@end

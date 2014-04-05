//
//  UnimplementedActionManager.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/5/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnimplementedActionManager : NSObject

+(instancetype)sharedManager;
-(void)showAlertView:(NSString*)message title:(NSString*)title;

@end

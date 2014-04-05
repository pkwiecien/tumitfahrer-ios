//
//  UnimplementedActionManager.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/5/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "UnimplementedActionManager.h"

@implementation UnimplementedActionManager

-(instancetype)init
{
    self = [super init];
    return  self;
}

+(instancetype)sharedManager
{
    static UnimplementedActionManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return  sharedManager;
}

-(void)showAlertView:(NSString *)message title:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


@end

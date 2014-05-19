//
//  MeetingPointViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/25/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MeetingPointDelegate

-(void)didSelectValue:(NSString *)value forIndexPath:(NSIndexPath *)indexPath;

@end

@interface MeetingPointViewController : UIViewController

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, assign) id<MeetingPointDelegate> selectedValueDelegate;

@end

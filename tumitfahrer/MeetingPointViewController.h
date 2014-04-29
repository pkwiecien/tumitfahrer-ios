//
//  MeetingPointViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/25/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MeetingPointDelegate

-(void)selectedMeetingPoint:(NSString *)value;

@end

@interface MeetingPointViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, assign) id<MeetingPointDelegate> selectedValueDelegate;

@end

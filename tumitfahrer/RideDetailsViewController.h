//
//  RideViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/1/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Ride;

@interface RideDetailsViewController : UIViewController

@property (nonatomic, strong) Ride *selectedRide;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

- (IBAction)arrowLeftPressed:(id)sender;
- (IBAction)joinButtonPressed:(id)sender;
- (IBAction)contactDriverButtonPressed:(id)sender;

@end

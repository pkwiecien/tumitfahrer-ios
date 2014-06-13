//
//  RequestorCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/13/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Request.h"

@protocol RequestorCellDelegate <NSObject>

-(void)moveRequestorToPassengersFromIndexPath:(NSIndexPath *)indexPath requestor:(User *)requestor;
-(void)removeRideRequest:(NSIndexPath *)indexPath requestor:(User *)requestor;

@end

@interface RequestorCell : UITableViewCell

+(RequestorCell *)requestorCell;

@property (nonatomic, strong) id<RequestorCellDelegate> delegate;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Request *request;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSNumber *rideId;

@property (weak, nonatomic) IBOutlet UILabel *requestorName;
@property (weak, nonatomic) IBOutlet UIImageView *requestorImage;

- (IBAction)acceptRequestorButtonPressed:(id)sender;
- (IBAction)declineRequestorButtonPressed:(id)sender;

@end

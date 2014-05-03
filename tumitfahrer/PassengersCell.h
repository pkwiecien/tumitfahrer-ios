//
//  PassengersCell.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassengersCell : UITableViewCell

+(PassengersCell*)passengersCell;

- (void)drawCirlesWithPassengersNumber:(NSInteger)passengers freeSeats:(NSInteger)freeSeats;

@end

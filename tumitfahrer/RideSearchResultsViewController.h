//
//  AnotherActivitiesViewController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/4/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RideSearchResultsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
-(void)reloadDataAtIndex:(NSInteger)index;

@end

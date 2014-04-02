//
//  BalancedColumnLayout.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BalancedColumnLayout;

@protocol BalancedColumnLayoutDelegate <NSObject>

/**
 *  Height of the cell for indexPath, cells will be fit to the global cellWidth set on the layout
 *
 *  @param collectionView       target collection view
 *  @param collectionViewLayout reference to layout
 *  @param indexPath            cell index path
 *
 *  @return the height of the cell
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(BalancedColumnLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

/**
 *  Width of the cells for a section
 *
 *  @param collectionView       target collection view
 *  @param collectionViewLayout reference to layout
 *  @param section              section index
 *
 *  @return the height of the footer
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(BalancedColumnLayout *)collectionViewLayout widthForCellsInSection:(NSInteger)section;

@end

@interface BalancedColumnLayout : UICollectionViewLayout

/**
 * Width for the cells
 */
@property (nonatomic, assign) NSUInteger cellWidth;

/**
 * Vertical spaceing between cells
 */
@property (nonatomic, assign) CGFloat interItemSpacingY;

@end

//
//  EMBigDayCollectionViewLayout.h
//  emark
//
//  Created by neebel on 2017/6/1.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EMBigDayCollectionViewLayout;

@protocol EMBigDayCollectionViewLayoutDelegate <NSObject>

@required

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(EMBigDayCollectionViewLayout *)layout
  heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface EMBigDayCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, assign) NSUInteger numberOfColumns;
@property (nonatomic, assign) CGFloat    interItemSpacing;
@property (nonatomic, weak)   id<EMBigDayCollectionViewLayoutDelegate> delegate;

@end

//
//  EMBigDayCollectionViewCell.h
//  emark
//
//  Created by neebel on 2017/6/1.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMBigDayInfo.h"

@protocol EMBigDayCollectionViewCellDelegate <NSObject>

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface EMBigDayCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<EMBigDayCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)updateCellWithDayInfo:(EMBigDayInfo *)dayInfo;

@end

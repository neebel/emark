//
//  EMCardCollectionViewCell.h
//
//  Created by neebel on 16/10/11.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMPlaceInfo.h"

@protocol EMCardCollectionViewCellDelegate <NSObject>

- (void)deleteIndexPath:(NSIndexPath *)indexPath;

@end

@interface EMCardCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<EMCardCollectionViewCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)updateCellWithPlaceInfo:(EMPlaceInfo *)placeInfo bgColor:(UIColor *)bgColor;

- (void)setBlur:(CGFloat)ratio;//设置毛玻璃效果

@end

//
//  EMCardSelectedLayout.h
//
//  Created by neebel on 16/10/11.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMCardSelectedLayout : UICollectionViewLayout

- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath
                          offsetY:(CGFloat)offsetY
                ContentSizeHeight:(CGFloat)sizeHeight;

@property (nonatomic, assign) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign) CGFloat     contentOffsetY;
@property (nonatomic, assign) CGFloat     contentSizeHeight;

@end

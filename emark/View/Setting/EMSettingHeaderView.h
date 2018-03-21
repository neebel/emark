//
//  EMSettingHeaderView.h
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EMSettingHeaderViewDelegate <NSObject>

- (void)lookBigImage;

@end

@interface EMSettingHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<EMSettingHeaderViewDelegate> delegate;

- (void)updateViewWithImage:(UIImage *)image;

@end

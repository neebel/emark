//
//  UIView+EMTips.h
//  emark
//
//  Created by neebel on 2017/5/28.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMLogoLoopView.h"

@interface UIView (EMTips)

/**
 *  带文字的loading，黑底，不能穿透
 *
 */
- (void)showMaskLoadingTips:(NSString *)tips style:(EMLogoLoopViewStyle)style;

- (void)showMultiLineMessage:(NSString *)message;

- (void)hideManualTips;

@end

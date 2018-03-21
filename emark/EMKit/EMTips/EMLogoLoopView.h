//
//  EMLogoLoopView.h
//  emark
//
//  Created by neebel on 2017/5/28.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EMLogoLoopViewStyle) {
    kLogoLoopGray,
    kLogoLoopWhite,
};

@interface EMLogoLoopView : UIView

- (instancetype)initWithStyle:(EMLogoLoopViewStyle)style;

- (void)startAnimating;

@end

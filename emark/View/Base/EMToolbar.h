//
//  EMToolbar.h
//  emark
//
//  Created by neebel on 2017/6/1.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EMToolbarDelegate <NSObject>

- (void)leftButtonAction;
- (void)rightButtonAction;

@end

@interface EMToolbar : UIToolbar

@property (nonatomic, weak) id<EMToolbarDelegate> toolbarDelegate;

- (instancetype)initWithFrame:(CGRect)frame leftButtonTitle:(NSString *)leftTitle middleLabel:(NSString *)middleLabelStr rightButtonTitle:(NSString *)rightTitle;
- (instancetype)initWithFrame:(CGRect)frame leftView:(UIView *)left middleView:(UIView *)middle rightView:(UIView *)rightView;

@end

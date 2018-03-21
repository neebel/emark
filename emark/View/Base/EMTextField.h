//
//  EMTextField.h
//
//  Created by neebel on 16/8/25.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMTextField : UIView

//文本框
@property (nonatomic,strong) UITextField *textField;
//注释信息
@property (nonatomic,copy)   NSString    *ly_placeholder;
//光标颜色
@property (nonatomic,strong) UIColor     *cursorColor;
//注释普通状态下颜色
@property (nonatomic,strong) UIColor     *placeholderNormalStateColor;
//编辑状态下颜色
@property (nonatomic,strong) UIColor     *placeholderSelectStateColor;

@end

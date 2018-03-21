//
//  EMTheme.h
//  emark
//
//  Created by neebel on 2017/5/26.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

@interface EMTheme : NSObject

@property (nonatomic, strong) UIColor *navBarBGColor;
@property (nonatomic, strong) UIColor *navTintColor;
@property (nonatomic, strong) UIColor *mainBGColor;
@property (nonatomic, strong) UIColor *dividerColor;

@property (nonatomic, strong) UIFont  *navTitleFont;

+ (instancetype)currentTheme;

UIColor * UIColorFromHexARGB(CGFloat alpha, NSInteger hexRGB);
UIColor * UIColorFromHexRGB(NSInteger hexColor);

#define IS_3_5_INCH          ([[UIScreen mainScreen] bounds].size.width == 320 && [[UIScreen mainScreen] bounds].size.height == 480 ? YES:NO)
#define IS_4_0_INCH          ([[UIScreen mainScreen] bounds].size.width == 320 && [[UIScreen mainScreen] bounds].size.height == 568 ? YES:NO)
#define IS_4_7_INCH          ([[UIScreen mainScreen] bounds].size.width == 375 && [[UIScreen mainScreen] bounds].size.height == 667 ? YES:NO)
#define IS_5_5_INCH          ([[UIScreen mainScreen] bounds].size.width == 414 && [[UIScreen mainScreen] bounds].size.height == 736 ? YES:NO)

@end

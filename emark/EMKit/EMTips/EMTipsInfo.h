//
//  EMTipsInfo.h
//  EMTips
//
//  Created by neebel on 5/28/17.
//  Copyright © 2017 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, EMTipsPosition) {
    EMTipsPositionCenter,
    EMTipsPositionTop,
    EMTipsPositionBottom,
};

typedef NS_ENUM(NSUInteger, EMTipsAnimation) {
    EMTipsAnimationFlat,
};

@interface EMTipsInfo : NSObject <NSCopying>

/**
 *  父视图
 */
@property (nonatomic, weak) UIView              *superView;
/**
 *  持续显示时间，0不会自动隐藏
 */
@property (nonatomic, assign) NSTimeInterval    duration;
/**
 *  标题，不能换行
 */
@property (nonatomic, copy) NSString        *title;
/**
 *  标题字体
 */
@property (nonatomic, copy) UIFont          *titleFont;
/**
 *  标题颜色
 */
@property (nonatomic, copy) UIColor         *titleColor;
/**
 *  副标题，可换行
 */
@property (nonatomic, copy) NSString        *message;
/**
 *  副标题字体
 */
@property (nonatomic, copy) UIFont          *msgFont;
/**
 *  副标题颜色
 */
@property (nonatomic, copy) UIColor         *msgColor;

//@property (nonatomic, strong) UIImage       *image;
/**
 *  自定义view，显示在标题顶部，可以提供加载进度的视图
 */
@property (nonatomic, strong) UIView        *customView;

//@property (nonatomic, strong) UIImage       *background;
/**
 *  背景颜色
 */
@property (nonatomic, copy) UIColor         *backgroundColor;
/**
 *  位置（上、中、下）
 */
@property (nonatomic, assign) EMTipsPosition        position;
/**
 *  position的偏移，（上、中、下）位置微调
 */
@property (nonatomic, assign) CGPoint               offset;
/**
 *  显示动画（目前只支持平滑出现）
 */
@property (nonatomic, assign) EMTipsAnimation       showAnimate;
/**
 *  隐藏动画（同上）
 */
@property (nonatomic, assign) EMTipsAnimation       hideAnimate;
/**
 *  点击事件是否可穿透
 */
@property (nonatomic, assign) BOOL          userInteractionEnabled;

/**
 *  默认的自动隐藏info
 *  duration = 3    userInteractionEnabled = Yes
 *
 */
+ (instancetype)defaultAutoInfo;

/**
 *  默认的手动隐藏info
 *  userInteractionEnabled = Yes
 *
 */
+ (instancetype)defaultManualInfo;


/**
 *  父视图是否可见
 *
 */
- (BOOL)isSuperViewVisible;


/**
 *  判断内容是否相同
 *
 *
 */
- (BOOL)isEqualTo:(id)object;


@end

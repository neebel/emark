//
//  EMTips.h
//  EMTips
//
//  Created by neebel on 5/28/17.
//  Copyright © 2017 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMTipsView.h"
#import "EMTipsInfo.h"


@interface EMTips : NSObject

@property (nonatomic, strong, readonly) EMTipsView        *autoTipsView;
@property (nonatomic, strong, readonly) EMTipsView        *manualTipsView;


#pragma mark - Basic Methods

/**
 *  singleton
 *
 */
+ (instancetype)sharedTips;

/**
 *  根据info显示tips
 *
 *  @param tips  info
 *  @param block 消失后的逻辑，只对自动隐藏的tips有效
 */
//CR: 不是dispatch，complete的block就直接用(^())就可以了。
+ (void)showTips:(EMTipsInfo *)tips complete:(void(^)(void))block;





/**
 *  隐藏 manual tips
 */
+ (void)hideTips;



#pragma mark - Convenient Show Methods

/**
 *  显示并自动隐藏可换行文字的tips
 */
+ (void)show:(NSString *)text;


/**
 *  根据配置显示tips，相对灵活
 *
 *  @param message   文字
 *  @param container 父视图
 *  @param duration  显示时间，<= 0表示不自动隐藏
 */
+ (void)showMessage:(NSString *)message
             inView:(UIView *)container
           duration:(NSTimeInterval)duration;


/**
 *  根据配置显示tips，相对灵活
 *
 *  @param message   文字
 *  @param container 父视图
 *  @param duration  显示时间，<= 0表示不自动隐藏
 *  @param enable    是否可穿透
 */
+ (void)showMessage:(NSString *)message
             inView:(UIView *)container
           duration:(NSTimeInterval)duration
        interaction:(BOOL)enable;


/**
 *  根据配置显示tips，相对灵活
 *
 *  @param message   文字
 *  @param container 父视图
 *  @param duration  显示时间，<= 0表示不自动隐藏
 *  @param enable    是否可穿透
 *  @param block     消失后的逻辑，只对duration > 0有效
 */
+ (void)showMessage:(NSString *)message
             inView:(UIView *)container
           duration:(NSTimeInterval)duration
        interaction:(BOOL)enable
           complete:(void(^)(void))block;

/**
 *  根据配置显示tips，相对灵活
 *
 *  @param message   文字
 *  @param container 父视图
 *  @param duration  显示时间，<= 0表示不自动隐藏
 *  @param block     消失后的逻辑，只对duration > 0有效
 */
+ (void)showTitle:(NSString *)title
          message:(NSString *)message
           inView:(UIView *)container
         duration:(NSTimeInterval)duration
         complete:(void(^)(void))block;


/**
 *  根据配置显示tips，相对灵活
 *
 *  @param message   文字
 *  @param image     图片
 *  @param container 父视图
 *  @param duration  显示时间，<= 0表示不自动隐藏
 *  @param enable    是否可穿透
 *  @param block     消失后的逻辑，只对duration > 0有效
 */
+ (void)showMessage:(NSString *)message
              image:(UIImage *)image
             inView:(UIView *)container
           duration:(NSTimeInterval)duration
        interaction:(BOOL)enable
           complete:(void(^)(void))block;



/**
 *  根据配置显示tips，相对灵活
 *
 *  @param message   文字
 *  @param image     图片
 *  @param container 父视图
 *  @param duration  显示时间，<= 0表示不自动隐藏
 *  @param offset    可微调位置
 *  @param enable    是否可穿透
 *  @param block     消失后的逻辑，只对duration > 0有效
 */
+ (void)showMessage:(NSString *)message
              image:(UIImage *)image
             inView:(UIView *)container
           duration:(NSTimeInterval)duration
             offset:(CGPoint)offset
        interaction:(BOOL)enable
           complete:(void(^)(void))block;


/**
 *  显示一个loading logo
 *
 *  @param container 父视图
 *  @param enable    是否可穿透
 */
+ (void)showLoading:(UIView *)loading
            message:(NSString *)message
             inView:(UIView *)container
        interaction:(BOOL)enable;



/**
 *  显示一个loading logo
 *
 *  @param container 父视图
 *  @param enable    是否可穿透
 */
+ (void)showLoading:(UIView *)loading
            message:(NSString *)message
             inView:(UIView *)container
             offset:(CGPoint)offset
        interaction:(BOOL)enable;

/**
 *  显示默认的进度条
 *
 *  @param progress 进度
 *  @param message  副标题
 */
+ (void)showProgress:(CGFloat)progress message:(NSString *)message;



/**
 *  相对灵活的进度条
 *
 *  @param progress  进度
 *  @param message   文字
 *  @param container 父视图
 *  @param enable    是否可穿透
 */
+ (void)showProgress:(CGFloat)progress
             message:(NSString *)message
              inView:(UIView *)container
         interaction:(BOOL)enable;



/**
 *  相对灵活的进度条
 *
 *  @param progress  进度
 *  @param message   文字
 *  @param container 父视图
 *  @param enable    是否可穿透
 */
+ (void)showProgress:(CGFloat)progress
             message:(NSString *)message
              inView:(UIView *)container
              offset:(CGPoint)offset
         interaction:(BOOL)enable;

@end

//
//  EMTips.m
//  EMTips
//
//  Created by neebel on 5/28/17.
//  Copyright © 2017 neebel. All rights reserved.
//

#import <objc/runtime.h>

#import "EMTips.h"
#import "EMProgressLoopView.h"

@interface EMTipsInfo (Complete)
@property (nonatomic, copy) void(^hiddenCompletion)(void);
@end


NSString *const                 kEMManualTipsView;


@interface EMTips()

@property (nonatomic, strong) EMTipsView        *autoTipsView;
@property (nonatomic, strong) EMTipsView        *manualTipsView;
@property (nonatomic, strong) UIView            *background;
@property (nonatomic, strong) NSMutableArray    *tipsQueue;
@property (nonatomic, assign) CGRect            keyboardFrame;

@end

@implementation EMTips

#pragma mark - Life cycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    if (self = [super init]) {
        _tipsQueue = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleKeyboardFrameChange:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - Public

+ (instancetype)sharedTips
{
    static EMTips *_st = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _st = [[EMTips alloc] init];
    });
    return _st;
}


+ (void)showTips:(EMTipsInfo *)tips complete:(void(^)(void))block
{
    //CR: 建议不要将复杂的逻辑封装到类方法中，而是封装到成员方法中
    if ([NSThread isMainThread]) {
        [[self sharedTips] showTips:tips hiddenCompletion:block];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self sharedTips] showTips:tips hiddenCompletion:block];
        });
    }
}


//+ (void)showManualTips:(EMTipsInfo *)tips addTo:(id)controller
//{
//    [[self sharedTips] showManualTips:tips addTo:controller];
//}


+ (void)hideTips
{
    EMTips *shared = [EMTips sharedTips];
    EMTipsView *manualView = shared.manualTipsView;
    shared.manualTipsView = nil;
    if ([NSThread isMainThread]) {
        [manualView hide:nil];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [manualView hide:nil];
        });
    }
}

#pragma mark Private

- (void)showTips:(EMTipsInfo *)tips hiddenCompletion:(void(^)(void))block
{
    BOOL isAuto = tips.duration > 0;
    
    if (isAuto) { //auto hide tips
        EMTipsView *curAutoTipsView = [self autoTipsView];
        BOOL shouldQueue = (self.tipsQueue.count > 0 || curAutoTipsView.visible) &&
                            tips.isSuperViewVisible;
        tips.hiddenCompletion = block;
        if (shouldQueue) {
            [self enqueueAutoTips:tips];
        } else {
            [self displayAutoTips:tips];
        }
    } else { //manual hide tips
        EMTipsInfo *autoTips    = self.autoTipsView.tipsInfo;
        BOOL existAutoTips      = self.autoTipsView.visible;
        BOOL sameSuperview      = autoTips.superView == tips.superView;
        
        BOOL isVisible = self.manualTipsView.visible;
        if (isVisible) {
            [self.manualTipsView updateWithTips:tips];
        } else {
            [self.manualTipsView hide:nil];
            EMTipsView *usableView = [self getUsableTipsViewWithTips:tips];
            self.manualTipsView = usableView;
            [usableView show:nil];
        }
        
        if (existAutoTips && sameSuperview &&
            autoTips.position == EMTipsPositionCenter) { // 已存在auto tips，auto tips 动态移至底部
            CGFloat offset = self.autoTipsView.bounds.size.height + self.manualTipsView.bounds.size.height;
            autoTips.offset     = CGPointMake(0, offset / 2 + 8);
            [self.autoTipsView executeAnimation:autoTips completion:nil];
        }
    }
}


//- (void)showManualTips:(EMTipsInfo *)tips addTo:(id)controller
//{
//    if (controller == nil) {
//        return;
//    }
//    
//    
//    BOOL existAutoTips = self.autoTipsView.visible;
//    if (existAutoTips) { // 已存在auto tips，auto tips 动态移至底部
//        EMTipsInfo *autoTips    = self.autoTipsView.tipsInfo;
//        autoTips.position       = EMTipsPositionBottom;
//        [self.autoTipsView executeAnimation:autoTips completion:nil];
//    }
//    
//    EMTipsView *manualTipsView = objc_getAssociatedObject(controller, &kEMManualTipsView);
//    BOOL existManualTips = manualTipsView.visible;
//    if (existManualTips) {
//        [manualTipsView hide:nil];
//    }
//    
//    EMTipsView *usableView = [self getUsableTipsViewWithTips:tips];
//    objc_setAssociatedObject(controller, &kEMManualTipsView, usableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [usableView show:nil];
//}


//CR：方法太长了，可参看《重构》的方法进行方法封装的提炼；
//    由于存在递归调用来执行队列，所以建议能将递归调用封装得更为明确。
- (void)displayAutoTips:(EMTipsInfo *)tips
{
    
    __weak typeof(self) weakSelf = self;
    
    void(^originalBlock)(void) = tips.hiddenCompletion;
    
    void(^completionBlock)(void) = ^(void) {
        
        if (originalBlock) {
            originalBlock();
        }
        
        EMTipsInfo *next = [weakSelf dequeueAutoTips];
        if (next) {
            [weakSelf displayAutoTips:next];
        } else {
            weakSelf.autoTipsView = nil;
        }
    };
    
    tips.hiddenCompletion = completionBlock;
    
    BOOL existManualTips = self.manualTipsView.visible;
    if (existManualTips) {
        tips.position = EMTipsPositionBottom;
    }
    
    EMTipsView *usableTipsView = [self getUsableTipsViewWithTips:tips];
    
    self.autoTipsView = usableTipsView;
    
    [usableTipsView show:nil];
}


- (EMTipsView *)getUsableTipsViewWithTips:(EMTipsInfo *)tips
{
    EMTipsView *tipsView = nil;
    
    BOOL existManualTips = self.manualTipsView.visible;
    
    if (self.autoTipsView.reusable) {
        tipsView = self.autoTipsView;
    }
    else if (self.manualTipsView.reusable) {
        tipsView = self.manualTipsView;
    }
    
    BOOL isAuto = tips.duration > 0;
    
    if (isAuto && existManualTips) {
        tips.position = EMTipsPositionBottom;
    }
    
    if (!tipsView) {
        tipsView = [[EMTipsView alloc] initWithTips:tips];
    } else {
        [tipsView updateWithTips:tips];
    }
    
    return tipsView;
}


#pragma mark - Queue

- (void)enqueueAutoTips:(EMTipsInfo *)tips
{
    if ([self.autoTipsView.tipsInfo isEqualTo:tips]) {
        return;
    }
    if (self.tipsQueue.count > 1) {
        return;     //  控制下栈数
    }
    [self.tipsQueue addObject:tips];
}


- (EMTipsInfo *)dequeueAutoTips
{
    EMTipsInfo *tips = self.tipsQueue.firstObject;
    if (tips && !tips.isSuperViewVisible) {// 如果父视图都已经释放了或者不可见了，直接出栈
        [self.tipsQueue removeObject:tips];
        return [self dequeueAutoTips];
    }
    if (tips) {
        [self.tipsQueue removeObject:tips];
    }
    return tips;
}


#pragma mark - Helper


- (void)handleKeyboardFrameChange:(NSNotification *)notification
{
    self.keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
}


- (BOOL)isKeyboardShow
{
    return  (self.keyboardFrame.origin.y < [UIScreen mainScreen].bounds.size.height && self.keyboardFrame.size.width == [UIScreen mainScreen].bounds.size.width) ||
    (self.keyboardFrame.origin.y < [UIScreen mainScreen].bounds.size.width && self.keyboardFrame.size.width == [UIScreen mainScreen].bounds.size.height);
}







#pragma mark - Public convenient methods


+ (void)show:(NSString *)text
{
    EMTipsInfo *tips = [EMTipsInfo defaultAutoInfo];
    tips.title = text;
    [EMTips showTips:tips complete:nil];
}


+ (void)showMessage:(NSString *)message
             inView:(UIView *)container
           duration:(NSTimeInterval)duration
{
    [self showMessage:message
                image:nil
               inView:container
             duration:duration
          interaction:YES
             complete:nil];
}




+ (void)showMessage:(NSString *)message
             inView:(UIView *)container
           duration:(NSTimeInterval)duration
        interaction:(BOOL)enable
{
    [self showMessage:message
                image:nil
               inView:container
             duration:duration
               offset:CGPointZero
          interaction:enable
             complete:nil];
}



+ (void)showMessage:(NSString *)message
             inView:(UIView *)container
           duration:(NSTimeInterval)duration
        interaction:(BOOL)enable
           complete:(void (^)(void))block
{
    [self showMessage:message
                image:nil
               inView:container
             duration:duration
               offset:CGPointZero
          interaction:enable
             complete:block];
}


+ (void)showMessage:(NSString *)message
              image:(UIImage *)image
             inView:(UIView *)container
           duration:(NSTimeInterval)duration
        interaction:(BOOL)enable
           complete:(void (^)(void))block
{
    [self showMessage:message
                image:image
               inView:container
             duration:duration
               offset:CGPointZero
          interaction:enable
             complete:block];
}


+ (void)showTitle:(NSString *)title
          message:(NSString *)message
           inView:(UIView *)container
         duration:(NSTimeInterval)duration
         complete:(void (^)(void))block
{
    EMTipsInfo *tips = [EMTipsInfo defaultAutoInfo];
    tips.title      = title;
    tips.message    = message;
    tips.duration   = duration;
    tips.superView  = container;
    [EMTips showTips:tips complete:block];
}


+ (void)showMessage:(NSString *)message
              image:(UIImage *)image
             inView:(UIView *)container
           duration:(NSTimeInterval)duration
             offset:(CGPoint)offset
        interaction:(BOOL)enable
           complete:(void(^)(void))block
{
    EMTipsInfo *tips = [EMTipsInfo defaultAutoInfo];
    tips.message    = message;
    tips.duration   = duration;
    tips.superView  = container;
    tips.offset     = offset;
    tips.userInteractionEnabled = enable;
    if (image) {
        tips.customView = [[UIImageView alloc] initWithImage:image];
    }
    [EMTips showTips:tips complete:block];
}

+ (void)showLoading:(UIView *)loading
            message:(NSString *)message
             inView:(UIView *)container
        interaction:(BOOL)enable
{
    [self showLoading:loading
              message:message
               inView:container
               offset:CGPointZero
          interaction:enable];
}


+ (void)showLoading:(UIView *)loading
            message:(NSString *)message
             inView:(UIView *)container
             offset:(CGPoint)offset
        interaction:(BOOL)enable
{
    EMTipsInfo *tips = [EMTipsInfo defaultManualInfo];
    if (message == nil) {
        tips.backgroundColor = [UIColor clearColor];
    }
    tips.offset = offset;
    tips.message = message;
    tips.superView = container;
    tips.userInteractionEnabled = enable;
    tips.customView = loading;
    [EMTips showTips:tips complete:nil];
}


+ (void)showProgress:(CGFloat)progress
             message:(NSString *)message
              inView:(UIView *)container
         interaction:(BOOL)enable
{
    [self showProgress:progress
               message:message
                inView:container
                offset:CGPointZero
           interaction:enable];
}


+ (void)showProgress:(CGFloat)progress
             message:(NSString *)message
              inView:(UIView *)container
              offset:(CGPoint)offset
         interaction:(BOOL)enable
{
    EMTipsView *manualTipsView = [EMTips sharedTips].manualTipsView;
    if (manualTipsView.visible && !manualTipsView.isProgress) {
        [EMTips hideTips];
    }
    if (!manualTipsView.visible) {
        EMTipsInfo *tips = [EMTipsInfo defaultManualInfo];
        tips.message = message;
        tips.offset = offset;
        tips.superView = container;
        EMProgressLoopView *progressView = [EMProgressLoopView defaultProgressLoopView];
        progressView.progress = progress;
        tips.customView = progressView;
        tips.userInteractionEnabled = enable;
        [EMTips showTips:tips complete:nil];
    } else {
        UIView<EMTipsProgressProtocol> *progressView = (UIView<EMTipsProgressProtocol> *)manualTipsView.customView;
        if ([progressView respondsToSelector:@selector(setProgress:)]) {
            [progressView setProgress:progress];
        }
        
        if (![manualTipsView.tipsInfo.message isEqualToString:message]) {
            EMTipsInfo *tips = manualTipsView.tipsInfo;
            tips.message = message;
            [manualTipsView updateWithTips:tips];
        }
    }
}


+ (void)showProgress:(CGFloat)progress message:(NSString *)message
{
    EMTipsView *manualTipsView = [EMTips sharedTips].manualTipsView;
    if (manualTipsView.visible && !manualTipsView.isProgress) {
        [EMTips hideTips];
    }
    
    if (!manualTipsView.visible) {
        EMTipsInfo *tips = [EMTipsInfo defaultManualInfo];
        tips.message = message;
        tips.customView = [EMProgressLoopView defaultProgressLoopView];
        [EMTips showTips:tips complete:nil];
    } else {
        UIView<EMTipsProgressProtocol> *progressView = (UIView<EMTipsProgressProtocol> *)manualTipsView.customView;
        if ([progressView respondsToSelector:@selector(setProgress:)]) {
            [progressView setProgress:progress];
        }
        
        if (![manualTipsView.tipsInfo.message isEqualToString:message]) {
            EMTipsInfo *tips = manualTipsView.tipsInfo;
            tips.message = message;
            [manualTipsView updateWithTips:tips];
        }
    }
}



@end

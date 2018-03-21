//
//  EMTipsInfo.m
//  EMTips
//
//  Created by neebel on 5/28/17.
//  Copyright © 2017 neebel. All rights reserved.
//

#import "EMTipsInfo.h"

@interface EMTipsInfo ()
@property (nonatomic, copy) void(^hiddenCompletion)(void);
@end

@implementation EMTipsInfo

- (id)copyWithZone:(NSZone *)zone
{
    EMTipsInfo *copy    = [[EMTipsInfo alloc] init];
    copy.superView      = self.superView;
    copy.duration       = self.duration;
    copy.title          = self.title;
    copy.titleFont      = self.titleFont;
    copy.titleColor     = self.titleColor;
    copy.message        = self.message;
    copy.msgFont        = self.msgFont;
    copy.msgColor       = self.msgColor;
//    copy.image          = self.image;
    copy.customView     = self.customView;
//    copy.background     = self.background;
    copy.backgroundColor = self.backgroundColor;
    copy.position       = self.position;
    copy.offset         = self.offset;
    copy.showAnimate    = self.showAnimate;
    copy.hideAnimate    = self.hideAnimate;
    copy.userInteractionEnabled = self.userInteractionEnabled;
    copy.hiddenCompletion  = self.hiddenCompletion;
    return copy;
}


- (BOOL)isEqualTo:(id)object
{
    if (![object isKindOfClass:[EMTipsInfo class]]) {
        return NO;
    }
    
    EMTipsInfo *other = (EMTipsInfo *)object;
    
    if (!([other.message isEqualToString:self.message] ||
          (self.message.length == 0 && other.message.length == 0))) {
        return NO;
    }
    
    if (!((self.customView == nil && other.customView == nil) ||
        [other.customView isKindOfClass:[self.customView class]])) {
        return NO;
    }
    
    if (!([other.title isEqualToString:self.title] ||
        (self.title.length == 0 && other.title.length == 0))) {
        return NO;
    }
    
    return  YES;
}


- (void)setSuperView:(UIView *)superView
{   // 默认是放在keyWindow
    if (!superView) {
        _superView = [UIApplication sharedApplication].keyWindow;
    } else {
        _superView = superView;
    }
}


+ (instancetype)defaultAutoInfo
{
    EMTipsInfo *tips            = [[EMTipsInfo alloc] init];
    tips.superView              = [UIApplication sharedApplication].delegate.window;
    tips.duration               = 2;
    tips.titleFont              = [UIFont systemFontOfSize:17];
    tips.titleColor             = [UIColor whiteColor];
    tips.msgFont                = [UIFont systemFontOfSize:15];
    tips.msgColor               = [UIColor whiteColor];
    tips.backgroundColor        = [UIColor colorWithWhite:0 alpha:0.5];
    tips.userInteractionEnabled = YES;
    return tips;
}


+ (instancetype)defaultManualInfo
{
    EMTipsInfo *tips            = [[EMTipsInfo alloc] init];
    tips.superView              = [UIApplication sharedApplication].delegate.window;
    tips.duration               = 0;
    tips.titleFont              = [UIFont systemFontOfSize:17];
    tips.titleColor             = [UIColor whiteColor];
    tips.msgFont                = [UIFont systemFontOfSize:15];
    tips.msgColor               = [UIColor whiteColor];
    tips.backgroundColor        = [UIColor colorWithWhite:0 alpha:0.5];
    tips.userInteractionEnabled = NO;
    return tips;
}


- (BOOL)isSuperViewVisible
{
    if ([self.superView isKindOfClass:[UIWindow class]]) {
        return self.superView != nil;
    }
    return self.superView != nil && self.superView.window != nil;
}


@end

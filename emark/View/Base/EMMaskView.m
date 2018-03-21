//
//  EMMaskView.m
//  emark
//
//  Created by neebel on 2017/6/11.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMMaskView.h"

@interface EMMaskView()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation EMMaskView

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.bgView];
}


- (UIView *)bgView
{
    if (!_bgView) {
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        _bgView = [[UIView alloc] initWithFrame:window.bounds];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:_bgView.bounds];
        
        CGFloat x = 0;
        if (IS_5_5_INCH) {
            x = window.bounds.size.width - 31;
        } else {
            x = window.bounds.size.width - 27;
        }
        
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x, 42)
                                                                  radius:20
                                                              startAngle:0
                                                                endAngle:2 * M_PI
                                                               clockwise:NO];
        [path appendPath:circlePath];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        _bgView.layer.mask = shapeLayer;
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_bgView addGestureRecognizer:gesture];
    }

    return _bgView;
}


- (void)dismiss
{
    [self.bgView removeFromSuperview];
}

@end

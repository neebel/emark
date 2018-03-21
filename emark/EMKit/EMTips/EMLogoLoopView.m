//
//  EMLogoLoopView.m
//  emark
//
//  Created by neebel on 2017/5/28.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMLogoLoopView.h"

@interface EMLogoLoopView ()

@property (nonatomic, strong) CALayer   *loopLayer;

@end


@implementation EMLogoLoopView



- (instancetype)initWithStyle:(EMLogoLoopViewStyle)style
{
    self = [super init];
    if (self) {
        [self setup:style];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:kLogoLoopGray];
    }
    return self;
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.loopLayer.position = CGPointMake(frame.size.width / 2, frame.size.height / 2);
}


- (void)setup:(EMLogoLoopViewStyle)style
{
    NSString *imageName = @"loading_loop";
    if (style == kLogoLoopWhite) {
        imageName = @"loading_loop_white";
    }
    
    UIImage *loopImage = [UIImage imageNamed:imageName];
    self.loopLayer.frame = (CGRect){CGPointZero, loopImage.size};
    self.loopLayer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self.layer addSublayer:self.loopLayer];
    self.loopLayer.contents = (__bridge id _Nullable)(loopImage.CGImage);
    
    
    if (style == kLogoLoopWhite) {
        imageName = @"loading_logo_white";
    } else {
        imageName = @"loading_logo";
    }
    UIImage *logoImage = [UIImage imageNamed:imageName];
    self.layer.contents = (__bridge id _Nullable)(logoImage.CGImage);
    self.layer.contentsScale = [UIScreen mainScreen].scale;
    self.contentMode = UIViewContentModeCenter;
}


- (void)startAnimating
{
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.duration = 1;
    rotation.fromValue = @0;
    rotation.toValue = @(2 * M_PI);
    rotation.repeatCount = MAXFLOAT;
    rotation.removedOnCompletion = NO;
    [self.loopLayer addAnimation:rotation forKey:@"transform.rotation"];
}


- (CALayer *)loopLayer
{
    if (!_loopLayer) {
        _loopLayer = [CALayer layer];
    }
    return _loopLayer;
}

@end

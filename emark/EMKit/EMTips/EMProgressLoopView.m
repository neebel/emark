//
//  EMProgressLoopView.m
//  EMTips
//
//  Created by neebel on 17/5/28.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMProgressLoopView.h"

@interface EMProgressLoopView ()

@property (nonatomic, strong) UIImageView       *imageView;
@property (nonatomic, strong) CAShapeLayer      *baseTrackLayer;
@property (nonatomic, strong) CAShapeLayer      *progressLayer;

@end

@implementation EMProgressLoopView

@synthesize progressWidth   = _progressWidth;
@synthesize progressColor   = _progressColor;

+ (instancetype)defaultProgressLoopView
{
    EMProgressLoopView *progressView = [[EMProgressLoopView alloc] initWithFrame:CGRectMake(0, 0, defaultWidth, defaultWidth)];
    
    progressView.trackColor = [UIColor lightGrayColor];
    progressView.progressColor = [UIColor whiteColor];
    progressView.progressWidth = 4;
    
    progressView.userInteractionEnabled = YES;
    return progressView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViewWith:frame];
    }
    return self;
}

- (void)setupSubViewWith:(CGRect)frame
{
    _baseTrackLayer = [CAShapeLayer layer];
    [self.layer addSublayer:_baseTrackLayer];
    _baseTrackLayer.fillColor = [UIColor clearColor].CGColor;
    _baseTrackLayer.frame = self.bounds;
    
    _progressLayer = [CAShapeLayer layer];
    [self.layer addSublayer:_progressLayer];
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineJoin = kCALineJoinBevel;
    _progressLayer.frame = self.bounds;
    
    UIImageView *defaultImage = [[UIImageView alloc] init];
    defaultImage.frame = CGRectMake(0, 0, frame.size.width - 1 , frame.size.height - 1);
    defaultImage.center = self.center;
    
    defaultImage.layer.masksToBounds = YES;
    defaultImage.layer.cornerRadius = defaultImage.frame.size.width / 2 ;
   
    defaultImage.image=  self.defaultImage;
    [self addSubview:defaultImage];
    self.imageView = defaultImage;
    
    

    [self setDefaultSetting];
}

- (void)setDefaultSetting
{
    if (!self.defaultImage) {
        self.imageView.image = [UIImage imageNamed:@"AppIcon"];
    }
    if (_baseTrackColor) {
        _baseTrackLayer.strokeColor = _baseTrackColor.CGColor;
    } else {
        _baseTrackLayer.strokeColor = [UIColor grayColor].CGColor;
    }
    if (_progressColor) {
        _progressLayer.strokeColor = _progressColor.CGColor;
    } else {
        _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    }
    if (_progressWidth) {
        _progressLayer.lineWidth = _progressWidth;
        _baseTrackLayer.lineWidth = _progressWidth;
    } else {
        _progressLayer.lineWidth = 4;
        _baseTrackLayer.lineWidth = 4;
    }
}

- (void)setProgress
{
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:(self.bounds.size.width - _progressWidth)/ 2
                                                    startAngle:- M_PI_2
                                                      endAngle:(M_PI * 2) * _progress - M_PI_2
                                                     clockwise:YES];
    _progressLayer.path = path.CGPath;
}

- (void)setProgressWidth:(CGFloat)progressWidth
{
    _progressWidth = progressWidth;
//    _baseTrackLayer.lineWidth = _progressWidth;
//    _progressLayer.lineWidth = _progressWidth;
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    UIBezierPath *baseTrackPath = [UIBezierPath bezierPathWithArcCenter:center
                                                                 radius:(self.bounds.size.width - progressWidth)/ 2
                                                             startAngle:0
                                                               endAngle:M_PI * 2
                                                              clockwise:YES];
    _baseTrackLayer.path = baseTrackPath.CGPath;
    
    [self setProgress];
}

- (void)setTrackColor:(UIColor *)trackColor
{
    _baseTrackLayer.strokeColor = trackColor.CGColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressLayer.strokeColor = progressColor.CGColor;
}

- (void)setDefaultImage:(UIImage *)defaultImage
{
    self.imageView.image = defaultImage;
}

- (UIImage *)defaultImage
{
    return self.imageView.image;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setProgress];
}

- (void)increaseProgress
{
    self.progress += 0.1;
    
    if(self.progress < 1.0f) {
        [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.3f];
    }
}

- (BOOL)isEqual:(id)object
{
    return [object isKindOfClass:[self class]];
}

@end

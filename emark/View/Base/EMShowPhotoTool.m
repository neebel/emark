//
//  EMShowPhotoTool.m
//  emark
//
//  Created by neebel on 2017/6/11.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMShowPhotoTool.h"

@interface EMShowPhotoTool()

@property (nonatomic, strong) UIImageView *picImageView;

@end

@implementation EMShowPhotoTool

- (void)showWithImage:(UIImage *)image
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.picImageView];
    [UIView animateWithDuration:0.3 animations:^{
        self.picImageView.frame = CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height);
    } completion:^(BOOL finished) {
        self.picImageView.image = image;
    }];
}


- (UIImageView *)picImageView
{
    if (!_picImageView) {
        _picImageView = [[UIImageView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2, 0, 0)];
        _picImageView.contentMode = UIViewContentModeScaleAspectFit;
        _picImageView.backgroundColor = [UIColor colorWithHue:0.0
                                                   saturation:0.0
                                                   brightness:0.0
                                                        alpha:0.8];
        _picImageView.alpha = 1;
        _picImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [_picImageView addGestureRecognizer:gesture];
    }

    return _picImageView;
}


- (void)close
{
    [UIView animateWithDuration:0.3 animations:^{
        self.picImageView.alpha = 0;
    }completion:^(BOOL finished) {
        [self.picImageView removeFromSuperview];
        self.picImageView = nil;
    }];
}

@end

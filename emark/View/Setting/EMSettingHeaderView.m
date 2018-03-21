//
//  EMSettingHeaderView.m
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMSettingHeaderView.h"

@interface EMSettingHeaderView()

@property (nonatomic, strong) UIImageView *headImageView;

@end

@implementation EMSettingHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headImageView];
        __weak typeof(self) weakSelf = self;
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf.contentView);
            make.width.height.mas_equalTo(70);
        }];
    }
    
    return self;
}


- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
        _headImageView.layer.cornerRadius = 35;
        _headImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookBigImage)];
        [_headImageView addGestureRecognizer:gesture];
        _headImageView.backgroundColor = [UIColor whiteColor];
        _headImageView.image = [UIImage imageNamed:@"headDefault"];
    }
    
    return _headImageView;
}


- (void)updateViewWithImage:(UIImage *)image
{
    if (image) {
        self.headImageView.image = image;
    }
}


- (void)lookBigImage
{
    if ([self.delegate respondsToSelector:@selector(lookBigImage)]) {
        [self.delegate lookBigImage];
    }
}

@end

//
//  EMCardCollectionViewCell.m
//
//  Created by neebel on 16/10/11.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "EMCardCollectionViewCell.h"

@interface EMCardCollectionViewCell()

@property (nonatomic, strong) UILabel            *nameLabel;
@property (nonatomic, strong) UILabel            *whereLabel;
@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UIImageView        *arrowImageView;
@property (nonatomic, strong) UIButton           *deleteButton;

@end

@implementation EMCardCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    
    return self;
}


- (void)initUI
{
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    [self.contentView addSubview:self.nameLabel];
    __weak typeof(self) weakSelf = self;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).with.offset(5);
        make.top.equalTo(weakSelf.contentView).with.offset(5);
        make.bottom.equalTo(weakSelf.contentView).with.offset(-5);
        make.width.mas_equalTo((weakSelf.contentView.bounds.size.width - 50 - 10)/2);
    }];
    
    [self.contentView addSubview:self.whereLabel];
    [self.whereLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).with.offset(-5);
        make.top.equalTo(weakSelf.contentView).with.offset(5);
        make.bottom.equalTo(weakSelf.contentView).with.offset(-5);
        make.width.mas_equalTo((weakSelf.contentView.bounds.size.width - 50 - 10)/2);
    }];
    
    [self.contentView addSubview:self.arrowImageView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(50);
        make.center.equalTo(weakSelf.contentView);
    }];
    
    [self.contentView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.right.top.equalTo(weakSelf.contentView);
    }];
}


- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:18.0];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _nameLabel;
}


- (UILabel *)whereLabel
{
    if (!_whereLabel) {
        _whereLabel = [[UILabel alloc] init];
        _whereLabel.font = [UIFont systemFontOfSize:18.0];
        _whereLabel.textColor = [UIColor whiteColor];
        _whereLabel.numberOfLines = 0;
        _whereLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _whereLabel;
}


- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"placeArrow"];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    }

    return _arrowImageView;
}


- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_deleteButton addTarget:self
                          action:@selector(delete)
                forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setImage:[UIImage imageNamed:@"placePublishCancel"]
                       forState:UIControlStateNormal];
    }

    return _deleteButton;
}

- (void)updateCellWithPlaceInfo:(EMPlaceInfo *)placeInfo bgColor:(UIColor *)bgColor
{
    self.contentView.backgroundColor = bgColor;
    self.nameLabel.text = placeInfo.goodsName;
    self.whereLabel.text = placeInfo.placeName;
}


//设置毛玻璃效果
- (void)setBlur:(CGFloat)ratio
{
    if (!self.blurView.superview) {
        [self.contentView addSubview:self.blurView];
    }
    
    [self.contentView bringSubviewToFront:self.blurView];
    self.blurView.alpha = ratio;
}


- (UIVisualEffectView *)blurView
{
    if (!_blurView) {
        _blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _blurView.frame = self.bounds;
    }
    
    return _blurView;
}


- (void)delete
{
    if ([self.delegate respondsToSelector:@selector(deleteIndexPath:)]) {
        [self.delegate deleteIndexPath:self.indexPath];
    }
}

@end

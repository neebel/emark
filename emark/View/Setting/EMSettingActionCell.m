//
//  EMSettingActionCell.m
//  emark
//
//  Created by neebel on 2017/5/28.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMSettingActionCell.h"

@interface EMSettingActionCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView  *bottomView;

@end

@implementation EMSettingActionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        __weak typeof(self) weakSelf = self;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.contentView);
        }];
        
        [self.contentView addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView);
            make.right.equalTo(weakSelf.contentView);
            make.top.equalTo(weakSelf.contentView);
            make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        }];
    }

    return self;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.textColor = UIColorFromHexRGB(0x333333);
    }

    return _titleLabel;
}


- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = UIColorFromHexRGB(0xCCCCCC);
    }
    
    return _bottomView;
}


- (void)updateCellWithTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

@end

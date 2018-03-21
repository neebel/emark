//
//  EMPublishBillTableViewCell.m
//  emark
//
//  Created by neebel on 2017/5/31.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMPublishBillTableViewCell.h"

@interface EMPublishBillTableViewCell()

@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UIView  *bottomView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation EMPublishBillTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        __weak typeof(self) weakSelf = self;
        [self.contentView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(17);
            make.centerY.equalTo(weakSelf.contentView);
            make.width.height.mas_equalTo(16);
        }];
        
        [self.contentView addSubview:self.itemLabel];
        [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
            make.left.equalTo(weakSelf.contentView).with.offset(42);
            make.centerY.equalTo(weakSelf.contentView);
        }];
        
        [self.contentView addSubview:self.valueLabel];
        [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
            make.right.equalTo(weakSelf.contentView).with.offset(-30);
            make.centerY.equalTo(weakSelf.contentView);
        }];

        [self.contentView addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(15);
            make.right.equalTo(weakSelf.contentView);
            make.bottom.equalTo(weakSelf.contentView);
            make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        }];
        
        [self.contentView addSubview:self.arrowImageView];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView).with.offset(-10);
            make.width.height.mas_equalTo(20);
            make.centerY.equalTo(weakSelf.contentView);
        }];
    }
    
    return self;
}


- (void)updateCellWithItemInfo:(EMBillItemInfo *)info;
{
    self.itemLabel.text = info.itemName;
    self.valueLabel.text = info.itemValue;
    self.iconImageView.image = [UIImage imageNamed:info.iconName];
}

#pragma mark Getter

- (UILabel *)itemLabel
{
    if (!_itemLabel) {
        _itemLabel = [[UILabel alloc] init];
        _itemLabel.font = [UIFont systemFontOfSize:15.0];
        _itemLabel.textColor = UIColorFromHexRGB(0x333333);
    }
    
    return _itemLabel;
}


- (UILabel *)valueLabel
{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.font = [UIFont systemFontOfSize:15.0];
        _valueLabel.textColor = UIColorFromHexRGB(0x333333);
        _valueLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return _valueLabel;
}


- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [EMTheme currentTheme].dividerColor;
    }
    
    return _bottomView;
}


- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
        _arrowImageView.image = [UIImage imageNamed:@"arrowRight"];
    }
    
    return _arrowImageView;
}


- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _iconImageView;
}

@end

//
//  EMPublishBillEditTableViewCell.m
//  emark
//
//  Created by neebel on 2017/6/1.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMPublishBillEditTableViewCell.h"

@interface EMPublishBillEditTableViewCell()

@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UIView  *bottomView;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation EMPublishBillEditTableViewCell

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
        
        [self.contentView addSubview:self.valueTextField];
        [self.valueTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(200);
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
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}


- (void)updateCellWithItemInfo:(EMBillItemInfo *)info;
{
    self.itemLabel.text = info.itemName;
    self.valueTextField.placeholder = info.itemValue;
    self.iconImageView.image = [UIImage imageNamed:info.iconName];
}

#pragma mark Getter

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _iconImageView;
}


- (UILabel *)itemLabel
{
    if (!_itemLabel) {
        _itemLabel = [[UILabel alloc] init];
        _itemLabel.font = [UIFont systemFontOfSize:15.0];
        _itemLabel.textColor = UIColorFromHexRGB(0x333333);
    }
    
    return _itemLabel;
}


- (UITextField *)valueTextField
{
    if (!_valueTextField) {
        _valueTextField = [[UITextField alloc] init];
        _valueTextField.font = [UIFont systemFontOfSize:15.0];
        _valueTextField.textColor = UIColorFromHexRGB(0x333333);
        _valueTextField.textAlignment = NSTextAlignmentRight;
    }
    
    return _valueTextField;
}


- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [EMTheme currentTheme].dividerColor;
    }
    
    return _bottomView;
}

@end

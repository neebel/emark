//
//  EMSettingTableViewCell.m
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMSettingTableViewCell.h"

@interface EMSettingTableViewCell()

@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UIView  *bottomView;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation EMSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        __weak typeof(self) weakSelf = self;
        [self.contentView addSubview:self.picImageView];
        [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(17);
            make.width.height.mas_equalTo(15);
            make.centerY.equalTo(weakSelf.contentView);
        }];
        
        [self.contentView addSubview:self.itemLabel];
        [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
            make.left.equalTo(weakSelf.contentView).with.offset(42);
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


- (void)updateCellWithTitle:(NSString *)title
{
    self.itemLabel.text = title;
    self.bottomView.hidden = [title isEqualToString:NSLocalizedString(@"鼓励一下", nil)];
    if ([title isEqualToString:NSLocalizedString(@"更换头像", nil)]) {
        self.picImageView.image = [UIImage imageNamed:@"settingHead"];
    } else if ([title isEqualToString:NSLocalizedString(@"关于我们", nil)]) {
        self.picImageView.image = [UIImage imageNamed:@"settingAbout"];
    } else if ([title isEqualToString:NSLocalizedString(@"鼓励一下", nil)]) {
        self.picImageView.image = [UIImage imageNamed:@"settingPraise"];
    }
}

#pragma mark Getter

- (UILabel *)itemLabel
{
    if (!_itemLabel) {
        _itemLabel = [[UILabel alloc] init];
        _itemLabel.font = [UIFont systemFontOfSize:15.0];
        _itemLabel.textColor = UIColorFromHexRGB(0x666666);
    }
    
    return _itemLabel;
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


- (UIImageView *)picImageView
{
    if (!_picImageView) {
        _picImageView = [[UIImageView alloc] init];
        _picImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _picImageView;
}

@end

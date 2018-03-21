//
//  EMBillHeaderView.m
//  emark
//
//  Created by neebel on 2017/6/5.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBillHeaderView.h"

@interface EMBillHeaderView()

@property (nonatomic, strong) UILabel  *monthLabel;
@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation EMBillHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [EMTheme currentTheme].mainBGColor;
        [self.contentView addSubview:self.monthLabel];
        __weak typeof(self) weakSelf = self;
        [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(17);
            make.height.bottom.equalTo(weakSelf.contentView);
            make.width.mas_equalTo(100);
        }];
        
        [self.contentView addSubview:self.enterButton];
        [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView).with.offset(-5);
            make.top.bottom.equalTo(weakSelf.contentView);
            make.width.mas_equalTo(100);
        }];
        
        [self.contentView addSubview:self.arrowImageView];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(18);
            make.right.equalTo(weakSelf.contentView).with.offset(-5);
            make.centerY.equalTo(weakSelf.contentView);
        }];
    }

    return self;
}


- (UILabel *)monthLabel
{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] init];
        _monthLabel.font = [UIFont systemFontOfSize:16.0];
        _monthLabel.textColor = UIColorFromHexRGB(0x333333);
    }

    return _monthLabel;
}


- (UIButton *)enterButton
{
    if (!_enterButton) {
        _enterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        [_enterButton setTitle:NSLocalizedString(@"查看月账单", nil) forState:UIControlStateNormal];
        [_enterButton setTitleColor:UIColorFromHexRGB(0x999999)
                           forState:UIControlStateNormal];
        _enterButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [_enterButton addTarget:self
                         action:@selector(enter)
               forControlEvents:UIControlEventTouchUpInside];
    }

    return _enterButton;
}


- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        _arrowImageView.image = [UIImage imageNamed:@"arrowRight"];
        _arrowImageView.contentMode = UIViewContentModeScaleToFill;
    }

    return _arrowImageView;
}

- (void)updateViewWithTitle:(NSString *)title
{
    self.monthLabel.text = title;
}


- (void)enter
{
    if ([self.delegate respondsToSelector:@selector(enterMonthBillWithMonth:)]) {
        [self.delegate enterMonthBillWithMonth:self.monthLabel.text];
    }
}

@end

//
//  EMHomeCollectionViewCell.m
//  emark
//
//  Created by neebel on 2017/5/26.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMHomeCollectionViewCell.h"

@interface EMHomeCollectionViewCell()

@property (nonatomic, strong) UILabel *menuLabel;

@end

@implementation EMHomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.menuLabel];
        __weak typeof(self) weakSelf = self;
        [self.menuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.contentView);
        }];
    }

    return self;
}


- (UILabel *)menuLabel
{
    if (!_menuLabel) {
        _menuLabel = [[UILabel alloc] init];
        _menuLabel.textAlignment = NSTextAlignmentCenter;
        _menuLabel.textColor = [UIColor whiteColor];
        _menuLabel.font = [UIFont systemFontOfSize:18.0];
    }
    
    return _menuLabel;
}


- (void)updateCellWithTitle:(NSString *)title
{
    self.menuLabel.text = title;
    UIColor *bgColor;
    if ([title isEqualToString:NSLocalizedString(@"日记", nil)]) {
        bgColor = UIColorFromHexRGB(0x00BEFE);
    } else if ([title isEqualToString:NSLocalizedString(@"账单", nil)]) {
        bgColor = UIColorFromHexRGB(0xFD2B61);
    } else if ([title isEqualToString:NSLocalizedString(@"节日", nil)]) {
        bgColor = UIColorFromHexRGB(0x7ABA00);
    } else if ([title isEqualToString:NSLocalizedString(@"收纳", nil)]) {
        bgColor = UIColorFromHexRGB(0xFF8001);
    } else if ([title isEqualToString:NSLocalizedString(@"提醒", nil)]) {
        bgColor = UIColorFromHexRGB(0xB01F00);
    } else if ([title isEqualToString:NSLocalizedString(@"设置", nil)]) {
        bgColor = UIColorFromHexRGB(0x8C88FE);
    }
    
    self.contentView.backgroundColor = bgColor;
}

@end

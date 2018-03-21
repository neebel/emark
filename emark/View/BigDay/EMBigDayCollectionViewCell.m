//
//  EMBigDayCollectionViewCell.m
//  emark
//
//  Created by neebel on 2017/6/1.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBigDayCollectionViewCell.h"

@interface EMBigDayCollectionViewCell()

@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *remarkLabel;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation EMBigDayCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        __weak typeof(self) weakSelf = self;
        [self.contentView addSubview:self.typeImageView];
        [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(weakSelf.contentView);
            make.height.width.mas_equalTo(50);
        }];
        
        [self.contentView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(10);
            make.right.equalTo(weakSelf.contentView).with.offset(-50);
            make.top.equalTo(weakSelf.contentView).with.offset(10);
            make.height.mas_equalTo(20);
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(10);
            make.right.equalTo(weakSelf.contentView).with.offset(-10);
            make.top.equalTo(weakSelf.dateLabel.mas_bottom).with.offset(10);
        }];
        
        [self.contentView addSubview:self.remarkLabel];
        [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(10);
            make.right.equalTo(weakSelf.contentView).with.offset(-10);
            make.top.equalTo(weakSelf.nameLabel.mas_bottom).with.offset(10);
        }];
        
        [self.contentView addSubview:self.deleteButton];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(weakSelf.contentView);
            make.width.height.mas_equalTo(40);
        }];
    }
    
    return self;
}


- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width - 20, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:15.0];
        _nameLabel.numberOfLines = 0;
    }
    
    return _nameLabel;
}


- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = UIColorFromHexRGB(0x333333);
        _dateLabel.font = [UIFont systemFontOfSize:15.0];
        _dateLabel.numberOfLines = 1;
    }
    
    return _dateLabel;
}


- (UILabel *)remarkLabel
{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width - 20, 20)];
        _remarkLabel.textColor = UIColorFromHexRGB(0x666666);
        _remarkLabel.font = [UIFont systemFontOfSize:13.0];
        _remarkLabel.numberOfLines = 0;
    }
    
    return _remarkLabel;
}


- (UIImageView *)typeImageView
{
    if (!_typeImageView) {
        _typeImageView = [[UIImageView alloc] init];
    }

    return _typeImageView;
}


- (void)updateCellWithDayInfo:(EMBigDayInfo *)dayInfo
{
    self.dateLabel.text = dayInfo.bigDayDate;
    self.nameLabel.text = dayInfo.bigDayName;
    self.remarkLabel.text = dayInfo.bigDayRemark;
    
    NSString *imageName = nil;
    UIColor  *textColor = nil;
    if ([dayInfo.bigDayType isEqualToString:NSLocalizedString(@"生日", nil)]) {
        imageName = @"bigDayBlue";
        textColor = UIColorFromHexRGB(0x00BEFE);
    } else if ([dayInfo.bigDayType isEqualToString:NSLocalizedString(@"纪念日", nil)]) {
        imageName = @"bigDayRed";
        textColor = UIColorFromHexRGB(0xFD2B61);
    } else if ([dayInfo.bigDayType isEqualToString:NSLocalizedString(@"其他", nil)]) {
        imageName = @"bigDayGreen";
        textColor = UIColorFromHexRGB(0x7ABA00);
    }
    
    self.typeImageView.image = [UIImage imageNamed:imageName];
    self.nameLabel.textColor = textColor;
    
    self.deleteButton.hidden = !dayInfo.showDelete;
}


- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_deleteButton setImage:[UIImage imageNamed:@"bigDayDelete"] forState:UIControlStateNormal];
        _deleteButton.hidden = YES;
        [_deleteButton addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    }

    return _deleteButton;
}


- (void)delete
{
    if ([self.delegate respondsToSelector:@selector(deleteItemAtIndexPath:)]) {
        [self.delegate deleteItemAtIndexPath:self.indexPath];
    }
}

@end

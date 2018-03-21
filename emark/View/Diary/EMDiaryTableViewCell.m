//
//  EMDiaryTableViewCell.m
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMDiaryTableViewCell.h"
#import "EMVerticallyAlignedLabel.h"

@interface EMDiaryTableViewCell()

@property (nonatomic, strong) EMVerticallyAlignedLabel *contentLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) UIImageView *picImageView;

@end

@implementation EMDiaryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        __weak typeof(self) weakSelf = self;
        [self.contentView addSubview:self.picImageView];
        [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView).with.offset(15);
            make.left.mas_equalTo(80);
            make.height.mas_equalTo(90);
            make.width.mas_equalTo(90);
        }];
        
        [self.contentView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(10);
            make.top.equalTo(weakSelf.contentView).with.offset(12);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
        }];
        
        [self.contentView addSubview:self.yearLabel];
        [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(13);
            make.top.equalTo(weakSelf.dateLabel.mas_bottom);
            make.width.mas_equalTo(57);
            make.height.mas_equalTo(30);
        }];
        
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(180);
            make.top.equalTo(weakSelf.contentView).with.offset(13);
            make.height.mas_equalTo(90);
            make.right.equalTo(weakSelf.contentView).with.offset(-15);
        }];
    }

    return self;
}


- (EMVerticallyAlignedLabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[EMVerticallyAlignedLabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:15.0];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = UIColorFromHexRGB(0x333333);
        [_contentLabel setVerticalAlignment:VerticalAlignmentTop];
    }

    return _contentLabel;
}


- (UIImageView *)picImageView
{
    if (!_picImageView) {
        _picImageView = [[UIImageView alloc] init];
        _picImageView.contentMode = UIViewContentModeScaleAspectFill;
        _picImageView.backgroundColor = [UIColor whiteColor];
        _picImageView.clipsToBounds = YES;
    }

    return _picImageView;
}


- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.numberOfLines = 1;
    }
    
    return _dateLabel;
}


- (UILabel *)yearLabel
{
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc] init];
        _yearLabel.numberOfLines = 1;
        _yearLabel.font = [UIFont systemFontOfSize:15.0];
        _yearLabel.textColor = UIColorFromHexRGB(0x333333);
    }
    
    return _yearLabel;
}


- (void)updateCellWithDiaryInfo:(EMDiaryInfo *)diaryInfo
{
    self.contentLabel.text = diaryInfo.diaryContent;
    self.dateLabel.attributedText = [self dateStrFormStr:diaryInfo.diaryDate];
    self.yearLabel.text = [diaryInfo.diaryDate substringWithRange:NSMakeRange(0, 4)];
    self.picImageView.image = diaryInfo.diaryMiddleImage;
}


- (NSAttributedString *)dateStrFormStr:(NSString *)dateStr
{
    NSString *dayStr = [dateStr substringWithRange:NSMakeRange(8, 2)];
    NSString *monthStr = [dateStr substringWithRange:NSMakeRange(5, 2)];
    NSMutableAttributedString *resultStr = [[NSMutableAttributedString alloc] initWithString:dayStr attributes:@{
                                                        NSFontAttributeName:[UIFont boldSystemFontOfSize:28]}];
    [resultStr appendAttributedString:[[NSAttributedString alloc] initWithString:monthStr attributes:@{
                                                                                                       NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}]];
    return resultStr;
}

@end

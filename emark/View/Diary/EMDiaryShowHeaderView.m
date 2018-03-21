//
//  EMDiaryShowHeaderView.m
//  emark
//
//  Created by neebel on 2017/5/31.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMDiaryShowHeaderView.h"

@interface EMDiaryShowHeaderView()

@property (nonatomic, strong) UILabel *dataLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *weekLabel;

@end

@implementation EMDiaryShowHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.dataLabel];
        __weak typeof(self) weakSelf = self;
        [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(15);
            make.right.equalTo(weakSelf.contentView).with.offset(-70);
            make.top.equalTo(weakSelf.contentView).with.offset(10);
            make.height.mas_equalTo(20);
        }];
        
        [self.contentView addSubview:self.weekLabel];
        [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView).with.offset(-15);
            make.top.equalTo(weakSelf.contentView).with.offset(10);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(20);
        }];
        
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(15);
            make.right.equalTo(weakSelf.contentView).with.offset(-15);
            make.top.equalTo(weakSelf.contentView).with.offset(30);
            make.bottom.equalTo(weakSelf.contentView);
        }];
    }
    
    return self;
}


- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:15.0];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = UIColorFromHexRGB(0x333333);
    }
    
    return _contentLabel;
}


- (UILabel *)dataLabel
{
    if (!_dataLabel) {
        _dataLabel = [[UILabel alloc] init];
        _dataLabel.font = [UIFont boldSystemFontOfSize:15.0];
        _dataLabel.numberOfLines = 1;
        _dataLabel.textColor = UIColorFromHexRGB(0x333333);
    }
    
    return _dataLabel;
}


- (UILabel *)weekLabel
{
    if (!_weekLabel) {
        _weekLabel = [[UILabel alloc] init];
        _weekLabel.font = [UIFont boldSystemFontOfSize:15.0];
        _weekLabel.numberOfLines = 1;
        _weekLabel.textAlignment = NSTextAlignmentRight;
        _weekLabel.textColor = UIColorFromHexRGB(0x333333);
    }
    
    return _weekLabel;
}


- (void)updateViewWithDiaryInfo:(EMDiaryInfo *)diaryInfo;
{
    self.contentLabel.text = diaryInfo.diaryContent;
    self.dataLabel.text = diaryInfo.diaryDate;
    self.weekLabel.text = [self transformDateToWeek:diaryInfo.diaryDate];
}


- (NSString *)transformDateToWeek:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    return [self weekdayStringFromDate:date];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (NSString *)weekdayStringFromDate:(NSDate *)inputDate
{
    NSArray *weekdays = [NSArray arrayWithObjects:[NSNull null], NSLocalizedString(@"周日", nil), NSLocalizedString(@"周一", nil), NSLocalizedString(@"周二", nil), NSLocalizedString(@"周三", nil), NSLocalizedString(@"周四", nil), NSLocalizedString(@"周五", nil), NSLocalizedString(@"周六", nil), nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

#pragma clang diagnostic pop

@end


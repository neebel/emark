//
//  EMBillTableViewCell.m
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBillTableViewCell.h"

@interface EMBillTableViewCell()

@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) UILabel  *countLabel;
@property (nonatomic, strong) UILabel  *typeLabel;
@property (nonatomic, strong) UIView   *bottomLine;

@end

@implementation EMBillTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.weekLabel];
        __weak typeof(self) weakSelf = self;
        [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(15);
            make.top.equalTo(weakSelf.contentView).with.offset(18);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(40);
        }];
        
        [self.contentView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.weekLabel.mas_bottom).with.offset(5);
            make.left.equalTo(weakSelf.contentView).with.offset(15);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(40);
        }];
        
        [self.contentView addSubview:self.picImageView];
        [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(75);
            make.centerY.equalTo(weakSelf.contentView);
            make.width.height.mas_equalTo(30);
        }];
        
        [self.contentView addSubview:self.countLabel];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(120);
            make.right.equalTo(weakSelf.contentView).with.offset(-10);
            make.top.equalTo(weakSelf.contentView).with.offset(12);
            make.height.mas_equalTo(20);
        }];
        
        [self.contentView addSubview:self.typeLabel];
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(120);
            make.right.equalTo(weakSelf.contentView).with.offset(-10);
            make.height.mas_equalTo(20);
            make.bottom.equalTo(weakSelf.contentView).with.offset(-12);
        }];
        
        [self.contentView addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(15);
            make.right.equalTo(weakSelf.contentView);
            make.bottom.equalTo(weakSelf.contentView);
            make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        }];
    }

    return self;
}


- (UILabel *)weekLabel
{
    if (!_weekLabel) {
        _weekLabel = [[UILabel alloc] init];
        _weekLabel.font = [UIFont systemFontOfSize:15.0];
        _weekLabel.numberOfLines = 1;
        _weekLabel.textColor = UIColorFromHexRGB(0x999999);
        _weekLabel.textAlignment = NSTextAlignmentCenter;
    }

    return _weekLabel;
}


- (UIImageView *)picImageView
{
    if (!_picImageView) {
        _picImageView = [[UIImageView alloc] init];
        _picImageView.contentMode = UIViewContentModeScaleToFill;
        _picImageView.clipsToBounds = YES;
    }

    return _picImageView;
}


- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:13.0];
        _dateLabel.textColor = UIColorFromHexRGB(0x999999);
        _dateLabel.numberOfLines = 1;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _dateLabel;
}


- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont systemFontOfSize:17.0];
        _countLabel.textColor = UIColorFromHexRGB(0x333333);
        _countLabel.numberOfLines = 1;
    }
    
    return _countLabel;
}


- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = [UIFont systemFontOfSize:13.0];
        _typeLabel.textColor = UIColorFromHexRGB(0x666666);
        _typeLabel.numberOfLines = 1;
    }
    
    return _typeLabel;
}


- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [EMTheme currentTheme].dividerColor;
    }

    return _bottomLine;
}


- (void)updateCellWithBillInfo:(EMBillInfo *)billInfo
{
    self.weekLabel.text = [self weekdayStringFromDate:billInfo.billDate];
    self.dateLabel.text = [self formateDate:billInfo.billDate];
    
    NSInteger type = (NSInteger)billInfo.billType;
    NSString *countStr = nil;
    if (type > 0 && type < 7) {
        countStr = [NSString stringWithFormat:@"-%.2f", billInfo.billCount];
    } else {
        countStr = [NSString stringWithFormat:@"+%.2f", billInfo.billCount];
    }
    
    self.countLabel.text = countStr;
    
    NSString *imageName = nil;
    NSString *billType = nil;
    switch (billInfo.billType) {
            
        case kEMBillTypePayEat:
            billType = NSLocalizedString(@"支出/吃", nil);
            imageName = @"billEat";
            break;
            
        case kEMBillTypePayClothe:
            billType = NSLocalizedString(@"支出/穿", nil);
            imageName = @"billClothe";
            break;
            
        case kEMBillTypePayLive:
            billType = NSLocalizedString(@"支出/住", nil);
            imageName = @"billLive";
            break;
            
        case kEMBillTypePayWalk:
            billType = NSLocalizedString(@"支出/行", nil);
            imageName = @"billWalk";
            break;
            
        case kEMBillTypePayPlay:
            billType = NSLocalizedString(@"支出/玩", nil);
            imageName = @"billPlay";
            break;
            
        case kEMBillTypePayOther:
            billType = NSLocalizedString(@"支出/其他", nil);
            imageName = @"billPayOther";
            break;
            
        case kEMBillTypeIncomeSalary:
            billType = NSLocalizedString(@"收入/工资", nil);
            imageName = @"billSalary";
            break;
            
        case kEMBillTypeIncomeAward:
            billType = NSLocalizedString(@"收入/奖金", nil);
            imageName = @"billAward";
            break;
            
        case kEMBillTypeIncomeExtra:
            billType = NSLocalizedString(@"收入/外快", nil);
            imageName = @"billExtra";
            break;
            
        case kEMBillTypeIncomeOther:
            billType = NSLocalizedString(@"收入/其他", nil);
            imageName = @"billPayOther";
            break;
            
        default:
            break;
    }
    
    if (billInfo.billRemark.length > 0) {
        billType = [NSString stringWithFormat:@"%@   %@", billType, billInfo.billRemark];
    }
    
    self.typeLabel.text = billType;
    self.picImageView.image = [UIImage imageNamed:imageName];
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

- (NSString *)formateDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd"];
    return [formatter stringFromDate:date];
}

@end

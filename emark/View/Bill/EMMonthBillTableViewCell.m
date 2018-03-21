//
//  EMMonthBillTableViewCell.m
//  emark
//
//  Created by neebel on 2017/6/6.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMMonthBillTableViewCell.h"
#import "PNChart.h"
#import "EMMonthBillLegend.h"

@interface EMMonthBillTableViewCell()

@property (nonatomic, strong) UIView  *dividerView;
@property (nonatomic, strong) UIView  *dividerLine;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) PNPieChart *pieChart;
@property (nonatomic, strong) EMMonthBillLegend *legend;
@property (nonatomic, strong) UIImageView *picImageView;

@end

@implementation EMMonthBillTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.dividerView];
        __weak typeof(self) weakSelf = self;
        [self.dividerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(weakSelf.contentView);
            make.height.mas_equalTo(20);
        }];
        
        [self.contentView addSubview:self.typeLabel];
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(17);
            make.top.equalTo(weakSelf.dividerView.mas_bottom);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(100);
        }];
        
        [self.contentView addSubview:self.countLabel];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView).with.offset(-10);
            make.top.equalTo(weakSelf.dividerView.mas_bottom);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(150);
        }];
        
        [self.contentView addSubview:self.dividerLine];
        [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.contentView).with.offset(17);
            make.top.equalTo(weakSelf.typeLabel.mas_bottom);
            make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        }];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return self;
}


- (UIView *)dividerView
{
    if (!_dividerView) {
        _dividerView = [[UIView alloc] init];
        _dividerView.backgroundColor = [EMTheme currentTheme].mainBGColor;
    }

    return _dividerView;
}


- (UIView *)dividerLine
{
    if (!_dividerLine) {
        _dividerLine = [[UIView alloc] init];
        _dividerLine.backgroundColor = [EMTheme currentTheme].dividerColor;
    }
    
    return _dividerLine;
}


- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _typeLabel.textColor = UIColorFromHexRGB(0x333333);
    }
    
    return _typeLabel;
}


- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont boldSystemFontOfSize:15.0];
        _countLabel.textColor = UIColorFromHexRGB(0x333333);
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return _countLabel;
}


- (EMMonthBillLegend *)legend
{
    if (!_legend) {
        _legend = [[EMMonthBillLegend alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    }

    return _legend;
}


- (UIImageView *)picImageView
{
    if (!_picImageView) {
        _picImageView = [[UIImageView alloc] init];
        _picImageView.contentMode = UIViewContentModeScaleAspectFit;
    }

    return _picImageView;
}


- (void)updateCellWithTitle:(NSString *)title monthInfo:(EMBillMonthInfo *)info
{
    self.typeLabel.text = title;
    
    if ([title isEqualToString:NSLocalizedString(@"总支出", nil)]) {
        double payCount = info.eat + info.clothe + info.live + info.walk + info.play + info.payOther;
        self.countLabel.text = [NSString stringWithFormat:@"-%.2f", payCount];
    } else {
        double incomeCout = info.salary + info.award + info.extra + info.incomeOther;
        self.countLabel.text = [NSString stringWithFormat:@"+%.2f", incomeCout];
    }
    
    NSArray *items = [self buildDataItems:info type:title];
    
    if (items.count > 0) {
        [self.picImageView removeFromSuperview];
        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 0, 200, 200) items:items];
        self.pieChart.hideValues = YES;
        self.pieChart.descriptionTextColor = [UIColor clearColor];
        [self.contentView addSubview:self.pieChart];
        __weak typeof(self) weakSelf = self;
        CGFloat pieHeight = [self pieHeight];
        [self.pieChart mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(15);
            make.bottom.equalTo(weakSelf.contentView).with.offset(-45);
            make.height.mas_equalTo(pieHeight);
            make.width.mas_equalTo(pieHeight);
        }];
        
        [self.contentView addSubview:self.legend];
        CGFloat legendHeight = pieHeight;
        if ([title isEqualToString:NSLocalizedString(@"总收入", nil)]) {
            legendHeight = pieHeight * 2 / 3;
        }
        [self.legend mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView).with.offset(-10);
            make.centerY.equalTo(weakSelf.pieChart);
            make.left.equalTo(weakSelf.pieChart.mas_right).with.offset(30);
            make.height.mas_equalTo(legendHeight);
        }];
        
        [self.legend updateViewWithType:title billInfo:info];
    } else {
        //添加提示页 没有记录
        [self.contentView addSubview:self.picImageView];
        __weak typeof(self) weakSelf = self;
        [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(300);
            make.height.mas_equalTo(200);
            make.centerX.equalTo(weakSelf.contentView);
            make.bottom.equalTo(weakSelf.contentView).with.offset(-45);
        }];
        
        if ([title isEqualToString:NSLocalizedString(@"总收入", nil)]) {
            self.picImageView.image = [UIImage imageNamed:@"monthBillNoRecordIncome"];
        } else {
            self.picImageView.image = [UIImage imageNamed:@"monthBillNoRecordPay"];
        }
    }
}


- (NSArray *)buildDataItems:(EMBillMonthInfo *)monthInfo type:(NSString *)type
{
    if ([type isEqualToString:NSLocalizedString(@"总支出", nil)]) {
        NSMutableArray *items = [NSMutableArray array];
        if (monthInfo.eat > 0) {
            PNPieChartDataItem *eatItem = [PNPieChartDataItem dataItemWithValue:monthInfo.eat
                                                                          color:UIColorFromHexRGB(0x00BEFE)
                                                                    description:NSLocalizedString(@"吃", nil)];
            [items addObject:eatItem];
        }
        
        if (monthInfo.clothe > 0) {
            PNPieChartDataItem *clotheItem = [PNPieChartDataItem dataItemWithValue:monthInfo.clothe
                                                                             color:UIColorFromHexRGB(0xFD2B61)
                                                                       description:NSLocalizedString(@"穿", nil)];
            [items addObject:clotheItem];
        }
        
        if (monthInfo.live > 0) {
            PNPieChartDataItem *liveItem = [PNPieChartDataItem dataItemWithValue:monthInfo.live
                                                                           color:UIColorFromHexRGB(0x7ABA00)
                                                                     description:NSLocalizedString(@"住", nil)];
            [items addObject:liveItem];
        }
        
        if (monthInfo.walk > 0) {
            PNPieChartDataItem *walkItem = [PNPieChartDataItem dataItemWithValue:monthInfo.walk
                                                                           color:UIColorFromHexRGB(0xFF8001)
                                                                     description:NSLocalizedString(@"行", nil)];
            [items addObject:walkItem];
        }
        
        if (monthInfo.play > 0) {
            PNPieChartDataItem *playItem = [PNPieChartDataItem dataItemWithValue:monthInfo.play
                                                                           color:UIColorFromHexRGB(0xB01F00)
                                                                     description:NSLocalizedString(@"玩", nil)];
            [items addObject:playItem];
        }
        
        if (monthInfo.payOther > 0) {
            PNPieChartDataItem *otherItem = [PNPieChartDataItem dataItemWithValue:monthInfo.payOther
                                                                            color:UIColorFromHexRGB(0x8C88FE)
                                                                      description:NSLocalizedString(@"其他", nil)];
            [items addObject:otherItem];
        }
        
        return items;
    } else {
        NSMutableArray *items = [NSMutableArray array];
        
        if (monthInfo.salary > 0) {
            PNPieChartDataItem *salaryItem = [PNPieChartDataItem dataItemWithValue:monthInfo.salary
                                                                             color:UIColorFromHexRGB(0x00BEFE)
                                                                       description:NSLocalizedString(@"工资", nil)];
            [items addObject:salaryItem];
        }
        
        if (monthInfo.award > 0) {
            PNPieChartDataItem *awardItem = [PNPieChartDataItem dataItemWithValue:monthInfo.award
                                                                            color:UIColorFromHexRGB(0xFD2B61)
                                                                      description:NSLocalizedString(@"奖金", nil)];
            [items addObject:awardItem];
        }
        
        if (monthInfo.extra > 0) {
            PNPieChartDataItem *extra = [PNPieChartDataItem dataItemWithValue:monthInfo.extra
                                                                        color:UIColorFromHexRGB(0x7ABA00)
                                                                  description:NSLocalizedString(@"外快", nil)];
            [items addObject:extra];
        }
        
        if (monthInfo.incomeOther > 0) {
            PNPieChartDataItem *other = [PNPieChartDataItem dataItemWithValue:monthInfo.incomeOther
                                                                        color:UIColorFromHexRGB(0xFF8001)
                                                                  description:NSLocalizedString(@"其他", nil)];
            [items addObject:other];
        }
        
        return items;
    }
}


- (CGFloat)pieHeight
{
    if (IS_3_5_INCH || IS_4_0_INCH) {
        return 140;
    } else if (IS_4_7_INCH) {
        return 170;
    } else {
        return 200;
    }
}

@end

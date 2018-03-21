//
//  EMMonthBillLegend.m
//  emark
//
//  Created by neebel on 2017/6/8.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMMonthBillLegend.h"

@interface EMMonthBillLegend()

@property (nonatomic, strong) UIView *firstView;
@property (nonatomic, strong) UIView *secondView;
@property (nonatomic, strong) UIView *thirdView;
@property (nonatomic, strong) UIView *fourthView;
@property (nonatomic, strong) UIView *fifthView;
@property (nonatomic, strong) UIView *sixthView;

@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *thirdLabel;
@property (nonatomic, strong) UILabel *fourthLabel;
@property (nonatomic, strong) UILabel *fifthLabel;
@property (nonatomic, strong) UILabel *sixthLabel;

@end

@implementation EMMonthBillLegend

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat labelHeight = [self pieHeight] / 6;
        CGFloat dividerHeight = labelHeight - 10;
        __weak typeof(self) weakSelf = self;
        self.firstView = [self buildView];
        [self addSubview:self.firstView];
        [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(10);
            make.left.equalTo(weakSelf);
            make.top.equalTo(weakSelf).with.offset(dividerHeight/2);
        }];
        self.firstLabel = [self buildLabel];
        [self addSubview:self.firstLabel];
        [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(weakSelf);
            make.height.mas_equalTo(labelHeight);
            make.left.equalTo(weakSelf.firstView.mas_right).with.offset(5);
        }];
        
        self.secondView = [self buildView];
        [self addSubview:self.secondView];
        [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(10);
            make.left.equalTo(weakSelf);
            make.top.equalTo(weakSelf.firstView.mas_bottom).with.offset(dividerHeight);
        }];
        self.secondLabel = [self buildLabel];
        [self addSubview:self.secondLabel];
        [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf);
            make.top.equalTo(weakSelf.firstLabel.mas_bottom);
            make.height.mas_equalTo(labelHeight);
            make.left.equalTo(weakSelf.secondView.mas_right).with.offset(5);
        }];

        self.thirdView = [self buildView];
        [self addSubview:self.thirdView];
        [self.thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(10);
            make.left.equalTo(weakSelf);
            make.top.equalTo(weakSelf.secondView.mas_bottom).with.offset(dividerHeight);
        }];
        self.thirdLabel = [self buildLabel];
        [self addSubview:self.thirdLabel];
        [self.thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf);
            make.top.equalTo(weakSelf.secondLabel.mas_bottom);
            make.height.mas_equalTo(labelHeight);
            make.left.equalTo(weakSelf.thirdView.mas_right).with.offset(5);
        }];

        self.fourthView = [self buildView];
        [self addSubview:self.fourthView];
        [self.fourthView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(10);
            make.left.equalTo(weakSelf);
            make.top.equalTo(weakSelf.thirdView.mas_bottom).with.offset(dividerHeight);
        }];
        self.fourthLabel = [self buildLabel];
        [self addSubview:self.fourthLabel];
        [self.fourthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf);
            make.top.equalTo(weakSelf.thirdLabel.mas_bottom);
            make.height.mas_equalTo(labelHeight);
            make.left.equalTo(weakSelf.fourthView.mas_right).with.offset(5);
        }];

        self.fifthView = [self buildView];
        [self addSubview:self.fifthView];
        [self.fifthView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(10);
            make.left.equalTo(weakSelf);
            make.top.equalTo(weakSelf.fourthView.mas_bottom).with.offset(dividerHeight);
        }];
        self.fifthLabel = [self buildLabel];
        [self addSubview:self.fifthLabel];
        [self.fifthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf);
            make.top.equalTo(weakSelf.fourthLabel.mas_bottom);
            make.height.mas_equalTo(labelHeight);
            make.left.equalTo(weakSelf.fifthView.mas_right).with.offset(5);
        }];

        self.sixthView = [self buildView];
        [self addSubview:self.sixthView];
        [self.sixthView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(10);
            make.left.equalTo(weakSelf);
            make.top.equalTo(weakSelf.fifthView.mas_bottom).with.offset(dividerHeight);
        }];
        self.sixthLabel = [self buildLabel];
        [self addSubview:self.sixthLabel];
        [self.sixthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf);
            make.top.equalTo(weakSelf.fifthLabel.mas_bottom);
            make.height.mas_equalTo(labelHeight);
            make.left.equalTo(weakSelf.sixthView.mas_right).with.offset(5);
        }];
    }
    
    return self;
}


- (UIView *)buildView
{
    UIView *view = [[UIView alloc] init];
    return view;
}


- (UILabel *)buildLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColorFromHexRGB(0x333333);
    if (IS_3_5_INCH || IS_4_0_INCH) {
        label.font = [UIFont systemFontOfSize:12.0];
    } else {
        label.font = [UIFont systemFontOfSize:14.0];
    }
    
    return label;
}


- (void)updateViewWithType:(NSString *)type billInfo:(EMBillMonthInfo *)info
{
    self.firstView.backgroundColor = UIColorFromHexRGB(0x00BEFE);
    self.secondView.backgroundColor = UIColorFromHexRGB(0xFD2B61);
    self.thirdView.backgroundColor = UIColorFromHexRGB(0x7ABA00);
    self.fourthView.backgroundColor = UIColorFromHexRGB(0xFF8001);
    
    if ([type isEqualToString:NSLocalizedString(@"总支出", nil)]) {
        self.fifthView.hidden = NO;
        self.sixthView.hidden = NO;
        self.fifthLabel.hidden = NO;
        self.sixthLabel.hidden = NO;
        self.fifthView.backgroundColor = UIColorFromHexRGB(0xB01F00);
        self.sixthView.backgroundColor = UIColorFromHexRGB(0x8C88FE);
        
        self.firstLabel.text = [NSString stringWithFormat:@"%@  %.2f", NSLocalizedString(@"吃", nil), info.eat];
        self.secondLabel.text = [NSString stringWithFormat:@"%@  %.2f", NSLocalizedString(@"穿", nil), info.clothe];
        self.thirdLabel.text = [NSString stringWithFormat:@"%@  %.2f", NSLocalizedString(@"住", nil), info.live];
        self.fourthLabel.text = [NSString stringWithFormat:@"%@  %.2f", NSLocalizedString(@"行", nil), info.walk];
        self.fifthLabel.text = [NSString stringWithFormat:@"%@  %.2f", NSLocalizedString(@"玩", nil), info.play];
        self.sixthLabel.text = [NSString stringWithFormat:@"%@  %.2f", NSLocalizedString(@"其他", nil), info.payOther];
        
    } else {
        self.fifthView.hidden = YES;
        self.sixthView.hidden = YES;
        self.fifthLabel.hidden = YES;
        self.sixthLabel.hidden = YES;
        
        self.firstLabel.text = [NSString stringWithFormat:@"%@  %.2f", NSLocalizedString(@"工资", nil), info.salary];
        self.secondLabel.text = [NSString stringWithFormat:@"%@  %.2f", NSLocalizedString(@"奖金", nil), info.award];
        self.thirdLabel.text = [NSString stringWithFormat:@"%@  %.2f", NSLocalizedString(@"外快", nil), info.extra];
        self.fourthLabel.text = [NSString stringWithFormat:@"%@  %.2f", NSLocalizedString(@"其他", nil), info.incomeOther];
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

//
//  EMDatePicker.m
//  emark
//
//  Created by neebel on 2017/6/1.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMDatePicker.h"
#import "EMToolbar.h"

@interface EMDatePicker()<EMToolbarDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *tapView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) EMToolbar *toolbar;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation EMDatePicker

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    
    return self;
}

#pragma mark - Private

- (void)initUI
{
    [self.bgView addSubview:self.tapView];
    [self.contentView addSubview:self.datePicker];
    [self.contentView addSubview:self.toolbar];
    [self.bgView addSubview:self.contentView];

}

#pragma mark - Getter & Setter

- (UIView *)bgView
{
    if (!_bgView) {
        CGRect rect = [UIApplication sharedApplication].delegate.window.bounds;
        _bgView = [[UIView alloc] initWithFrame:rect];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    }
    
    return _bgView;
}


- (UIView *)tapView
{
    if (!_tapView) {
        CGRect rect = [UIApplication sharedApplication].delegate.window.bounds;
        _tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height - 216)];
        _tapView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _tapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_tapView addGestureRecognizer:gesture];
    }
    
    return _tapView;
}


- (UIView *)contentView
{
    if (!_contentView) {
        CGRect rect = [UIApplication sharedApplication].delegate.window.bounds;
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height, rect.size.width, 216)];
        _contentView.backgroundColor = [UIColor whiteColor];
    }

    return _contentView;
}


- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        CGRect rect = [UIApplication sharedApplication].delegate.window.bounds;
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 216)];
        _datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_datePicker addTarget:self
                            action:@selector(changeTime:)
                  forControlEvents:UIControlEventValueChanged];
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }

    return _datePicker;
}


- (EMToolbar *)toolbar
{
    if (!_toolbar) {
        CGRect rect = [UIApplication sharedApplication].delegate.window.bounds;
        _toolbar = [[EMToolbar alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 43) leftButtonTitle:NSLocalizedString(@"取消", nil) middleLabel:NSLocalizedString(@"选择日期", nil) rightButtonTitle:NSLocalizedString(@"确定", nil)];
        _toolbar.toolbarDelegate = self;
    }
    
    return _toolbar;
}


- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
    self.datePicker.datePickerMode = datePickerMode;
}


- (void)setMinimumDate:(NSDate *)minimumDate
{
    self.datePicker.minimumDate = minimumDate;

}

#pragma mark - Public

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.bgView];
    CGRect frame = self.contentView.frame;
    CGRect rect = [UIApplication sharedApplication].delegate.window.bounds;
    frame.origin.y = rect.size.height - frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = frame;
    } completion:nil];
}


- (void)dismiss
{
    CGRect frame = self.contentView.frame;
    CGRect rect = [UIApplication sharedApplication].delegate.window.bounds;
    frame.origin.y = rect.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
    }];
}

#pragma mark - Action

- (void)changeTime:(UIDatePicker *)datePicker
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeTime:)]) {
        [self.delegate changeTime:datePicker];
    }
}

#pragma mark - EMToolbarDelegate

- (void)leftButtonAction
{
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(leftButtonAction)]) {
        [self.delegate leftButtonAction];
    }
}


- (void)rightButtonAction
{
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(rightButtonAction)]) {
        [self.delegate rightButtonAction];
    }
}

@end

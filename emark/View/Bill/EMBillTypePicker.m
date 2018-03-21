//
//  EMBillTypePicker.m
//  emark
//
//  Created by neebel on 2017/6/5.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBillTypePicker.h"
#import "EMToolbar.h"
#import "EMBillTypeInfo.h"

@interface EMBillTypePicker()<EMToolbarDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *tapView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) EMToolbar *toolbar;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *typeItems;

@end

@implementation EMBillTypePicker

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
    [self.contentView addSubview:self.pickerView];
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


- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        CGRect rect = [UIApplication sharedApplication].delegate.window.bounds;
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 216)];
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }

    return _pickerView;
}


- (EMToolbar *)toolbar
{
    if (!_toolbar) {
        CGRect rect = [UIApplication sharedApplication].delegate.window.bounds;
        _toolbar = [[EMToolbar alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 43) leftButtonTitle:NSLocalizedString(@"取消", nil) middleLabel:NSLocalizedString(@"选择类型", nil) rightButtonTitle:NSLocalizedString(@"确定", nil)];
        _toolbar.toolbarDelegate = self;
    }
    
    return _toolbar;
}


- (NSArray *)typeItems
{
    if (!_typeItems) {
        EMBillTypeInfo *payInfo = [[EMBillTypeInfo alloc] init];
        payInfo.groupName = NSLocalizedString(@"支出", nil);
        payInfo.groupItems = @[NSLocalizedString(@"吃", nil), NSLocalizedString(@"穿", nil), NSLocalizedString(@"住", nil), NSLocalizedString(@"行", nil), NSLocalizedString(@"玩", nil), NSLocalizedString(@"其他", nil)];
        
        EMBillTypeInfo *incomeInfo = [[EMBillTypeInfo alloc] init];
        incomeInfo.groupName = NSLocalizedString(@"收入", nil);
        incomeInfo.groupItems = @[NSLocalizedString(@"工资", nil), NSLocalizedString(@"奖金", nil), NSLocalizedString(@"外快", nil), NSLocalizedString(@"其他", nil)];
        _typeItems = @[payInfo, incomeInfo];
    }

    return _typeItems;
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


#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.typeItems.count;
    } else {
        NSInteger selRow = [pickerView selectedRowInComponent:0];
        EMBillTypeInfo *info = self.typeItems[selRow];
        return info.groupItems.count;
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        EMBillTypeInfo *info = self.typeItems[row];
        return info.groupName;
    } else {
        NSInteger selRow = [pickerView selectedRowInComponent:0];
        EMBillTypeInfo *info = self.typeItems[selRow];
        return info.groupItems[row];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        //重新加载第二列的数据
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    
    NSInteger typeRow = [pickerView selectedRowInComponent:0];
    EMBillTypeInfo *info = self.typeItems[typeRow];
    NSString *type = info.groupName;
    
    NSInteger subTypeRow = [pickerView selectedRowInComponent:1];
    NSString *subType = info.groupItems[subTypeRow];
    
    if ([self.delegate respondsToSelector:@selector(pickerViewDidSelectType:subType:)]) {
        [self.delegate pickerViewDidSelectType:type subType:subType];
    }
}

@end

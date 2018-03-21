//
//  EMPlacePublishSheet.m
//  emark
//
//  Created by neebel on 2017/6/2.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMPlacePublishSheet.h"
#import "EMTextField.h"

@interface EMPlacePublishSheet()

@property (nonatomic, strong) UIView      *bgView;
@property (nonatomic, strong) UIView      *tapView;
@property (nonatomic, strong) UIView      *contentView;
@property (nonatomic, strong) EMTextField *nameTextField;
@property (nonatomic, strong) EMTextField *whereTextField;
@property (nonatomic, strong) UIButton    *cancelButton;
@property (nonatomic, strong) UIButton    *confirmButton;

@end

@implementation EMPlacePublishSheet

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
    [self.contentView addSubview:self.nameTextField];
    __weak typeof(self) weakSelf = self;
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.top.equalTo(weakSelf.contentView).with.offset(50);
        make.left.equalTo(weakSelf.contentView).with.offset(30);
        make.right.equalTo(weakSelf.contentView).with.offset(-30);
    }];
    
    [self.contentView addSubview:self.whereTextField];
    
    [self.whereTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.top.equalTo(weakSelf.nameTextField.mas_bottom).with.offset(30);
        make.left.equalTo(weakSelf.contentView).with.offset(30);
        make.right.equalTo(weakSelf.contentView).with.offset(-30);
    }];
    
    [self.contentView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.left.equalTo(weakSelf.contentView).with.offset(20);
        make.bottom.equalTo(weakSelf.contentView).with.offset(- 10);
    }];

    [self.contentView addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
        make.right.equalTo(weakSelf.contentView).with.offset(-5);
        make.bottom.equalTo(weakSelf.contentView).with.offset(10);
    }];
    
    [self.bgView addSubview:self.contentView];
}


- (void)cancel
{
    [self dismiss];
}


- (void)confirm
{
    if (self.nameTextField.textField.text.length == 0) {
        [EMTips show:NSLocalizedString(@"请输入物品名称", nil)];
        return;
    }
    
    if (self.whereTextField.textField.text.length == 0) {
        [EMTips show:NSLocalizedString(@"请输入物品放置位置", nil)];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(confirmWithPlaceInfo:)]) {
        EMPlaceInfo *placeInfo = [[EMPlaceInfo alloc] init];
        placeInfo.goodsName = self.nameTextField.textField.text;
        placeInfo.placeName = self.whereTextField.textField.text;
        [self.delegate confirmWithPlaceInfo:placeInfo];
    }
}

#pragma mark - Getter

- (UIView *)bgView
{
    if (!_bgView) {
        CGRect rect = [UIApplication sharedApplication].delegate.window.bounds;
        _bgView = [[UIView alloc] initWithFrame:rect];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    
    return _bgView;
}


- (UIView *)tapView
{
    if (!_tapView) {
        CGRect rect = [UIApplication sharedApplication].delegate.window.bounds;
        _tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 210, rect.size.width, rect.size.height - 210)];
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
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, -210, rect.size.width, 210)];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _contentView.backgroundColor = [EMTheme currentTheme].navBarBGColor;
    }
    
    return _contentView;
}


- (EMTextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [[EMTextField alloc] init];
        _nameTextField.ly_placeholder = NSLocalizedString(@"物品名称", nil);
        _nameTextField.placeholderSelectStateColor = UIColorFromHexRGB(0x7ABA00);
    }

    return _nameTextField;
}


- (EMTextField *)whereTextField
{
    if (!_whereTextField) {
        _whereTextField = [[EMTextField alloc] init];
        _whereTextField.ly_placeholder = NSLocalizedString(@"放哪里", nil);
        _whereTextField.placeholderSelectStateColor = UIColorFromHexRGB(0x7ABA00);
    }
    
    return _whereTextField;
}


- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_cancelButton setImage:[UIImage imageNamed:@"placePublishCancel"]
                        forState:UIControlStateNormal];
        _cancelButton.contentMode = UIViewContentModeScaleToFill;
        [_cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelButton;
}


- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_confirmButton setImage:[UIImage imageNamed:@"placePublishConfirm"]
                        forState:UIControlStateNormal];
        _confirmButton.contentMode = UIViewContentModeCenter;
        [_confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        
    }

    return _confirmButton;
}

#pragma mark - Public

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.bgView];
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = frame;
    } completion:nil];
}


- (void)dismiss
{
    [self.nameTextField.textField resignFirstResponder];
    [self.whereTextField.textField resignFirstResponder];
    
    CGRect frame = self.contentView.frame;
    frame.origin.y = -210;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
    }];
}

@end

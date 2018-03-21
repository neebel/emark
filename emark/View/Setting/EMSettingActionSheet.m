//
//  EMSettingActionSheet.m
//  emark
//
//  Created by neebel on 2017/5/28.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMSettingActionSheet.h"
#import "EMSettingActionCell.h"

@interface EMSettingActionSheet()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView      *bgView;
@property (nonatomic, strong) UIView      *tapView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray     *itemArr;

@end

static NSString *settingSelectHeadCellIdentifier = @"settingSelectHeadCellIdentifier";

@implementation EMSettingActionSheet

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }

    return self;
}

#pragma mark - Action

- (void)takePhoto
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(takePhoto)]) {
        [self.delegate takePhoto];
    }
}


- (void)selectFromAlbum
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchFromAlbum)]) {
        [self.delegate searchFromAlbum];
    }
}

#pragma mark - Private

- (void)initUI
{
    [self.bgView addSubview:self.tapView];
    [self.bgView addSubview:self.tableView];
}

#pragma mark - Getter

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
        _tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height - 159)];
        _tapView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _tapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_tapView addGestureRecognizer:gesture];
    }

    return _tapView;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        CGRect rect = [UIApplication sharedApplication].delegate.window.bounds;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, rect.size.height, rect.size.width, 159)
                                                  style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[EMSettingActionCell class]
           forCellReuseIdentifier:settingSelectHeadCellIdentifier];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    return _tableView;
}


- (NSArray *)itemArr
{
    if (!_itemArr) {
        NSArray *selectArr = @[NSLocalizedString(@"拍照", nil), NSLocalizedString(@"从手机相册选择", nil)];
        NSArray *cancelArr = @[NSLocalizedString(@"取消", nil)];
        _itemArr = @[selectArr, cancelArr];
    }

    return _itemArr;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.itemArr.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.itemArr[section]).count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMSettingActionCell *cell = [tableView dequeueReusableCellWithIdentifier:settingSelectHeadCellIdentifier];
    NSString *title = ((NSArray *)self.itemArr[indexPath.section])[indexPath.row];
    [cell updateCellWithTitle:title];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 0.000001 : 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] init];
    return sectionView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismiss];
    NSString *title = ((NSArray *)self.itemArr[indexPath.section])[indexPath.row];
    if ([title isEqualToString:NSLocalizedString(@"拍照", nil)]) {
        [self takePhoto];
    } else if ([title isEqualToString:NSLocalizedString(@"从手机相册选择", nil)]) {
        [self selectFromAlbum];
    }
}

#pragma mark - Public

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.bgView];
    CGRect frame = self.tableView.frame;
    CGRect rect = [UIApplication sharedApplication].delegate.window.bounds;
    frame.origin.y = rect.size.height - frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = frame;
    } completion:nil];
}


- (void)dismiss
{
    CGRect frame = self.tableView.frame;
    CGRect rect = [UIApplication sharedApplication].delegate.window.bounds;
    frame.origin.y = rect.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
    }];
}

@end

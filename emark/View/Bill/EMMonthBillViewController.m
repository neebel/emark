//
//  EMMonthBillViewController.m
//  emark
//
//  Created by neebel on 2017/6/6.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMMonthBillViewController.h"
#import "EMMonthBillTableViewCell.h"
#import "EMBillManager.h"
#import "UIView+EMTips.h"

@interface EMMonthBillViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EMBillMonthInfo *monthInfo;

@end

static NSString *monthBillTableViewCellIdentifier = @"monthBillTableViewCellIdentifier";

@implementation EMMonthBillViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    [self loadData];
}

#pragma mark - Private

- (void)initUI
{
    self.view.backgroundColor = [EMTheme currentTheme].mainBGColor;
    self.title = NSLocalizedString(@"月账单", nil);
    [self.view addSubview:self.tableView];
}


- (void)loadData
{
    [self.view showMaskLoadingTips:nil style:kLogoLoopGray];
    __weak typeof(self) weakSelf = self;
    [[EMBillManager sharedManager] fetchMonthBillInMonth:self.monthStr result:^(EMResult *result) {
        [weakSelf.view hideManualTips];
        weakSelf.monthInfo = result.result;
        [weakSelf.tableView reloadData];
    }];
}


- (CGFloat)cellHeight
{
    if (IS_3_5_INCH || IS_4_0_INCH) {
        return 300;
    } else if (IS_4_7_INCH) {
        return 340;
    } else {
        return 360;
    }
}

#pragma mark - Getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [EMTheme currentTheme].mainBGColor;
        [_tableView registerClass:[EMMonthBillTableViewCell class]
           forCellReuseIdentifier:monthBillTableViewCellIdentifier];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = view;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeight];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMMonthBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:monthBillTableViewCellIdentifier
                                                                forIndexPath:indexPath];
    NSString *type = nil;
    if (indexPath.row == 0) {
        type = NSLocalizedString(@"总支出", nil);
    } else {
        type = NSLocalizedString(@"总收入", nil);
    }
    
    [cell updateCellWithTitle:type monthInfo:self.monthInfo];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

@end

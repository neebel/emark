//
//  EMBillViewController.m
//  emark
//
//  Created by neebel on 2017/6/5.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBillViewController.h"
#import "EMPublishBillViewController.h"
#import "EMBaseNavigationController.h"
#import "EMBillManager.h"
#import "EMBillTableViewCell.h"
#import "EMBillHeaderView.h"
#import "UIView+EMTips.h"
#import "EMMonthBillViewController.h"
#import "MJRefresh.h"
#import "EMMaskView.h"

@interface EMBillViewController ()<UITableViewDelegate, UITableViewDataSource, EMBillHeaderViewDelegate>

@property (nonatomic, strong) UIButton *publishButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray     *billInfos;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *refreshFooter;
@property (nonatomic, strong) EMMaskView  *maskView;

@end

static NSString *billTableViewCellIdentifier = @"billTableViewCellIdentifier";
static NSString *billTableViewHeaderIdentifier = @"billTableViewHeaderIdentifier";

@implementation EMBillViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:billPublishSuccessNotification
                                               object:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

- (void)initUI
{
    self.title = NSLocalizedString(@"账单", nil);
    self.view.backgroundColor = [EMTheme currentTheme].mainBGColor;
    UIBarButtonItem *publishButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.publishButton];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                           target:nil
                                                                           action:nil];
    space.width = - 20;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:space, publishButtonItem, nil];
    
    [self.view addSubview:self.tableView];
    self.tableView.mj_footer = self.refreshFooter;
}


- (void)loadData
{
    [self.view showMaskLoadingTips:nil style:kLogoLoopGray];
    __weak typeof(self) weakSelf = self;
    [[EMBillManager sharedManager] fetchBillInfosBeforeDate:nil totalCount:20 result:^(EMResult *result) {
        [weakSelf.view hideManualTips];
        weakSelf.billInfos = result.result;
        if (weakSelf.billInfos.count > 0) {
            [weakSelf.tableView reloadData];
            [weakSelf checkHasMore:result];
        } else {
            [weakSelf.maskView show];
        }
        
        [weakSelf.tableView setContentOffset:CGPointMake(0,0) animated:NO];//回到顶部
    }];
}


- (void)loadMoreData
{
    NSArray *arr = self.billInfos.lastObject;
    EMBillInfo *billInfo = arr.lastObject;
    __weak typeof(self) weakSelf = self;
    [[EMBillManager sharedManager] fetchBillInfosBeforeDate:billInfo.billDate totalCount:20 result:^(EMResult *result) {
        [weakSelf addInfos:result];
        [weakSelf.tableView reloadData];
        [weakSelf checkHasMore:result];
    }];
}


- (void)checkHasMore:(EMResult *)result
{
    NSInteger totalCount = 0;
    for (NSArray *arr in result.result) {
        totalCount += arr.count;
    }
    
    if (totalCount == 20) {
        [self.tableView.mj_footer endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}


- (void)addInfos:(EMResult *)result
{
    if (((NSArray *)result.result).count == 0) {
        return;
    }
    
    NSArray *arr = self.billInfos.lastObject;
    EMBillInfo *info = arr.lastObject;
    
    NSArray *newArr = ((NSArray *)result.result).firstObject;
    EMBillInfo *newInfo = newArr.firstObject;
    if ([self isMonth:info.billDate inMonth:newInfo.billDate]) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.billInfos.lastObject];
        for (EMBillInfo *info in newArr) {
            [arr addObject:info];
        }
        NSMutableArray *tmpBillInfos = [NSMutableArray arrayWithArray:self.billInfos];
        [tmpBillInfos removeLastObject];
        [tmpBillInfos addObject:arr];
        
        for (NSInteger i = 1; i < ((NSArray *)result.result).count; i++) {
            [tmpBillInfos addObject:((NSArray *)result.result)[i]];
        }
        
        self.billInfos = tmpBillInfos;
        
    } else {
        NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.billInfos];
        for (NSArray *arr in (NSArray *)result.result) {
            [tmpArr addObject:arr];
        }
        self.billInfos = tmpArr;
    }
}


//判断两个时间是否是同一个月
- (BOOL)isMonth:(NSDate *)date1 inMonth:(NSDate *)date2
{
    if (nil == date1 || nil == date2) {
        return NO;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *date1Str = [formatter stringFromDate:date1];
    NSString *date2Str = [formatter stringFromDate:date2];
    return [date1Str isEqualToString:date2Str];
}

#pragma mark - Getter

- (UIButton *)publishButton
{
    if (!_publishButton) {
        _publishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        [_publishButton setImage:[UIImage imageNamed:@"publishDiary"]
                        forState:UIControlStateNormal];
        [_publishButton addTarget:self action:@selector(publishBill) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _publishButton;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[EMBillTableViewCell class]
           forCellReuseIdentifier:billTableViewCellIdentifier];
        [_tableView registerClass:[EMBillHeaderView class]
forHeaderFooterViewReuseIdentifier:billTableViewHeaderIdentifier];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = view;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}


- (NSDateFormatter *)formatter
{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"YYYY/MM"];
    }

    return _formatter;
}


- (MJRefreshAutoNormalFooter *)refreshFooter
{
    if (!_refreshFooter) {
        __weak typeof(self) weakSelf = self;
        _refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
        [_refreshFooter setTitle:NSLocalizedString(@"点击或上拉加载更多", nil) forState:MJRefreshStateIdle];
        [_refreshFooter setTitle:NSLocalizedString(@"正在玩命加载...", nil) forState:MJRefreshStateRefreshing];
        [_refreshFooter setTitle:NSLocalizedString(@"没有更多了", nil) forState:MJRefreshStateNoMoreData];
        _refreshFooter.stateLabel.font = [UIFont systemFontOfSize:15];
        _refreshFooter.stateLabel.textColor = UIColorFromHexRGB(0x999999);
        [_refreshFooter setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    }
    
    return _refreshFooter;
}


- (EMMaskView *)maskView
{
    if (!_maskView) {
        _maskView = [[EMMaskView alloc] init];
    }

    return _maskView;
}

#pragma mark - Action

- (void)publishBill
{
    EMPublishBillViewController *vc = [[EMPublishBillViewController alloc] init];
    EMBaseNavigationController *nav = [[EMBaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.billInfos.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.billInfos[section]).count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *infoArr = self.billInfos[indexPath.section];
    EMBillInfo *info = infoArr[indexPath.row];
    EMBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:billTableViewCellIdentifier
                                    forIndexPath:indexPath];
    [cell updateCellWithBillInfo:info];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    EMBillHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:billTableViewHeaderIdentifier];
    NSArray *infoArr = self.billInfos[section];
    EMBillInfo *info = infoArr.firstObject;
    NSString *month = [self.formatter stringFromDate:info.billDate];
    [view updateViewWithTitle:month];
    view.delegate = self;
    return view;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"确定要删除这条记录吗?", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [tableView setEditing:NO];
    }];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *infos = weakSelf.billInfos[indexPath.section];
        EMBillInfo *billInfo = infos[indexPath.row];
        [[EMBillManager sharedManager] deleteBillInfo:billInfo result:^{
            NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:weakSelf.billInfos[indexPath.section]];
            [tmpArr removeObjectAtIndex:indexPath.row];
            NSMutableArray *billInfosTmp = [NSMutableArray arrayWithArray:weakSelf.billInfos];
            [billInfosTmp replaceObjectAtIndex:indexPath.section withObject:tmpArr];
            weakSelf.billInfos = billInfosTmp;
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }];
    [alertVC addAction:cancleAction];
    [alertVC addAction:confirmAction];
    [self.navigationController presentViewController:alertVC animated:YES completion:nil];
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"删除", nil);
}


#pragma mark - EMBillHeaderViewDelegate

- (void)enterMonthBillWithMonth:(NSString *)month
{
    EMMonthBillViewController *vc = [[EMMonthBillViewController alloc] init];
    vc.monthStr = month;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

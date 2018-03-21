//
//  EMDiaryViewController.m
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMDiaryViewController.h"
#import "EMPublishDiaryViewController.h"
#import "EMBaseNavigationController.h"
#import "EMDiaryTableViewCell.h"
#import "EMDiaryNoPicTableViewCell.h"
#import "EMDiaryManager.h"
#import "UIView+EMTips.h"
#import "MJRefresh.h"
#import "EMDiaryShowViewController.h"
#import "EMDiaryEditViewController.h"
#import "EMMaskView.h"

@interface EMDiaryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *publishButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray     *diaryInfos;
@property (nonatomic, strong) EMMaskView  *maskView;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *refreshFooter;

@end

static NSString *diaryTableViewCellIdentifier = @"diaryTableViewCellIdentifier";
static NSString *diaryNoPicTableViewCellIdentifier = @"diaryNoPicTableViewCellIdentifier";

@implementation EMDiaryViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshList:)
                                                 name:diaryPublishSuccessNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshPage)
                                                 name:diaryUpdateSuccessNotification
                                               object:nil];
    [self initUI];
    [self loadData];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Getter

- (UIButton *)publishButton
{
    if (!_publishButton) {
        _publishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        [_publishButton setImage:[UIImage imageNamed:@"publishDiary"]
                        forState:UIControlStateNormal];
        [_publishButton addTarget:self action:@selector(publishDiary) forControlEvents:UIControlEventTouchUpInside];
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
        [_tableView registerClass:[EMDiaryTableViewCell class]
           forCellReuseIdentifier:diaryTableViewCellIdentifier];
        [_tableView registerClass:[EMDiaryNoPicTableViewCell class]
           forCellReuseIdentifier:diaryNoPicTableViewCellIdentifier];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = view;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
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

- (void)publishDiary
{
    EMPublishDiaryViewController *vc = [[EMPublishDiaryViewController alloc] init];
    EMBaseNavigationController *nav = [[EMBaseNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Private

- (void)initUI
{
    self.view.backgroundColor = [EMTheme currentTheme].mainBGColor;
    self.title = NSLocalizedString(@"日记", nil);
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
    [[EMDiaryManager sharedManager] fetchDiaryInfosWithStartIndex:0 totalCount:10 result:^(EMResult *result) {
        [weakSelf.view hideManualTips];
        weakSelf.diaryInfos = result.result;
        
        if (weakSelf.diaryInfos.count > 0) {
            [weakSelf.tableView reloadData];
            [weakSelf checkHasMore:result];
        } else {
            [weakSelf.maskView show];
        }
    }];
}


- (void)loadMoreData
{
    __weak typeof(self) weakSelf = self;
    [[EMDiaryManager sharedManager] fetchDiaryInfosWithStartIndex:((EMDiaryInfo *)self.diaryInfos.lastObject).diaryId totalCount:10 result:^(EMResult *result) {
        NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:weakSelf.diaryInfos];
        [tmpArr addObjectsFromArray:result.result];
        weakSelf.diaryInfos = tmpArr;
        [weakSelf.tableView reloadData];
        [weakSelf checkHasMore:result];
    }];
}


- (void)checkHasMore:(EMResult *)result
{
    if (((NSArray *)result.result).count == 10) {
        [self.tableView.mj_footer endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}


- (void)refreshList:(NSNotification *)notification
{
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.diaryInfos];
    [tmpArr insertObject:(EMDiaryInfo *)notification.object atIndex:0];
    self.diaryInfos = tmpArr;
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];//回到顶部
}


- (void)refreshPage
{
    [self.tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.diaryInfos.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMDiaryInfo *info = self.diaryInfos[indexPath.row];
    if (info.diaryMiddleImage) {
        return 105;
    } else {
        return 75;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMDiaryInfo *info = self.diaryInfos[indexPath.row];
    if (info.diaryMiddleImage) {
        EMDiaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:diaryTableViewCellIdentifier
                                                                     forIndexPath:indexPath];
        [cell updateCellWithDiaryInfo:info];
        return cell;
    } else {
        EMDiaryNoPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:diaryNoPicTableViewCellIdentifier
                                               forIndexPath:indexPath];
        [cell updateCellWithDiaryInfo:info];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EMDiaryShowViewController *vc = [[EMDiaryShowViewController alloc] init];
    vc.diaryInfo = self.diaryInfos[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"确定要删除这条记录吗?", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [tableView setEditing:NO];
    }];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[EMDiaryManager sharedManager] deleteDiaryInfo:(EMDiaryInfo *)weakSelf.diaryInfos[indexPath.row] result:^{
            NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:weakSelf.diaryInfos];
            [tmpArr removeObjectAtIndex:indexPath.row];
            weakSelf.diaryInfos = tmpArr;
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

@end

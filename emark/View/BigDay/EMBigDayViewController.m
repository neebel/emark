//
//  EMBigDayViewController.m
//  emark
//
//  Created by neebel on 2017/5/31.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBigDayViewController.h"
#import "EMBaseNavigationController.h"
#import "EMPublishBigDayViewController.h"
#import "EMBigDayManager.h"
#import "EMBigDayCollectionViewLayout.h"
#import "EMBigDayCollectionViewCell.h"
#import "UIView+EMTips.h"
#import "MJRefresh.h"
#import "EMMaskView.h"

@interface EMBigDayViewController ()<EMBigDayCollectionViewLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource, EMBigDayCollectionViewCellDelegate>

@property (nonatomic, strong) UIButton *publishButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray  *dayInfos;
@property (nonatomic, strong) NSIndexPath *editingIndexPath;//当前正在编辑的cell
@property (nonatomic, strong) MJRefreshAutoNormalFooter *refreshFooter;
@property (nonatomic, strong) EMMaskView  *maskView;

@end

static NSString *bigDayCollectionViewCellIdentifier = @"bigDayCollectionViewCellIdentifier";

@implementation EMBigDayViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshList:)
                                                 name:bigDayPublishSuccessNotification
                                               object:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

- (void)initUI
{
    self.view.backgroundColor = [EMTheme currentTheme].mainBGColor;
    self.title = NSLocalizedString(@"节日", nil);
    UIBarButtonItem *publishButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.publishButton];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                           target:nil
                                                                           action:nil];
    space.width = - 20;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:space, publishButtonItem, nil];
    [self.view addSubview:self.collectionView];
    self.collectionView.mj_footer = self.refreshFooter;
}


- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [self.view showMaskLoadingTips:nil style:kLogoLoopGray];
    [[EMBigDayManager sharedManager] fetchBigDayInfosWithStartIndex:0 totalCount:20 result:^(EMResult *result) {
        [weakSelf.view hideManualTips];
        weakSelf.dayInfos = result.result;
        if (weakSelf.dayInfos.count > 0) {
            [weakSelf.collectionView reloadData];
            [weakSelf checkHasMore:result];
        } else {
            [weakSelf.maskView show];
        }
    }];
}


- (void)loadMoreData
{
    __weak typeof(self) weakSelf = self;
    [[EMBigDayManager sharedManager] fetchBigDayInfosWithStartIndex:((EMBigDayInfo *)self.dayInfos.lastObject).bigDayId totalCount:20 result:^(EMResult *result) {
        NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:weakSelf.dayInfos];
        [tmpArr addObjectsFromArray:result.result];
        weakSelf.dayInfos = tmpArr;
        [weakSelf.collectionView reloadData];
        [weakSelf checkHasMore:result];
    }];
}


- (CGFloat)caculteHeightWithDayInfo:(EMBigDayInfo *)dayInfo
{
    UIFont *font = [UIFont systemFontOfSize:15.0];
    CGSize nameSize = [dayInfo.bigDayName boundingRectWithSize:CGSizeMake((self.view.bounds.size.width - 30)/2 - 20, MAXFLOAT)
                                               options:(NSStringDrawingUsesLineFragmentOrigin)
                                            attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]
                                               context:nil].size;
    
    UIFont *remarkFont = [UIFont systemFontOfSize:13.0];
    CGSize remarkSize = [dayInfo.bigDayRemark boundingRectWithSize:CGSizeMake((self.view.bounds.size.width - 30)/2 - 20, MAXFLOAT)
                                                       options:(NSStringDrawingUsesLineFragmentOrigin)
                                                    attributes:[NSDictionary dictionaryWithObjectsAndKeys:remarkFont,NSFontAttributeName, nil]
                                                       context:nil].size;
    
    if (dayInfo.bigDayRemark.length == 0) {
        return nameSize.height + 55;
    } else {
        return nameSize.height + remarkSize.height + 60 + 15;
    }
}


- (void)checkHasMore:(EMResult *)result
{
    if (((NSArray *)result.result).count == 20) {
        [self.collectionView.mj_footer endRefreshing];
    } else {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - Getter

- (UIButton *)publishButton
{
    if (!_publishButton) {
        _publishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        [_publishButton setImage:[UIImage imageNamed:@"publishDiary"]
                        forState:UIControlStateNormal];
        [_publishButton addTarget:self action:@selector(publishBigDay) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _publishButton;
}


- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        EMBigDayCollectionViewLayout *layout = [[EMBigDayCollectionViewLayout alloc] init];
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:layout];
        _collectionView.backgroundColor = [EMTheme currentTheme].mainBGColor;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[EMBigDayCollectionViewCell class]
            forCellWithReuseIdentifier:bigDayCollectionViewCellIdentifier];
    }

    return _collectionView;
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

- (void)publishBigDay
{
    EMPublishBigDayViewController *vc = [[EMPublishBigDayViewController alloc] init];
    EMBaseNavigationController *nav = [[EMBaseNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}


- (void)refreshList:(NSNotification *)notification
{
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.dayInfos];
    [tmpArr insertObject:(EMBigDayInfo *)notification.object atIndex:0];
    self.dayInfos = tmpArr;
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake(0,0) animated:NO];//回到顶部
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dayInfos.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EMBigDayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bigDayCollectionViewCellIdentifier
                                                                                 forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell updateCellWithDayInfo:self.dayInfos[indexPath.row]];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EMBigDayInfo *dayInfo = self.dayInfos[indexPath.row];
    CGFloat cellHeight = [self caculteHeightWithDayInfo:dayInfo];
    return CGSizeMake((self.view.bounds.size.width - 30)/2, cellHeight);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(EMBigDayCollectionViewLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EMBigDayInfo *dayInfo = self.dayInfos[indexPath.row];
    return [self caculteHeightWithDayInfo:dayInfo];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    EMBigDayInfo *dayInfo = self.dayInfos[indexPath.row];
    if (self.editingIndexPath == indexPath) {
        dayInfo.showDelete = !dayInfo.showDelete;
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    } else {
        if (!self.editingIndexPath) {
            dayInfo.showDelete = YES;
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            self.editingIndexPath = indexPath;
        } else {
            dayInfo.showDelete = YES;
            EMBigDayInfo *editingInfo = self.dayInfos[self.editingIndexPath.row];
            editingInfo.showDelete = NO;
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath, self.editingIndexPath]];
            self.editingIndexPath = indexPath;
        }
    }
}

#pragma mark - EMBigDayCollectionViewCellDelegate

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"确定要删除这条记录吗?", nil) preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        EMBigDayInfo *dayInfo = weakSelf.dayInfos[indexPath.row];
        dayInfo.showDelete = NO;
        [weakSelf.collectionView reloadData];
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[EMBigDayManager sharedManager] deleteBigDayInfo:weakSelf.dayInfos[indexPath.row] result:^{
            NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:weakSelf.dayInfos];
            [tmpArr removeObjectAtIndex:indexPath.row];
            weakSelf.dayInfos = tmpArr;
            [weakSelf.collectionView reloadData];
        }];
    }];
    
    [alertVC addAction:cancleAction];
    [alertVC addAction:confirmAction];
    [self.navigationController presentViewController:alertVC animated:YES completion:nil];
}

@end

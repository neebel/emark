//
//  EMAlertViewController.m
//  emark
//
//  Created by neebel on 2017/6/3.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMAlertViewController.h"
#import "EMPublishAlertViewController.h"
#import "EMBaseNavigationController.h"
#import "EMAlertTableViewCell.h"
#import "EMAlertManager.h"
#import "UIView+EMTips.h"
#import "EMMaskView.h"

@interface EMAlertViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *publishButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray  *alertInfos;
@property (nonatomic, strong) EMMaskView  *maskView;

@end

static NSString *alertTableViewCellIdentifier = @"alertTableViewCellIdentifier";
static NSString *alertTableViewHeaderIdentifier = @"alertTableViewHeaderIdentifier";

@implementation EMAlertViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshList:)
                                                 name:alertPublishSuccessNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:alertStateChangedNotification
                                               object:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

- (void)initUI
{
    self.title = NSLocalizedString(@"提醒", nil);
    self.view.backgroundColor = [EMTheme currentTheme].mainBGColor;
    UIBarButtonItem *publishButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.publishButton];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                           target:nil
                                                                           action:nil];
    space.width = - 20;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:space, publishButtonItem, nil];
    
    [self.view addSubview:self.tableView];
}


- (void)loadData
{
    [self.view showMaskLoadingTips:nil style:kLogoLoopWhite];
    __weak typeof(self) weakSelf = self;
    [[EMAlertManager sharedManager] fetchAlertInfosWithResult:^(EMResult *result) {
        [weakSelf.view hideManualTips];
        weakSelf.alertInfos = result.result;
        [weakSelf.tableView reloadData];
        if (weakSelf.alertInfos.count == 3) {
            if (((NSArray *)weakSelf.alertInfos[0]).count == 0 && ((NSArray *)weakSelf.alertInfos[1]).count == 0 && ((NSArray *)weakSelf.alertInfos[2]).count == 0) {
                [weakSelf.maskView show];
            }
        }
    }];
}


- (UIColor *)buildColor:(NSInteger)index
{
    UIColor *color;
    switch (index) {
        case 0:
            color = UIColorFromHexRGB(0x00BEFE);
            break;
            
        case 1:
            color =  UIColorFromHexRGB(0xFF8001);
            break;
            
        case 2:
            color = UIColorFromHexRGB(0x7ABA00);
            break;
            
        default:
            break;
    }
    
    return color;
}


- (void)refreshList:(NSNotification *)notification
{
    if ([self.alertInfos[0] isKindOfClass:[NSArray class]]) {
        NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.alertInfos[0]];
        [tmpArr insertObject:(EMAlertInfo *)notification.object atIndex:0];
        
        NSMutableArray *infosArr = [NSMutableArray arrayWithArray:self.alertInfos];
        [infosArr replaceObjectAtIndex:0 withObject:tmpArr];
        self.alertInfos = infosArr;
        
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];//回到顶部
    }
}


- (void)updateUI:(NSIndexPath *)indexPath
{
    NSArray *infos = self.alertInfos[indexPath.section];
    EMAlertInfo *info = infos[indexPath.row];
    info.isComplete = YES;
    
    NSMutableArray *completeArr = [NSMutableArray arrayWithArray:self.alertInfos[2]];
    [completeArr insertObject:info atIndex:0];
    
    NSMutableArray *finishArr = [NSMutableArray arrayWithArray:self.alertInfos[1]];
    [finishArr removeObject:info];
    
    NSMutableArray *alertArr = [NSMutableArray arrayWithArray:self.alertInfos];
    [alertArr replaceObjectAtIndex:1 withObject:finishArr];
    [alertArr replaceObjectAtIndex:2 withObject:completeArr];
    
    self.alertInfos = alertArr;
    
    [self.tableView reloadData];
}

#pragma mark - Getter

- (UIButton *)publishButton
{
    if (!_publishButton) {
        _publishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        [_publishButton setImage:[UIImage imageNamed:@"publishDiary"]
                        forState:UIControlStateNormal];
        [_publishButton addTarget:self action:@selector(publishAlert) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _publishButton;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.backgroundColor = [EMTheme currentTheme].navBarBGColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[EMAlertTableViewCell class]
           forCellReuseIdentifier:alertTableViewCellIdentifier];
        [_tableView registerClass:[UITableViewHeaderFooterView class]
forHeaderFooterViewReuseIdentifier:alertTableViewHeaderIdentifier];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    return _tableView;
}


- (EMMaskView *)maskView
{
    if (!_maskView) {
        _maskView = [[EMMaskView alloc] init];
    }
    
    return _maskView;
}

#pragma mark - Action

- (void)publishAlert
{
    EMPublishAlertViewController *vc = [[EMPublishAlertViewController alloc] init];
    EMBaseNavigationController *nav = [[EMBaseNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.alertInfos.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id infos = self.alertInfos[section];
    if ([infos isKindOfClass:[NSArray class]]) {
        return ((NSArray *)infos).count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMAlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:alertTableViewCellIdentifier forIndexPath:indexPath];
    if (self.alertInfos.count > 0) {
        if (((NSArray *)self.alertInfos[indexPath.section]).count > 0) {
            NSArray *infos = (NSArray *)self.alertInfos[indexPath.section];
            [cell updateCellWithAlertInfo:infos[indexPath.row] color:[self buildColor:indexPath.section]];
            return cell;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.alertInfos[indexPath.section] isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)self.alertInfos[indexPath.section];
        return arr.count == 0 ? 0 : 160;
    }
    return 160;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:alertTableViewHeaderIdentifier];
    headerView.contentView.backgroundColor = [EMTheme currentTheme].navBarBGColor;
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:alertTableViewHeaderIdentifier];
    view.contentView.backgroundColor = [EMTheme currentTheme].navBarBGColor;
    return view;
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置删除按钮
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"删除", nil) handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
        
        [[EMAlertManager sharedManager] deleteAlertInfo:((NSArray *)weakSelf.alertInfos[indexPath.section])[indexPath.row] result:nil];
        
        NSMutableArray *alertInfos = [NSMutableArray arrayWithArray:weakSelf.alertInfos[indexPath.section]];
        [alertInfos removeObjectAtIndex:indexPath.row];
        NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:weakSelf.alertInfos];
        [tmpArr replaceObjectAtIndex:indexPath.section withObject:alertInfos];
        weakSelf.alertInfos = tmpArr;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    //标记为已完成
    UITableViewRowAction *completeRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"已完成", nil) handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
        NSArray *infos = self.alertInfos[indexPath.section];
        EMAlertInfo *info = infos[indexPath.row];
        [[EMAlertManager sharedManager] updateAlertIsCompleteWithAlertId:info.alertId result:nil];
        [weakSelf updateUI:indexPath];
    }];
    
    completeRowAction.backgroundColor = UIColorFromHexRGB(0x7ABA00);
    
    NSArray *infos = self.alertInfos[indexPath.section];
    EMAlertInfo *alertInfo = infos[indexPath.row];
    if (alertInfo.isFinish && !alertInfo.isComplete) {
        return @[deleteRowAction, completeRowAction];
    } else {
        return @[deleteRowAction];
    }
}

@end

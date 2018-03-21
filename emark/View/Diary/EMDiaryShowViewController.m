//
//  EMDiaryShowViewController.m
//  emark
//
//  Created by neebel on 2017/5/31.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMDiaryShowViewController.h"
#import "EMDiaryShowHeaderView.h"
#import "EMDiaryShowTableViewCell.h"
#import "EMDiaryEditViewController.h"
#import "EMBaseNavigationController.h"
#import "EMDiaryManager.h"
#import "EMShowPhotoTool.h"

@interface EMDiaryShowViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat     contentHeight;
@property (nonatomic, strong) UIButton    *editButton;
@property (nonatomic, strong) EMShowPhotoTool *tool;

@end

static NSString *diaryShowTableViewCellIdentifier = @"diaryShowTableViewCellIdentifier";
static NSString *diaryShowTableViewHeaderViewIdentifier = @"diaryShowTableViewHeaderViewIdentifier";

@implementation EMDiaryShowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshPage)
                                                 name:diaryUpdateSuccessNotification
                                               object:nil];
    [self loadImage];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"详情", nil);
    [self.view addSubview:self.tableView];
    UIBarButtonItem *editButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editButton];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                           target:nil
                                                                           action:nil];
    space.width = - 5;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:space, editButtonItem, nil];
}


- (void)loadImage
{
    __weak typeof(self) weakSelf = self;
    [[EMDiaryManager sharedManager] selectImageWithDiaryId:self.diaryInfo.diaryId result:^(EMResult *result) {
        weakSelf.diaryInfo.diaryImage = result.result;
        [weakSelf.tableView reloadData];
    }];
}


- (CGFloat)caculteHeightWithContent:(NSString *)content
{
    UIFont *font = [UIFont systemFontOfSize:15.0];
    CGSize contentSize = [content boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 30, MAXFLOAT)
                                                              options:(NSStringDrawingUsesLineFragmentOrigin)
                                                           attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]
                                                              context:nil].size;
    
    return contentSize.height;
}

#pragma mark - Action

- (void)editDiary
{
    EMDiaryEditViewController *vc = [[EMDiaryEditViewController alloc] init];
    vc.diaryInfo = self.diaryInfo;
    EMBaseNavigationController *nav = [[EMBaseNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}


- (void)refreshPage
{
    self.contentHeight = [self caculteHeightWithContent:self.diaryInfo.diaryContent];
    [self.tableView reloadData];
}

#pragma mark - Getter & Setter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[EMDiaryShowTableViewCell class]
           forCellReuseIdentifier:diaryShowTableViewCellIdentifier];
        [_tableView registerClass:[EMDiaryShowHeaderView class] forHeaderFooterViewReuseIdentifier:diaryShowTableViewHeaderViewIdentifier];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = view;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    return _tableView;
}


- (void)setDiaryInfo:(EMDiaryInfo *)diaryInfo
{
    _diaryInfo = diaryInfo;
    _contentHeight = [self caculteHeightWithContent:diaryInfo.diaryContent];
}


- (UIButton *)editButton
{
    if (!_editButton) {
        _editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_editButton setImage:[UIImage imageNamed:@"diaryEdit"]
                        forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(editDiary) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _editButton;
}


- (EMShowPhotoTool *)tool
{
    if (!_tool) {
        _tool = [[EMShowPhotoTool alloc] init];
    }

    return _tool;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMDiaryShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:diaryShowTableViewCellIdentifier
                                                                   forIndexPath:indexPath];
    if (self.diaryInfo.diaryImage) {
        [cell updateCellWithImage:self.diaryInfo.diaryImage];
    } else {
        [cell updateCellWithImage:self.diaryInfo.diaryMiddleImage];
    }
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    EMDiaryShowHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:diaryShowTableViewHeaderViewIdentifier];
    [headerView updateViewWithDiaryInfo:self.diaryInfo];
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.contentHeight + 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.diaryInfo.diaryImage) {
        return;
    }
    
    [self.tool showWithImage:self.diaryInfo.diaryImage];
}

@end

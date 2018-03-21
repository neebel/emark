//
//  EMHomeViewController.m
//  emark
//
//  Created by neebel on 2017/5/26.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMHomeViewController.h"
#import "EMHomeCollectionViewCell.h"
#import "EMSettingViewController.h"
#import "EMDiaryViewController.h"
#import "EMBigDayViewController.h"
#import "EMPlaceViewController.h"
#import "EMAlertViewController.h"
#import "EMBillViewController.h"
#import "EMHomeManager.h"

@interface EMHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray          *menuArr;

@end

static NSString *homeCollectionViewCellIdentifier = @"homeCollectionViewCellIdentifier";
static NSString *homeCollectionResuableViewIdentifier = @"homeCollectionResuableViewIdentifier";

@implementation EMHomeViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [EMTheme currentTheme].mainBGColor;
    [self.view addSubview:self.collectionView];
    [self checkToClearNoti];
}


- (void)dealloc
{
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

#pragma mark - Private

- (void)checkToClearNoti
{
    __weak typeof(self) weakSelf = self;
    [[EMHomeManager sharedManager] fetchConfigInfoWithResultBlock:^(EMResult *result) {
        EMAlertConfigInfo *configInfo = result.result;
        if (!configInfo.hasClearAlert) {
            [weakSelf clearNoti];
        }
    }];
}


- (void)clearNoti
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    EMAlertConfigInfo *configInfo = [[EMAlertConfigInfo alloc] init];
    configInfo.hasClearAlert = YES;
    [[EMHomeManager sharedManager] cacheConfigInfo:configInfo];
}

#pragma mark - Getter

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:flowLayout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [EMTheme currentTheme].navBarBGColor;
        [_collectionView registerClass:[EMHomeCollectionViewCell class]
            forCellWithReuseIdentifier:homeCollectionViewCellIdentifier];
        [_collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:homeCollectionResuableViewIdentifier];
    }

    return _collectionView;
}


- (NSArray *)menuArr
{
    if (!_menuArr) {
        _menuArr = @[NSLocalizedString(@"日记", nil), NSLocalizedString(@"账单", nil), NSLocalizedString(@"节日", nil), NSLocalizedString(@"收纳", nil), NSLocalizedString(@"提醒", nil), NSLocalizedString(@"设置", nil)];
    }

    return _menuArr;
}

#pragma mark - Action

- (void)jumpAction:(NSIndexPath *)indexPath
{
    NSString *menuTitle = self.menuArr[indexPath.row];
    
    UIViewController *vc = nil;
    if ([menuTitle isEqualToString:NSLocalizedString(@"日记", nil)]) {
        vc = [[EMDiaryViewController alloc] init];
    } else if ([menuTitle isEqualToString:NSLocalizedString(@"账单", nil)]) {
        vc = [[EMBillViewController alloc] init];
    } else if ([menuTitle isEqualToString:NSLocalizedString(@"节日", nil)]) {
        vc = [[EMBigDayViewController alloc] init];
    } else if ([menuTitle isEqualToString:NSLocalizedString(@"收纳", nil)]) {
        vc = [[EMPlaceViewController alloc] init];
    } else if ([menuTitle isEqualToString:NSLocalizedString(@"提醒", nil)]) {
        vc = [[EMAlertViewController alloc] init];
    } else if ([menuTitle isEqualToString:NSLocalizedString(@"设置", nil)]) {
        vc = [[EMSettingViewController alloc] init];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.menuArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EMHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:homeCollectionViewCellIdentifier
                                              forIndexPath:indexPath];
    [cell updateCellWithTitle:self.menuArr[indexPath.row]];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: case 3: case 4:
            return CGSizeMake((self.view.frame.size.width - 50) / 2 + 50, 120);
            break;
            
        case 1: case 2: case 5:
            return CGSizeMake((self.view.frame.size.width - 50) / 2 - 50, 120);
            break;
            
        default:
            break;
    }
    
    return CGSizeZero;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
   return UIEdgeInsetsMake(0, 20, 0, 20);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat height = ([UIApplication sharedApplication].delegate.window.bounds.size.height - 120 * 3 - 10 * 2) / 2 - 64;
    if (IS_3_5_INCH) {
        height = ([UIApplication sharedApplication].delegate.window.bounds.size.height - 120 * 3 - 10 * 2) / 2;
    }
    
    return CGSizeMake(self.view.frame.size.width, height);
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                      withReuseIdentifier:homeCollectionResuableViewIdentifier
                                                                                             forIndexPath:indexPath];
    headerView.backgroundColor = [EMTheme currentTheme].navBarBGColor;
    return headerView;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self jumpAction:indexPath];
}

@end

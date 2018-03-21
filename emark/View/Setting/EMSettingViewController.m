//
//  EMSettingViewController.m
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMSettingViewController.h"
#import "EMSettingTableViewCell.h"
#import "EMSettingHeaderView.h"
#import "EMHomeManager.h"
#import "EMSettingActionSheet.h"
#import "EMHomeManager.h"
#import "EMAboutUsViewController.h"
#import "FSMediaPicker.h"
#import "EMShowPhotoTool.h"

@interface EMSettingViewController ()<UITableViewDelegate, UITableViewDataSource, EMSettingActionSheetDelegate, FSMediaPickerDelegate, EMSettingHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray     *settingItemArr;
@property (nonatomic, strong) EMSettingActionSheet *actionSheet;
@property (nonatomic, strong) EMHomeHeadInfo *headInfo;
@property (nonatomic, strong) EMShowPhotoTool *tool;

@end

static NSString *settingTableViewCellIdentifier = @"settingTableViewCellIdentifier";
static NSString *settingTableViewHeaderViewIdentifier = @"settingTableViewHeaderViewIdentifier";

@implementation EMSettingViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"设置", nil);
    [self.view addSubview:self.tableView];
    [self loadData];
}


- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
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
        [_tableView registerClass:[EMSettingTableViewCell class]
           forCellReuseIdentifier:settingTableViewCellIdentifier];
        [_tableView registerClass:[EMSettingHeaderView class] forHeaderFooterViewReuseIdentifier:settingTableViewHeaderViewIdentifier];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = view;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    return _tableView;
}


- (NSArray *)settingItemArr
{
    if (!_settingItemArr) {
        _settingItemArr = @[NSLocalizedString(@"更换头像", nil), NSLocalizedString(@"关于我们", nil), NSLocalizedString(@"鼓励一下", nil)];
    }

    return _settingItemArr;
}


- (EMSettingActionSheet *)actionSheet
{
    if (!_actionSheet) {
        _actionSheet = [[EMSettingActionSheet alloc] init];
        _actionSheet.delegate = self;
    }

    return _actionSheet;
}


- (EMHomeHeadInfo *)headInfo
{
    if (!_headInfo) {
        _headInfo = [[EMHomeHeadInfo alloc] init];
    }

    return _headInfo;
}


- (EMShowPhotoTool *)tool
{
    if (!_tool) {
        _tool = [[EMShowPhotoTool alloc] init];
    }

    return _tool;
}

#pragma mark - Action

- (void)jumpAction:(NSIndexPath *)indexPath
{
    NSString *title = self.settingItemArr[indexPath.row];
    if ([title isEqualToString:NSLocalizedString(@"更换头像", nil)]) {
        [self selectHead];
    } else if ([title isEqualToString:NSLocalizedString(@"关于我们", nil)]) {
        EMAboutUsViewController *aboutUsVC = [[EMAboutUsViewController alloc] init];
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    } else if ([title isEqualToString:NSLocalizedString(@"鼓励一下", nil)]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1247383214&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"]];
    }
}

#pragma mark - Private

- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [[EMHomeManager sharedManager] fetchHeadInfoWithResultBlock:^(EMResult *result) {
        weakSelf.headInfo = result.result;
        [weakSelf.tableView reloadData];
    }];
}


- (void)selectHead
{
    [self.actionSheet show];
}


- (void)checkAuthorizationWithType:(EMSettingHeadImageType)type complete:(void (^) ())complete
{
    switch (type) {
        case kEMSettingHeadImageTypeCamera: //检查相机授权
        {
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                switch (authStatus) {
                    case AVAuthorizationStatusAuthorized:
                        if (complete) {
                            complete();
                        }
                        break;
                    case AVAuthorizationStatusNotDetermined:
                    {
                        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                            dispatch_async_in_main_queue(^{
                                if (granted && complete) {
                                    complete();
                                }
                            });
                        }];
                    }
                        break;
                    default:
                    {
                        [self.view showMultiLineMessage:NSLocalizedString(@"请在iPhone的\"设置-隐私-相机\"选项中，允许EMark访问你的相机", nil)];
                    }
                        break;
                }
            } else {
                [EMTips show:NSLocalizedString(@"您的设备不支持拍照", nil)];
            }
        }
            break;
        case kEMSettingHeadImageTypeAlbum: //检查相册授权
        {
            ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
            switch (status) {
                case ALAuthorizationStatusNotDetermined:
                case ALAuthorizationStatusAuthorized:
                    if (complete) {
                        complete();
                    }
                    break;
                default:
                {
                    [self.view showMultiLineMessage:NSLocalizedString(@"请在iPhone的\"设置-隐私-照片\"选项中，允许EMark访问你的相册", nil)];
                }
                    break;
            }
        }
            break;
        default:
            break;
    }
}


- (void)refreshHead:(UIImage *)image
{
    self.headInfo.headImage = image;
    [[EMHomeManager sharedManager] cacheHeadInfo:self.headInfo];
    [self.tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.settingItemArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingTableViewCellIdentifier
                                    forIndexPath:indexPath];
    [cell updateCellWithTitle:self.settingItemArr[indexPath.row]];
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    EMSettingHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:settingTableViewHeaderViewIdentifier];
    [headerView updateViewWithImage:self.headInfo.headImage];
    headerView.delegate = self;
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self jumpAction:indexPath];
}

#pragma mark - EMSettingActionSheetDelegate

- (void)takePhoto
{
    __weak typeof(self) weakSelf = self;
    [self checkAuthorizationWithType:kEMSettingHeadImageTypeCamera complete:^{
        FSMediaPicker *mediaPicker = [[FSMediaPicker alloc] initWithDelegate:weakSelf];
        mediaPicker.mediaType = FSMediaTypePhoto;
        mediaPicker.editMode = FSEditModeStandard;
        [mediaPicker takePhotoFromCamera];
    }];
}


- (void)searchFromAlbum
{
    __weak typeof(self) weakSelf = self;
    [self checkAuthorizationWithType:kEMSettingHeadImageTypeAlbum complete:^{
        FSMediaPicker *mediaPicker = [[FSMediaPicker alloc] initWithDelegate:weakSelf];
        mediaPicker.mediaType = FSMediaTypePhoto;
        mediaPicker.editMode = FSEditModeStandard;
        [mediaPicker takePhotoFromPhotoLibrary];
    }];
}

#pragma mark - FSMediaPickerDelegate

- (void)mediaPicker:(FSMediaPicker *)mediaPicker didFinishWithMediaInfo:(NSDictionary *)mediaInfo
{
    [self refreshHead:mediaInfo.editedImage];
}

#pragma mark - EMSettingHeaderViewDelegate

- (void)lookBigImage
{
    UIImage *image = self.headInfo.headImage ? self.headInfo.headImage : [UIImage imageNamed:@"headDefault"];
    [self.tool showWithImage:image];
}

@end

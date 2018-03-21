//
//  EMDiaryEditViewController.m
//  emark
//
//  Created by neebel on 2017/5/31.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMDiaryEditViewController.h"
#import "EMPlaceHolderTextView.h"
#import "EMSettingActionSheet.h"
#import "EMSettingViewController.h"
#import "EMDiaryManager.h"
#import "FSMediaPicker.h"

@interface EMDiaryEditViewController ()<EMSettingActionSheetDelegate, UITextViewDelegate, FSMediaPickerDelegate>

@property (nonatomic, strong) EMPlaceHolderTextView *inputTextView;
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UIButton    *deleteButton;
@property (nonatomic, strong) UIView      *bottomLine;
@property (nonatomic, strong) UIButton    *saveButton;
@property (nonatomic, strong) UIView      *tapView;
@property (nonatomic, strong) EMSettingActionSheet *actionSheet;
@property (nonatomic, strong) UILabel     *numberLabel;
@property (nonatomic, copy)   NSString    *content;
@property (nonatomic, strong) UIImage     *pic;

@end

@implementation EMDiaryEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

#pragma mark - Action

- (void)cancel
{
    [self closeKeyBoard];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"确定要放弃此次修改吗?", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertVC addAction:cancleAction];
    [alertVC addAction:confirmAction];
    [self.navigationController presentViewController:alertVC animated:YES completion:nil];
}


- (void)save
{
    [self closeKeyBoard];
    
    if (self.content.length == 0) {
        [EMTips show:NSLocalizedString(@"请输入内容", nil)];
        return;
    }
    
    self.diaryInfo.diaryContent = self.content;
    self.diaryInfo.diaryImage = self.pic;
    self.diaryInfo.diaryMiddleImage = [self.pic aspectResizeWithWidth:400];
    
    [self.view showMaskLoadingTips:nil style:kLogoLoopGray];
    __weak typeof(self) weakSelf = self;
    [[EMDiaryManager sharedManager] updateDiaryInfo:self.diaryInfo result:^{
        [weakSelf.view hideManualTips];
        [[NSNotificationCenter defaultCenter] postNotificationName:diaryUpdateSuccessNotification object:nil];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}


- (void)closeKeyBoard
{
    [self.inputTextView resignFirstResponder];
}


- (void)selectImage
{
    [self closeKeyBoard];
    if (self.deleteButton.hidden) {
        [self.actionSheet show];
    } else {
        [self deleteImage];
    }
}


- (void)deleteImage
{
    [self updatePic:nil];
}

#pragma mark - Private

- (void)initUI
{
    self.title = NSLocalizedString(@"编辑", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(cancel)];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                           target:nil
                                                                           action:nil];
    space.width = - 16;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:space, saveButtonItem, nil];
    
    [self.view addSubview:self.inputTextView];
    __weak typeof(self) weakSelf = self;
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.view);
        make.height.mas_equalTo(200);
    }];
    
    [self.selectImageView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.selectImageView).with.offset(5);
        make.bottom.equalTo(weakSelf.selectImageView).with.offset(5);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.view addSubview:self.selectImageView];
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.inputTextView.mas_bottom).with.offset(10);
        make.left.equalTo(weakSelf.view).with.offset(15);
        make.width.height.mas_equalTo(50);
    }];
    
    
    [self.view addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.selectImageView.mas_bottom).with.offset(15);
        make.left.equalTo(weakSelf.view).with.offset(15);
        make.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
    
    [self.view addSubview:self.tapView];
    [self.tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.bottomLine.mas_bottom);
    }];
    
    [self.view addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).with.offset(-15);
        make.bottom.equalTo(weakSelf.selectImageView).with.offset(8);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
    }];
    
    self.selectImageView.image = self.diaryInfo.diaryImage ? self.diaryInfo.diaryImage : [UIImage imageNamed:@"publishDiaryCamera"];
    self.deleteButton.hidden = !self.diaryInfo.diaryImage;
    self.numberLabel.text = [NSString stringWithFormat:@"%@/500", [NSNumber numberWithInteger:self.diaryInfo.diaryContent.length]];
    self.inputTextView.text = self.diaryInfo.diaryContent;
    self.content = self.diaryInfo.diaryContent;
    self.pic = self.diaryInfo.diaryImage;
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


- (void)updatePic:(UIImage *)image
{
    if (image) {
        self.selectImageView.image = image;
        self.deleteButton.hidden = NO;
    } else {
        self.selectImageView.image = [UIImage imageNamed:@"publishDiaryCamera"];
        self.deleteButton.hidden = YES;
    }
    
    self.pic = image;
}

#pragma mark - Getter & Setter

- (UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        [_saveButton setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
        [_saveButton setTitleColor:UIColorFromHexRGB(0x23A24D) forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    }
    
    return _saveButton;
}


- (UITextView *)inputTextView
{
    if (!_inputTextView) {
        _inputTextView = [[EMPlaceHolderTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        _inputTextView.backgroundColor = [UIColor whiteColor];
        _inputTextView.font = [UIFont systemFontOfSize:15.0];
        _inputTextView.textContainerInset = UIEdgeInsetsMake(10, 15, 10, 15);
        _inputTextView.placeholder = NSLocalizedString(@"记录下此刻的心情吧...", nil);
        _inputTextView.delegate = self;
    }
    
    return _inputTextView;
}


- (UIImageView *)selectImageView
{
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _selectImageView.contentMode = UIViewContentModeScaleAspectFill;
        _selectImageView.clipsToBounds = YES;
        _selectImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(selectImage)];
        [_selectImageView addGestureRecognizer:gesture];
    }
    
    return _selectImageView;
}


- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_deleteButton setImage:[UIImage imageNamed:@"publishDiaryDelete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _deleteButton;
}


- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [EMTheme currentTheme].dividerColor;
    }
    
    return _bottomLine;
}


- (UIView *)tapView
{
    if (!_tapView) {
        _tapView = [[UIView alloc] init];
        _tapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)];
        [_tapView addGestureRecognizer:gesture];
    }
    
    return _tapView;
}


- (EMSettingActionSheet *)actionSheet
{
    if (!_actionSheet) {
        _actionSheet = [[EMSettingActionSheet alloc] init];
        _actionSheet.delegate = self;
    }
    
    return _actionSheet;
}


- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = [UIFont systemFontOfSize:15.0];
        _numberLabel.textAlignment = NSTextAlignmentRight;
        _numberLabel.textColor = UIColorFromHexRGB(0x666666);
    }
    
    return _numberLabel;
}

#pragma mark - EMSettingActionSheetDelegate

- (void)takePhoto
{
    __weak typeof(self) weakSelf = self;
    [self checkAuthorizationWithType:kEMSettingHeadImageTypeCamera complete:^{
        FSMediaPicker *mediaPicker = [[FSMediaPicker alloc] initWithDelegate:weakSelf];
        mediaPicker.mediaType = FSMediaTypePhoto;
        mediaPicker.editMode = FSEditModeNone;
        [mediaPicker takePhotoFromCamera];
    }];
}


- (void)searchFromAlbum
{
    __weak typeof(self) weakSelf = self;
    [self checkAuthorizationWithType:kEMSettingHeadImageTypeAlbum complete:^{
        FSMediaPicker *mediaPicker = [[FSMediaPicker alloc] initWithDelegate:weakSelf];
        mediaPicker.mediaType = FSMediaTypePhoto;
        mediaPicker.editMode = FSEditModeNone;
        [mediaPicker takePhotoFromPhotoLibrary];
    }];
}

#pragma mark - FSMediaPickerDelegate

- (void)mediaPicker:(FSMediaPicker *)mediaPicker didFinishWithMediaInfo:(NSDictionary *)mediaInfo
{
    [self updatePic:mediaInfo.originalImage];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.markedTextRange == nil) {
        NSString *numberStr;
        if ([textView.text length] > 500) {//字数限制
            textView.text = [textView.text substringToIndex:500];
            numberStr = @"500/500";
        } else {
            numberStr = [NSString stringWithFormat:@"%@/500", [NSNumber numberWithInteger:textView.text.length]];
        }
        
        self.numberLabel.text = numberStr;
        self.content = textView.text;
    }
}

@end

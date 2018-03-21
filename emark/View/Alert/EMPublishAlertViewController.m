//
//  EMPublishAlertViewController.m
//  emark
//
//  Created by neebel on 2017/6/3.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMPublishAlertViewController.h"
#import "EMAlertItemInfo.h"
#import "EMPublishAlertTableViewCell.h"
#import "EMPublishAlertEditTableViewCell.h"
#import "CZPicker.h"
#import "EMDatePicker.h"
#import "EMAlertManager.h"
#import "UIView+EMTips.h"

@interface EMPublishAlertViewController ()<UITableViewDelegate, UITableViewDataSource, CZPickerViewDelegate, CZPickerViewDataSource, EMDatePickerDelegate>

@property (nonatomic, strong) UIButton    *saveButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray     *itemArr;
@property (nonatomic, strong) NSArray     *pickerItemArr;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *remarkTextField;
@property (nonatomic, strong) UIView      *tapView;
@property (nonatomic, strong) CZPickerView *picker;
@property (nonatomic, strong) EMDatePicker *datePicker;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) NSDate          *alertDate;

@end

static NSString *publishAlertTableViewCellIdentifier = @"publishAlertTableViewCellIdentifier";
static NSString *publishAlertEditTableViewCellIdentifier = @"publishAlertEditTableViewCellIdentifier";

@implementation EMPublishAlertViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

#pragma mark - Private

- (void)initUI
{
    self.title = NSLocalizedString(@"添加提醒", nil);
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
    
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.view);
        make.height.mas_equalTo(250);
    }];
    
    [self.view addSubview:self.tapView];
    [self.tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.mas_equalTo(250);
    }];
}

#pragma mark - Getter

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


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 250)
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[EMPublishAlertTableViewCell class]
           forCellReuseIdentifier:publishAlertTableViewCellIdentifier];
        [_tableView registerClass:[EMPublishAlertEditTableViewCell class]
           forCellReuseIdentifier:publishAlertEditTableViewCellIdentifier];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = view;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
    }
    
    return _tableView;
}


- (UIView *)tapView
{
    if (!_tapView) {
        _tapView = [[UIView alloc] init];
        _tapView.backgroundColor = [UIColor clearColor];
        _tapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)];
        [_tapView addGestureRecognizer:gesture];
    }
    
    return _tapView;
}


- (CZPickerView *)picker
{
    if (!_picker) {
        _picker = [[CZPickerView alloc] initWithHeaderTitle:NSLocalizedString(@"选择重复模式", nil)
                                          cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                         confirmButtonTitle:NSLocalizedString(@"确定", nil)];
        _picker.delegate = self;
        _picker.dataSource = self;
        _picker.needFooterView = YES;
        _picker.headerBackgroundColor = UIColorFromHexRGB(0x1AAB19);
        _picker.confirmButtonBackgroundColor = UIColorFromHexRGB(0x1AAB19);
    }
    
    return _picker;
}


- (EMDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[EMDatePicker alloc] init];
        _datePicker.delegate = self;
        [_datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    }
    
    return _datePicker;
}


- (NSArray *)itemArr
{
    if (!_itemArr) {
        EMAlertItemInfo *name = [[EMAlertItemInfo alloc] init];
        name.itemName = NSLocalizedString(@"我想", nil);
        name.iconName = @"billIconPlan";
        EMAlertItemInfo *type = [[EMAlertItemInfo alloc] init];
        type.itemName = NSLocalizedString(@"重复", nil);
        type.itemValue = NSLocalizedString(@"从不", nil);
        type.iconName = @"billIconMode";
        EMAlertItemInfo *date = [[EMAlertItemInfo alloc] init];
        date.iconName = @"billIconTime";
        date.itemName = NSLocalizedString(@"时间", nil);
        NSDate *todayDate = [NSDate date];
        NSString *time = [self.formatter stringFromDate:todayDate];
        date.itemValue = time;
        self.alertDate = todayDate;
        EMAlertItemInfo *remark = [[EMAlertItemInfo alloc] init];
        remark.iconName = @"billIconRemark";
        remark.itemName = NSLocalizedString(@"备注", nil);
        _itemArr = @[name, type, date, remark];
    }
    
    return _itemArr;
}


- (NSArray *)pickerItemArr
{
    return @[NSLocalizedString(@"从不", nil), NSLocalizedString(@"每天", nil), NSLocalizedString(@"每周", nil), NSLocalizedString(@"每月", nil)];
}


- (NSDateFormatter *)formatter
{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"MM/dd HH:mm"];
    }
    
    return _formatter;
}

#pragma mark - Action

- (void)cancel
{
    [self closeKeyBoard];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)save
{
    [self closeKeyBoard];
    
    if (self.nameTextField.text.length == 0) {
        [EMTips show:NSLocalizedString(@"请输入提醒名称", nil)];
        return;
    }
    //构建bean 存入数据库
    
    EMAlertInfo *info = [[EMAlertInfo alloc] init];
    info.alertName = self.nameTextField.text;
    info.alertRemark = self.remarkTextField.text;
    NSString *itemValue = ((EMAlertItemInfo *)self.itemArr[1]).itemValue;
    EMAlertRepeatType type = kEMAlertRepeatTypeNever;
    if ([itemValue isEqualToString:NSLocalizedString(@"从不", nil)]) {
        type = kEMAlertRepeatTypeNever;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"每天", nil)]) {
        type = kEMAlertRepeatTypeDay;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"每周", nil)]) {
        type = kEMAlertRepeatTypeWeekday;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"每月", nil)]) {
        type = kEMAlertRepeatTypeMonth;
    }
    
    info.alertRepeatType = type;
    info.alertDate = self.alertDate ? self.alertDate : [NSDate date];
    
    [self.view showMaskLoadingTips:nil style:kLogoLoopGray];
    __weak typeof(self) weakSelf = self;
    [[EMAlertManager sharedManager] cacheAlertInfo:info result:^{
        [weakSelf.view hideManualTips];
        [[NSNotificationCenter defaultCenter] postNotificationName:alertPublishSuccessNotification object:info];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}


- (void)closeKeyBoard
{
    [self.nameTextField resignFirstResponder];
    [self.remarkTextField resignFirstResponder];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMAlertItemInfo *itemInfo = self.itemArr[indexPath.row];
    if ([itemInfo.itemName isEqualToString:NSLocalizedString(@"重复", nil)] || [itemInfo.itemName isEqualToString:NSLocalizedString(@"时间", nil)]) {
        EMPublishAlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:publishAlertTableViewCellIdentifier
                                                                             forIndexPath:indexPath];
        [cell updateCellWithItemInfo:self.itemArr[indexPath.row]];
        return cell;
    } else {
        EMPublishAlertEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:publishAlertEditTableViewCellIdentifier
                                                                                 forIndexPath:indexPath];
        [cell updateCellWithItemInfo:self.itemArr[indexPath.row]];
        if ([itemInfo.itemName isEqualToString:NSLocalizedString(@"我想", nil)]) {
            self.nameTextField = cell.valueTextField;
        } else {
            self.remarkTextField = cell.valueTextField;
        }
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self closeKeyBoard];
    if ([((EMAlertItemInfo *)self.itemArr[indexPath.row]).itemName isEqualToString:NSLocalizedString(@"重复", nil)]) {
        [self.picker show];
    } else if ([((EMAlertItemInfo *)self.itemArr[indexPath.row]).itemName isEqualToString:NSLocalizedString(@"时间", nil)]) {
        [self.datePicker show];
        [self.datePicker setMinimumDate:[NSDate date]];
    }
}


#pragma mark - CZPickerView

- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView
{
    return self.pickerItemArr.count;
}


- (NSString *)czpickerView:(CZPickerView *)pickerView titleForRow:(NSInteger)row
{
    return self.pickerItemArr[row];
}


- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row
{
    NSString *type = self.pickerItemArr[row];
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.itemArr];
    EMAlertItemInfo *itemInfo = tmpArr[1];
    itemInfo.itemValue = type;
    [tmpArr replaceObjectAtIndex:1 withObject:itemInfo];
    self.itemArr = tmpArr;
    [self.tableView reloadData];
}


#pragma mark - EMDatePickerDelegate

- (void)changeTime:(UIDatePicker *)datePicker
{
    self.alertDate = datePicker.date;
    NSString *dateStr = [self.formatter stringFromDate:datePicker.date];
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.itemArr];
    EMAlertItemInfo *itemInfo = tmpArr[2];
    itemInfo.itemValue = dateStr;
    [tmpArr replaceObjectAtIndex:2 withObject:itemInfo];
    self.itemArr = tmpArr;
    [self.tableView reloadData];
}

@end

//
//  EMPublishBigDayViewController.m
//  emark
//
//  Created by neebel on 2017/5/31.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMPublishBigDayViewController.h"
#import "EMBigDayItemInfo.h"
#import "EMPublishBigDayTableViewCell.h"
#import "EMPublishBigDayEditTableViewCell.h"
#import "CZPicker.h"
#import "EMDatePicker.h"
#import "EMBigDayManager.h"
#import "UIView+EMTips.h"

@interface EMPublishBigDayViewController ()<UITableViewDelegate, UITableViewDataSource, CZPickerViewDelegate, CZPickerViewDataSource, EMDatePickerDelegate>

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

@end

static NSString *publishBigDayTableViewCellIdentifier = @"publishBigDayTableViewCellIdentifier";
static NSString *publishBigDayEditTableViewCellIdentifier = @"publishBigDayEditTableViewCellIdentifier";

@implementation EMPublishBigDayViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

#pragma mark - Private

- (void)initUI
{
    self.title = NSLocalizedString(@"记日子", nil);
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
        [_tableView registerClass:[EMPublishBigDayTableViewCell class]
           forCellReuseIdentifier:publishBigDayTableViewCellIdentifier];
        [_tableView registerClass:[EMPublishBigDayEditTableViewCell class]
           forCellReuseIdentifier:publishBigDayEditTableViewCellIdentifier];
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
        _picker = [[CZPickerView alloc] initWithHeaderTitle:NSLocalizedString(@"选择类型", nil)
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
    }
    
    return _datePicker;
}


- (NSArray *)itemArr
{
    if (!_itemArr) {
        EMBigDayItemInfo *name = [[EMBigDayItemInfo alloc] init];
        name.iconName = @"billIconName";
        name.itemName = NSLocalizedString(@"名称", nil);
        EMBigDayItemInfo *type = [[EMBigDayItemInfo alloc] init];
        type.iconName = @"billIconType";
        type.itemName = NSLocalizedString(@"类型", nil);
        type.itemValue = NSLocalizedString(@"生日", nil);
        EMBigDayItemInfo *date = [[EMBigDayItemInfo alloc] init];
        date.iconName = @"billIconTime";
        date.itemName = NSLocalizedString(@"日期", nil);
        NSDate *todayDate = [NSDate date];
        NSString *time = [self.formatter stringFromDate:todayDate];
        date.itemValue = time;
        EMBigDayItemInfo *remark = [[EMBigDayItemInfo alloc] init];
        remark.iconName = @"billIconRemark";
        remark.itemName = NSLocalizedString(@"备注", nil);
        _itemArr = @[name, type, date, remark];
    }

    return _itemArr;
}


- (NSArray *)pickerItemArr
{
    return @[NSLocalizedString(@"生日", nil), NSLocalizedString(@"纪念日", nil), NSLocalizedString(@"其他", nil)];
}


- (NSDateFormatter *)formatter
{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"MM/dd,YYYY"];
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
        [EMTips show:NSLocalizedString(@"请输入名称", nil)];
        return;
    }
    //构建bean 存入数据库
    
    EMBigDayInfo *info = [[EMBigDayInfo alloc] init];
    info.bigDayName = self.nameTextField.text;
    info.bigDayRemark = self.remarkTextField.text;
    info.bigDayType = ((EMBigDayItemInfo *)self.itemArr[1]).itemValue;
    info.bigDayDate = ((EMBigDayItemInfo *)self.itemArr[2]).itemValue;
    
    [self.view showMaskLoadingTips:nil style:kLogoLoopGray];
    __weak typeof(self) weakSelf = self;
    [[EMBigDayManager sharedManager] cacheBigDayInfo:info result:^{
        [weakSelf.view hideManualTips];
        [[NSNotificationCenter defaultCenter] postNotificationName:bigDayPublishSuccessNotification object:info];
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
    EMBigDayItemInfo *itemInfo = self.itemArr[indexPath.row];
    if ([itemInfo.itemName isEqualToString:NSLocalizedString(@"类型", nil)] || [itemInfo.itemName isEqualToString:NSLocalizedString(@"日期", nil)]) {
        EMPublishBigDayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:publishBigDayTableViewCellIdentifier
                                                                             forIndexPath:indexPath];
        [cell updateCellWithItemInfo:self.itemArr[indexPath.row]];
        return cell;
    } else {
        EMPublishBigDayEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:publishBigDayEditTableViewCellIdentifier
                                                                                 forIndexPath:indexPath];
        [cell updateCellWithItemInfo:self.itemArr[indexPath.row]];
        if ([itemInfo.itemName isEqualToString:NSLocalizedString(@"名称", nil)]) {
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
    if ([((EMBigDayItemInfo *)self.itemArr[indexPath.row]).itemName isEqualToString:NSLocalizedString(@"类型", nil)]) {
        [self.picker show];
    } else if ([((EMBigDayItemInfo *)self.itemArr[indexPath.row]).itemName isEqualToString:NSLocalizedString(@"日期", nil)]) {
        [self.datePicker show];
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
    EMBigDayItemInfo *itemInfo = tmpArr[1];
    itemInfo.itemValue = type;
    [tmpArr replaceObjectAtIndex:1 withObject:itemInfo];
    self.itemArr = tmpArr;
    [self.tableView reloadData];
}


#pragma mark - EMDatePickerDelegate

- (void)changeTime:(UIDatePicker *)datePicker
{
    NSString *dateStr = [self.formatter stringFromDate:datePicker.date];
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.itemArr];
    EMBigDayItemInfo *itemInfo = tmpArr[2];
    itemInfo.itemValue = dateStr;
    [tmpArr replaceObjectAtIndex:2 withObject:itemInfo];
    self.itemArr = tmpArr;
    [self.tableView reloadData];
}

@end

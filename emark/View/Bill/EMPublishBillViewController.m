//
//  EMPublishBillViewController.m
//  emark
//
//  Created by neebel on 2017/6/3.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMPublishBillViewController.h"
#import "EMBillItemInfo.h"
#import "EMPublishBillTableViewCell.h"
#import "EMPublishBillEditTableViewCell.h"
#import "EMDatePicker.h"
#import "EMBillManager.h"
#import "UIView+EMTips.h"
#import "MMNumberKeyboard.h"
#import "EMBillTypePicker.h"
#import "EMBillTypeInfo.h"
#import "EMBillInfo.h"

@interface EMPublishBillViewController ()<UITableViewDelegate, UITableViewDataSource, EMDatePickerDelegate, MMNumberKeyboardDelegate, EMBillTypePickerDelegate>

@property (nonatomic, strong) UIButton    *saveButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray     *itemArr;
@property (nonatomic, strong) UITextField *countTextField;
@property (nonatomic, strong) UITextField *remarkTextField;
@property (nonatomic, strong) UIView      *tapView;
@property (nonatomic, strong) EMDatePicker *datePicker;
@property (nonatomic, strong) NSDate       *date;
@property (nonatomic, strong) EMBillTypePicker *typePicker;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) MMNumberKeyboard *keyboard;

@end

static NSString *publishBillTableViewCellIdentifier = @"publishBillTableViewCellIdentifier";
static NSString *publishBillEditTableViewCellIdentifier = @"publishBillEditTableViewCellIdentifier";

@implementation EMPublishBillViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

#pragma mark - Private

- (void)initUI
{
    self.title = NSLocalizedString(@"记账", nil);
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
        [_tableView registerClass:[EMPublishBillTableViewCell class]
           forCellReuseIdentifier:publishBillTableViewCellIdentifier];
        [_tableView registerClass:[EMPublishBillEditTableViewCell class]
           forCellReuseIdentifier:publishBillEditTableViewCellIdentifier];
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


- (EMDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[EMDatePicker alloc] init];
        _datePicker.delegate = self;
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
    }
    
    return _datePicker;
}


- (EMBillTypePicker *)typePicker
{
    if (!_typePicker) {
        _typePicker = [[EMBillTypePicker alloc] init];
        _typePicker.delegate = self;
    }

    return _typePicker;
}


- (NSArray *)itemArr
{
    if (!_itemArr) {
        EMBillItemInfo *type = [[EMBillItemInfo alloc] init];
        type.iconName = @"billIconType";
        type.itemName = NSLocalizedString(@"类型", nil);
        type.itemValue = NSLocalizedString(@"支出/吃", nil);
        
        EMBillItemInfo *count = [[EMBillItemInfo alloc] init];
        count.iconName = @"billIconCount";
        count.itemValue = @"0.0";
        count.itemName = NSLocalizedString(@"金额", nil);
        
        EMBillItemInfo *date = [[EMBillItemInfo alloc] init];
        date.iconName = @"billIconTime";
        date.itemName = NSLocalizedString(@"时间", nil);
        NSDate *todayDate = [NSDate date];
        self.date = todayDate;
        NSString *time = [self.formatter stringFromDate:todayDate];
        date.itemValue = time;
        
        EMBillItemInfo *remark = [[EMBillItemInfo alloc] init];
        remark.iconName = @"billIconRemark";
        remark.itemName = NSLocalizedString(@"备注", nil);
        remark.itemValue = NSLocalizedString(@"备注", nil);
        _itemArr = @[type, count, date, remark];
    }
    
    return _itemArr;
}


- (NSDateFormatter *)formatter
{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"MM/dd"];
    }
    
    return _formatter;
}


- (MMNumberKeyboard *)keyboard
{
    if (!_keyboard) {
        _keyboard = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
        _keyboard.allowsDecimalPoint = YES;
        _keyboard.delegate = self;
    }
    
    return _keyboard;
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
    
    if (self.countTextField.text.length == 0) {
        [EMTips show:NSLocalizedString(@"请输入金额", nil)];
        return;
    }
    
    //构建bean 存入数据库
    EMBillInfo *info = [[EMBillInfo alloc] init];
    NSString *itemValue = ((EMBillItemInfo *)self.itemArr[0]).itemValue;
    EMBillType type = kEMBillTypePayEat;
    if ([itemValue isEqualToString:NSLocalizedString(@"支出/吃", nil)]) {
        type = kEMBillTypePayEat;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"支出/穿", nil)]) {
        type = kEMBillTypePayClothe;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"支出/住", nil)]) {
        type = kEMBillTypePayLive;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"支出/行", nil)]) {
        type = kEMBillTypePayWalk;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"支出/玩", nil)]) {
        type = kEMBillTypePayPlay;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"支出/其他", nil)]) {
        type = kEMBillTypePayOther;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"收入/工资", nil)]) {
        type = kEMBillTypeIncomeSalary;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"收入/奖金", nil)]) {
        type = kEMBillTypeIncomeAward;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"收入/外快", nil)]) {
        type = kEMBillTypeIncomeExtra;
    } else if ([itemValue isEqualToString:NSLocalizedString(@"收入/其他", nil)]) {
        type = kEMBillTypeIncomeOther;
    }
    info.billType = type;
    info.billCount = self.countTextField.text.doubleValue;
    info.billDate = self.date;
    info.billRemark = self.remarkTextField.text;
    
    [self.view showMaskLoadingTips:nil style:kLogoLoopGray];
    __weak typeof(self) weakSelf = self;
    [[EMBillManager sharedManager] cacheBillInfo:info result:^{
        [weakSelf.view hideManualTips];
        [[NSNotificationCenter defaultCenter] postNotificationName:billPublishSuccessNotification object:info];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}


- (void)closeKeyBoard
{
    [self.countTextField resignFirstResponder];
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
    EMBillItemInfo *itemInfo = self.itemArr[indexPath.row];
    if ([itemInfo.itemName isEqualToString:NSLocalizedString(@"备注", nil)] || [itemInfo.itemName isEqualToString:NSLocalizedString(@"金额", nil)]) {
        EMPublishBillEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:publishBillEditTableViewCellIdentifier
                                                                               forIndexPath:indexPath];
        [cell updateCellWithItemInfo:self.itemArr[indexPath.row]];
        if ([itemInfo.itemName isEqualToString:NSLocalizedString(@"备注", nil)]) {
            self.remarkTextField = cell.valueTextField;
        } else {
            self.countTextField = cell.valueTextField;
            self.countTextField.inputView = self.keyboard;
        }
        return cell;
    } else {
        EMPublishBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:publishBillTableViewCellIdentifier
                                                                           forIndexPath:indexPath];
        [cell updateCellWithItemInfo:self.itemArr[indexPath.row]];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self closeKeyBoard];
    if ([((EMBillItemInfo *)self.itemArr[indexPath.row]).itemName isEqualToString:NSLocalizedString(@"类型", nil)]) {
        [self.typePicker show];
    } else if ([((EMBillItemInfo *)self.itemArr[indexPath.row]).itemName isEqualToString:NSLocalizedString(@"时间", nil)]) {
        [self.datePicker show];
    }
}


#pragma mark - EMDatePickerDelegate

- (void)changeTime:(UIDatePicker *)datePicker
{
    self.date = datePicker.date;
    NSString *dateStr = [self.formatter stringFromDate:datePicker.date];
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.itemArr];
    EMBillItemInfo *itemInfo = tmpArr[2];
    itemInfo.itemValue = dateStr;
    [tmpArr replaceObjectAtIndex:2 withObject:itemInfo];
    self.itemArr = tmpArr;
    [self.tableView reloadData];
}

#pragma mark - MMNumberKeyboardDelegate

- (BOOL)numberKeyboard:(MMNumberKeyboard *)numberKeyboard shouldInsertText:(NSString *)text
{
    BOOL hasInputDot = NO;
    if (self.countTextField.text.length == 0) {
        return ![text isEqualToString:@"."];
    } else {
        if ([self.countTextField.text rangeOfString:@"."].location == NSNotFound) {
            if ([text isEqualToString:@"."]) {
                hasInputDot = YES;
                return YES;
            }
        } else {
            if ([text isEqualToString:@"."]) {
                return NO;
            } else {
               NSRange ran = [self.countTextField.text rangeOfString:@"."];
                return !(self.countTextField.text.length - ran.location > 2);
            }
        }
    }
    
    return YES;
}

#pragma mark - EMBillTypePickerDelegate

- (void)pickerViewDidSelectType:(NSString *)type subType:(NSString *)subType
{
    NSString *typeStr = [NSString stringWithFormat:@"%@/%@", type, subType];
    EMBillItemInfo *itemInfo = self.itemArr[0];
    itemInfo.itemValue = typeStr;
    [self.tableView reloadData];
}

@end

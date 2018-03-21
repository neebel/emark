//
//  EMBillInfo.h
//  emark
//
//  Created by neebel on 2017/6/1.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMAutoCoding.h"

typedef NS_ENUM(NSInteger, EMBillType) {
    kEMBillTypePayEat = 1,//支出 - 吃
    kEMBillTypePayClothe, //支出 - 穿
    kEMBillTypePayLive,   //支出 - 住
    kEMBillTypePayWalk,   //支出 - 行
    kEMBillTypePayPlay,   //支出 - 玩
    kEMBillTypePayOther,  //支出 - 其他
    
    kEMBillTypeIncomeSalary,  //收入 - 工资
    kEMBillTypeIncomeAward,   //收入 - 奖金
    kEMBillTypeIncomeExtra,   //收入 - 外快
    kEMBillTypeIncomeOther,   //收入 - 其他
};


@interface EMBillInfo : EMAutoCoding

@property (nonatomic, assign) NSInteger  billId;
@property (nonatomic, assign) EMBillType billType;               //账单类型
@property (nonatomic, assign) double     billCount;              //账单金额
@property (nonatomic, strong) NSDate     *billDate;              //账单日期
@property (nonatomic, copy)   NSString   *billRemark;            //账单备注

@end

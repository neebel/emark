//
//  EMAlertInfo.h
//  emark
//
//  Created by neebel on 2017/6/1.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMAutoCoding.h"

typedef NS_ENUM(NSInteger, EMAlertRepeatType) {
    kEMAlertRepeatTypeNever = 0,
    kEMAlertRepeatTypeDay = kCFCalendarUnitDay,
    kEMAlertRepeatTypeWeekday = kCFCalendarUnitWeekday,
    kEMAlertRepeatTypeMonth = kCFCalendarUnitMonth,
};

@interface EMAlertInfo : EMAutoCoding

@property (nonatomic, assign) NSInteger alertId;
@property (nonatomic, copy)   NSString  *alertName;              //提醒名称
@property (nonatomic, assign) EMAlertRepeatType alertRepeatType;//重复周期
@property (nonatomic, strong) NSDate    *alertDate;              //提醒时间
@property (nonatomic, copy)   NSString  *alertRemark;            //提醒备注
@property (nonatomic, assign) BOOL      joinLocalNotification;   //提醒是否被加入到本地提醒队列中
@property (nonatomic, assign) BOOL      isFinish;                //提醒是否已过期
@property (nonatomic, assign) BOOL      isComplete;              //提醒是否被用户标记为已完成

@end

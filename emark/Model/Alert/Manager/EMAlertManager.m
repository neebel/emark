//
//  EMAlertManager.m
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMAlertManager.h"
#import "EMAlertViewController.h"

@interface EMAlertManager()

@property (nonatomic, strong) EMAlertHandler *handler;
@property (nonatomic, strong) dispatch_queue_t localNotificationQueue;

@end

const char *localNotificationQueue = "cn.neebel.emark.localNotificationQueue";

@implementation EMAlertManager

+ (instancetype)sharedManager
{
    static EMAlertManager *_sManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sManager = [[self alloc] init];
    });
    
    return _sManager;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self autoCheckToAddAlert];
        [self autoCheckToMarkFinish];
    }
    
    return self;
}


- (void)fetchAlertInfosWithResult:(EMResultBlock)resultBlock
{
    [self.handler fetchAlertInfosWithResult:resultBlock];
}


- (void)cacheAlertInfo:(EMAlertInfo *)alertInfo result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    [self.handler cacheAlertInfo:alertInfo result:^{
        dispatch_async_in_queue(self.localNotificationQueue, ^{
            //异步处理通知
            [weakSelf pushAlertToLocalNotification:alertInfo];
        });
        //先直接在主线程回调
        if (resultBlock) {
            resultBlock();
        }
    }];
}


- (void)updateAlertIsJoined:(BOOL)isJoined alertId:(NSInteger)alertId result:(void (^)(void))resultBlock;
{
    [self.handler updateAlertIsJoined:isJoined alertId:alertId result:resultBlock];
}


- (void)updateAlertIsCompleteWithAlertId:(NSInteger)alertId
                                  result:(void (^)(void))resultBlock
{
    [self.handler updateAlertIsCompleteWithAlertId:alertId result:resultBlock];

}


- (void)deleteAlertInfo:(EMAlertInfo *)alertInfo result:(void (^)(void))resultBlock
{
    [self cancelNotifiWithAlertInfo:alertInfo];
    [self.handler deleteAlertInfo:alertInfo result:resultBlock];
}


- (EMAlertHandler *)handler
{
    if (!_handler) {
        _handler = [[EMAlertHandler alloc] init];
    }
    
    return _handler;
}


- (dispatch_queue_t)localNotificationQueue
{
    if (!_localNotificationQueue) {
        _localNotificationQueue = dispatch_create_serial_queue_for_name(localNotificationQueue);
    }

    return _localNotificationQueue;
}

#pragma mark - UILocalNotification

- (void)autoCheckToAddAlert
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.localNotificationQueue, ^{
        [weakSelf.handler fetchUnJoinedAlertInfosWithResult:^(EMResult *result) {
            NSArray *alertInfos = result.result;
            if (alertInfos.count == 0) {
                return;
            }
            
            for (EMAlertInfo *alertInfo in alertInfos) {
                [weakSelf pushAlertToLocalNotification:alertInfo];
            }
        }];
    });
}

//对于已过期的提醒并且是从不重复的提醒手动标记为已过期
- (void)autoCheckToMarkFinish
{
    [self.handler autoCheckToMarkFinish];

}


- (void)pushAlertToLocalNotification:(EMAlertInfo *)alertInfo
{
    if (alertInfo.alertId > 0) {//数据库插入成功
        //已添加到系统通知队列的通知
        NSArray *scheduledNotis = [UIApplication sharedApplication].scheduledLocalNotifications;
        if (scheduledNotis.count < 64) {
            //队列没满，可以直接加入
            [self addNotification:alertInfo];
        } else {
            //队列满了，需要踢除开始时间最晚的通知 再加入
            UILocalNotification *latestNotifi = nil;
            for (UILocalNotification *notifi in scheduledNotis) {
                if([latestNotifi.fireDate compare:notifi.fireDate] == NSOrderedAscending) {
                    latestNotifi = notifi;
                }
            }
            
            if ([latestNotifi.fireDate compare:alertInfo.alertDate] == NSOrderedDescending) {
                [self removeNotification:latestNotifi];
                [self addNotification:alertInfo];
            }
        }
    }
}


- (void)addNotification:(EMAlertInfo *)alertInfo
{
    UILocalNotification *notifaction = [[UILocalNotification alloc] init];
    
    //保证alertBody不能为空 不然的话通知会显示不出来
    if (alertInfo.alertRemark.length == 0) {
        notifaction.alertBody = alertInfo.alertName;
    } else {
        notifaction.alertTitle = alertInfo.alertName;
        notifaction.alertBody = alertInfo.alertRemark;
    }
    
    notifaction.fireDate = alertInfo.alertDate;
    notifaction.repeatInterval = (NSInteger)alertInfo.alertRepeatType;
    notifaction.soundName = UILocalNotificationDefaultSoundName;
    NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@(alertInfo.alertId)
                                                        forKey:@"emark_alertId"];
    notifaction.userInfo = infoDic;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notifaction];
    
    //更新内存
    alertInfo.joinLocalNotification = YES;
    //更新数据库
    [self updateAlertIsJoined:YES alertId:alertInfo.alertId result:nil];
}


- (void)removeNotification:(UILocalNotification *)notifi
{
    [[UIApplication sharedApplication] cancelLocalNotification:notifi];
    NSDictionary *userInfoDic = notifi.userInfo;
    NSNumber *alertId = [userInfoDic objectForKey:@"emark_alertId"];
    [self updateAlertIsJoined:NO alertId:alertId.integerValue result:nil];
}


- (void)didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UILocalNotification *localNotify = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotify)
    {
        [self didReceiveLocalNotification:localNotify];
    }
}


- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSNumber *alertId = [notification.userInfo objectForKey:@"emark_alertId"];
    __weak typeof(self) weakSelf = self;
    [self.handler selectAlertInfoWithAlertId:alertId.integerValue result:^(EMResult *result) {
        [weakSelf showAlertViewWithInfo:result.result];
        if (((EMAlertInfo *)result.result).alertRepeatType == kEMAlertRepeatTypeNever) {
            //不再重复执行的提醒才标记为已完成
            [weakSelf.handler updateAlertIsFinishedwithAlertId:alertId.integerValue result:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:alertStateChangedNotification object:nil];
            }];
        }
        
        [weakSelf autoCheckToAddAlert];
    }];
}


- (void)showAlertViewWithInfo:(EMAlertInfo *)alertInfo
{
    if (nil == alertInfo) {
        return;
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:alertInfo.alertName
                                                                     message:alertInfo.alertRemark
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
    [alertVC addAction:confirmAction];
    UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    [vc presentViewController:alertVC animated:YES completion:nil];
}


- (void)cancelNotifiWithAlertInfo:(EMAlertInfo *)alertInfo
{
    NSArray *scheduledNotis = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification *noti in scheduledNotis) {
        NSNumber *alertId = [noti.userInfo objectForKey:@"emark_alertId"];
        if (alertId.integerValue == alertInfo.alertId) {
            [[UIApplication sharedApplication] cancelLocalNotification:noti];
            break;
        }
    }
}

@end

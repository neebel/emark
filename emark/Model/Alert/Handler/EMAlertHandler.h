//
//  EMAlertHandler.h
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBaseHandler.h"
#import "EMAlertCacheProvider.h"

@interface EMAlertHandler : EMBaseHandler

- (void)fetchAlertInfosWithResult:(EMResultBlock)resultBlock;

- (void)fetchUnJoinedAlertInfosWithResult:(EMResultBlock)resultBlock;

- (void)selectAlertInfoWithAlertId:(NSInteger)alertId result:(EMResultBlock)resultBlock;

- (void)cacheAlertInfo:(EMAlertInfo *)alertInfo result:(void (^)(void))resultBlock;

- (void)updateAlertIsJoined:(BOOL)isJoined
                    alertId:(NSInteger)alertId
                     result:(void (^)(void))resultBlock;

- (void)updateAlertIsFinishedwithAlertId:(NSInteger)alertId
                                  result:(void (^)(void))resultBlock;

- (void)updateAlertIsCompleteWithAlertId:(NSInteger)alertId
                                  result:(void (^)(void))resultBlock;

- (void)deleteAlertInfo:(EMAlertInfo *)alertInfo result:(void (^)(void))resultBlock;


- (void)autoCheckToMarkFinish;

@end

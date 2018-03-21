//
//  EMBillHandler.h
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBaseHandler.h"
#import "EMBillCacheProvider.h"
#import "EMBillMonthInfo.h"

@interface EMBillHandler : EMBaseHandler

- (void)fetchBillInfosBeforeDate:(NSDate *)date
                      totalCount:(NSInteger)totalCount
                          result:(EMResultBlock)resultBlock;

- (void)cacheBillInfo:(EMBillInfo *)billInfo result:(void (^)(void))resultBlock;

- (void)deleteBillInfo:(EMBillInfo *)billInfo result:(void (^)(void))resultBlock;

- (void)fetchMonthBillInMonth:(NSString *)month result:(EMResultBlock)resultBlock;

@end

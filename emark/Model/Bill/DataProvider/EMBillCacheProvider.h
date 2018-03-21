//
//  EMBillCacheProvider.h
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBaseDatabaseCommonProvider.h"
#import "EMBillInfo.h"

@interface EMBillCacheProvider : EMBaseDatabaseCommonProvider

- (NSArray<EMBillInfo *> *)selectBillInfosBeforeDate:(NSDate *)date
                                          totalCount:(NSInteger)totalCount;

- (void)cacheBillInfo:(EMBillInfo *)BillInfo;

- (void)deleteBillInfo:(EMBillInfo *)BillInfo;


- (NSArray<EMBillInfo *> *)selectBillInfosBetween:(NSDate *)fromDate and:(NSDate *)toDate;

@end

//
//  EMBigDayCacheProvider.h
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBaseDatabaseCommonProvider.h"
#import "EMBigDayInfo.h"

@interface EMBigDayCacheProvider : EMBaseDatabaseCommonProvider

- (NSArray<EMBigDayInfo *> *)selectBigDayInfosFromStart:(NSInteger)startIndex
                                             totalCount:(NSInteger)totalCount;

- (void)cacheBigDayInfo:(EMBigDayInfo *)bigDayInfo;

- (void)deleteBigDayInfo:(EMBigDayInfo *)bigDayInfo;

@end

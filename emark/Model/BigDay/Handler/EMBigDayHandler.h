//
//  EMBigDayHandler.h
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBaseHandler.h"
#import "EMBigDayCacheProvider.h"

@interface EMBigDayHandler : EMBaseHandler

- (void)fetchBigDayInfosWithStartIndex:(NSInteger)startIndex
                            totalCount:(NSInteger)totalCount
                                result:(EMResultBlock)resultBlock;

- (void)cacheBigDayInfo:(EMBigDayInfo *)bigDayInfo result:(void (^)(void))resultBlock;

- (void)deleteBigDayInfo:(EMBigDayInfo *)bigDayInfo result:(void (^)(void))resultBlock;

@end

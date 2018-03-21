//
//  EMBigDayHandler.m
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBigDayHandler.h"

@interface EMBigDayHandler()

@property (nonatomic, strong) EMBigDayCacheProvider *provider;

@end

@implementation EMBigDayHandler

- (void)fetchBigDayInfosWithStartIndex:(NSInteger)startIndex totalCount:(NSInteger)totalCount result:(EMResultBlock)resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        NSArray<EMBigDayInfo *> *dayInfos = [weakSelf.provider selectBigDayInfosFromStart:startIndex
                                                                               totalCount:totalCount];
        EMResult *result = [[EMResult alloc] init];
        result.result = dayInfos;
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock(result);
        });
    });
}


- (void)cacheBigDayInfo:(EMBigDayInfo *)bigDayInfo result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider cacheBigDayInfo:bigDayInfo];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


- (void)deleteBigDayInfo:(EMBigDayInfo *)bigDayInfo result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider deleteBigDayInfo:bigDayInfo];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


#pragma mark - Getter

- (EMBigDayCacheProvider *)provider
{
    if (!_provider) {
        _provider = [[EMBigDayCacheProvider alloc] init];
    }
    
    return _provider;
}

@end

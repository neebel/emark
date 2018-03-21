//
//  EMAlertHandler.m
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMAlertHandler.h"

@interface EMAlertHandler()

@property (nonatomic, strong) EMAlertCacheProvider *provider;

@end

@implementation EMAlertHandler

- (void)fetchAlertInfosWithResult:(EMResultBlock)resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        NSArray<EMAlertInfo *> *alertInfos = [weakSelf.provider selectAlertInfos];
        EMResult *result = [[EMResult alloc] init];
        result.result = [weakSelf groupAlertInfos:alertInfos];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock(result);
        });
    });
}


- (void)fetchUnJoinedAlertInfosWithResult:(EMResultBlock)resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        NSArray<EMAlertInfo *> *alertInfos = [weakSelf.provider selectUnJoinedAlertInfos];
        EMResult *result = [[EMResult alloc] init];
        result.result = alertInfos;
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock(result);
        });
    });
}


- (void)selectAlertInfoWithAlertId:(NSInteger)alertId result:(EMResultBlock)resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        EMAlertInfo *alertInfo = [weakSelf.provider selectAlertInfoWithAlertId:alertId];
        EMResult *result = [[EMResult alloc] init];
        result.result = alertInfo;
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock(result);
        });
    });
}


- (void)cacheAlertInfo:(EMAlertInfo *)alertInfo result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider cacheAlertInfo:alertInfo];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


- (void)updateAlertIsJoined:(BOOL)isJoined alertId:(NSInteger)alertId result:(void (^)(void))resultBlock;
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider updateAlertIsjoined:isJoined alertId:alertId];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


- (void)updateAlertIsFinishedwithAlertId:(NSInteger)alertId
                                  result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider updateAlertIsFinishedWithAlertId:alertId];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


- (void)updateAlertIsCompleteWithAlertId:(NSInteger)alertId
                                  result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider updateAlertIsCompleteWithAlertId:alertId];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


- (void)deleteAlertInfo:(EMAlertInfo *)alertInfo result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider deleteAlertInfo:alertInfo];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


- (void)autoCheckToMarkFinish
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider autoCheckToMarkFinish];
    });
}

#pragma mark - Private

- (NSArray *)groupAlertInfos:(NSArray *)alertInfos
{
    NSMutableArray *goingOnInfos = [NSMutableArray array];
    NSMutableArray *finishedInfos = [NSMutableArray array];
    NSMutableArray *completeInfos = [NSMutableArray array];
    for (EMAlertInfo *info in alertInfos) {
        if (info.isFinish) {
            if (info.isComplete) {
                [completeInfos addObject:info];
            } else {
                [finishedInfos addObject:info];
            }
        } else {
            [goingOnInfos addObject:info];
        }
    }

    return @[goingOnInfos, finishedInfos, completeInfos];
}

#pragma mark - Getter

- (EMAlertCacheProvider *)provider
{
    if (!_provider) {
        _provider = [[EMAlertCacheProvider alloc] init];
    }
    
    return _provider;
}

@end

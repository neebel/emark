//
//  EMHomeHandler.m
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMHomeHandler.h"

@interface EMHomeHandler()

@property (nonatomic, strong) EMHomeCacheProvider *provider;

@end

@implementation EMHomeHandler

- (void)fetchHeadInfoWithResultBlock:(EMResultBlock)resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        EMHomeHeadInfo *headInfo = [weakSelf.provider queryHeadInfo];
        EMResult *result = [[EMResult alloc] init];
        result.result = headInfo;
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock(result);
        });
    });
}


- (void)cacheHeadInfo:(EMHomeHeadInfo *)headInfo
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider cacheHeadInfo:headInfo];
    });
}


- (void)fetchConfigInfoWithResultBlock:(EMResultBlock)resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        EMAlertConfigInfo *configInfo = [weakSelf.provider queryConfigInfo];
        EMResult *result = [[EMResult alloc] init];
        result.result = configInfo;
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock(result);
        });
    });
}


- (void)cacheConfigInfo:(EMAlertConfigInfo *)configInfo
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider cacheConfigInfo:configInfo];
    });
}

#pragma mark - Getter

- (EMHomeCacheProvider *)provider
{
    if (!_provider) {
        _provider = [[EMHomeCacheProvider alloc] initWithName:@"EMark_HomeProvider"];
    }

    return _provider;
}

@end

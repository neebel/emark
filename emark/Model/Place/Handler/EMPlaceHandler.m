//
//  EMPlaceHandler.n
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMPlaceHandler.h"

@interface EMPlaceHandler()

@property (nonatomic, strong) EMPlaceCacheProvider *provider;

@end

@implementation EMPlaceHandler

- (void)fetchPlaceInfosWithStartIndex:(NSInteger)startIndex totalCount:(NSInteger)totalCount result:(EMResultBlock)resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        NSArray<EMPlaceInfo *> *placeInfos = [weakSelf.provider selectPlaceInfosFromStart:startIndex
                                                                               totalCount:totalCount];
        EMResult *result = [[EMResult alloc] init];
        result.result = placeInfos;
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock(result);
        });
    });
}


- (void)cachePlaceInfo:(EMPlaceInfo *)placeInfo result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider cachePlaceInfo:placeInfo];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


- (void)deletePlaceInfo:(EMPlaceInfo *)placeInfo result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider deletePlaceInfo:placeInfo];
        
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

- (EMPlaceCacheProvider *)provider
{
    if (!_provider) {
        _provider = [[EMPlaceCacheProvider alloc] init];
    }
    
    return _provider;
}

@end

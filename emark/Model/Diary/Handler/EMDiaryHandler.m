//
//  EMDiaryHandler.m
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMDiaryHandler.h"

@interface EMDiaryHandler()

@property (nonatomic, strong) EMDiaryCacheProvider *provider;

@end

@implementation EMDiaryHandler

- (void)fetchDiaryInfosWithStartIndex:(NSInteger)startIndex totalCount:(NSInteger)totalCount result:(EMResultBlock)resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        NSArray<EMDiaryInfo *> *diaryInfos = [weakSelf.provider selectDiaryInfosFromStart:startIndex
                                                                               totalCount:totalCount];
        EMResult *result = [[EMResult alloc] init];
        result.result = diaryInfos;
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock(result);
        });
    });
}


- (void)cacheDiaryInfo:(EMDiaryInfo *)diaryInfo result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider cacheDiaryInfo:diaryInfo];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


- (void)updateDiaryInfo:(EMDiaryInfo *)diaryInfo result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider updateDiaryInfo:diaryInfo];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


- (void)deleteDiaryInfo:(EMDiaryInfo *)diaryInfo result:(void (^)(void))resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        [weakSelf.provider deleteDiaryInfo:diaryInfo];
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock();
        });
    });
}


- (void)selectImageWithDiaryId:(NSInteger)diaryId result:(EMResultBlock)resultBlock
{
    __weak typeof(self) weakSelf = self;
    dispatch_async_in_queue(self.handleQueue, ^{
        UIImage *img = [weakSelf.provider selectImageWithDiaryId:diaryId];
        EMResult *result = [[EMResult alloc] init];
        result.result = img;
        
        if (nil == weakSelf || nil == resultBlock) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async_in_queue(strongSelf.callBackQueue, ^{
            resultBlock(result);
        });
    });
}

#pragma mark - Getter

- (EMDiaryCacheProvider *)provider
{
    if (!_provider) {
        _provider = [[EMDiaryCacheProvider alloc] init];
    }
    
    return _provider;
}

@end

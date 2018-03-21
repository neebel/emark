//
//  EMDiaryManager.m
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMDiaryManager.h"

@interface EMDiaryManager()

@property (nonatomic, strong) EMDiaryHandler *handler;

@end

@implementation EMDiaryManager

+ (instancetype)sharedManager
{
    static EMDiaryManager *_sManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sManager = [[self alloc] init];
    });
    
    return _sManager;
}


- (void)fetchDiaryInfosWithStartIndex:(NSInteger)startIndex
                           totalCount:(NSInteger)totalCount
                               result:(EMResultBlock)resultBlock
{
    [self.handler fetchDiaryInfosWithStartIndex:startIndex
                                     totalCount:totalCount
                                         result:resultBlock];
}


- (void)cacheDiaryInfo:(EMDiaryInfo *)diaryInfo result:(void (^)(void))resultBlock
{
    [self.handler cacheDiaryInfo:diaryInfo result:resultBlock];
}


- (void)updateDiaryInfo:(EMDiaryInfo *)diaryInfo result:(void (^)(void))resultBlock
{
    [self.handler updateDiaryInfo:diaryInfo result:resultBlock];
}


- (void)deleteDiaryInfo:(EMDiaryInfo *)diaryInfo result:(void (^)(void))resultBlock
{
    [self.handler deleteDiaryInfo:diaryInfo result:resultBlock];
}


- (void)selectImageWithDiaryId:(NSInteger)diaryId result:(EMResultBlock)resultBlock
{
    [self.handler selectImageWithDiaryId:diaryId result:resultBlock];
}


- (EMDiaryHandler *)handler
{
    if (!_handler) {
        _handler = [[EMDiaryHandler alloc] init];
    }
    
    return _handler;
}

@end

//
//  EMDiaryHandler.h
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBaseHandler.h"
#import "EMDiaryCacheProvider.h"

@interface EMDiaryHandler : EMBaseHandler

- (void)fetchDiaryInfosWithStartIndex:(NSInteger)startIndex
                           totalCount:(NSInteger)totalCount
                               result:(EMResultBlock)resultBlock;

- (void)cacheDiaryInfo:(EMDiaryInfo *)diaryInfo result:(void (^)(void))resultBlock;

- (void)updateDiaryInfo:(EMDiaryInfo *)diaryInfo result:(void (^)(void))resultBlock;

- (void)deleteDiaryInfo:(EMDiaryInfo *)diaryInfo result:(void (^)(void))resultBlock;

- (void)selectImageWithDiaryId:(NSInteger)diaryId result:(EMResultBlock)resultBlock;

@end

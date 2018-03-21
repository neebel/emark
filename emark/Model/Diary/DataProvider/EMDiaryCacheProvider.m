//
//  EMDiaryCacheProvider.m
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMDiaryCacheProvider.h"
#import "FMDB.h"

@implementation EMDiaryCacheProvider

#pragma mark - Override

- (NSString *)name
{
    return @"emark_diary_list";
}


- (NSInteger)version
{
    return 1;
}


- (BOOL)onCreateTable:(FMDatabase *)db
{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS emark_diary_list ("
    @"diaryId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
    @"diaryDate             TEXT, "
    @"diaryContent          TEXT, "
    @"diaryImage            BLOB  "
    @");";
    
    BOOL result = [db executeUpdate:sql];
    
    if (result) {
        [db executeUpdate:@"CREATE INDEX IF NOT EXISTS index_diaryId ON emark_diary_list( diaryId );"];
    }
    
    return result;
}


#pragma mark - Public

- (NSArray<EMDiaryInfo *> *)selectDiaryInfosFromStart:(NSInteger)startIndex
                                           totalCount:(NSInteger)totalCount
{
    __weak typeof(self) weakSelf = self;
    NSMutableArray *tmpArr = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = nil;
        if (0 == startIndex) {
            result = [db executeQuery:@"SELECT * FROM emark_diary_list ORDER BY diaryId DESC LIMIT ? ", @(totalCount)];
        } else {
            result = [db executeQuery:@"SELECT * FROM emark_diary_list where diaryId < ? ORDER BY diaryId DESC LIMIT ? ", @(startIndex), @(totalCount)];
        }
        
        while (result.next) {
            EMDiaryInfo *diaryInfo = [weakSelf buildDiaryInfoWithResult:result];
            [tmpArr addObject:diaryInfo];
        }
        [result close];
    }];
    
    return tmpArr;
}


- (void)cacheDiaryInfo:(EMDiaryInfo *)diaryInfo
{
    if (nil == diaryInfo) {
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL success = [db executeUpdate:@"INSERT INTO "
         @"emark_diary_list (diaryId, diaryDate, diaryContent, "
         @"diaryImage"
         @") "
    
         @"VALUES (?, ?, ?, ?"
         @")",
         nil, diaryInfo.diaryDate, diaryInfo.diaryContent,
         UIImageJPEGRepresentation(diaryInfo.diaryImage, 1)];
        //插入成功后要更新内存中的日记id以便删除时使用
        if (success) {
            FMResultSet *result = [db executeQuery:@"SELECT * FROM emark_diary_list WHERE diaryDate = ?", diaryInfo.diaryDate];
            while (result.next) {//肯定只有一条日记 一秒内发不了多条
                diaryInfo.diaryId = [[result stringForColumn:@"diaryId"] integerValue];
            }
        }
    }];
}


- (void)updateDiaryInfo:(EMDiaryInfo *)diaryInfo
{
    if (nil == diaryInfo) {
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"UPDATE emark_diary_list SET diaryDate = ?, diaryContent = ?, diaryImage = ? WHERE diaryId = ?", diaryInfo.diaryDate, diaryInfo.diaryContent, UIImageJPEGRepresentation(diaryInfo.diaryImage, 1), @(diaryInfo.diaryId)];
    }];
}


- (void)deleteDiaryInfo:(EMDiaryInfo *)diaryInfo
{
    if (nil == diaryInfo) {
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM emark_diary_list WHERE diaryId = ?", @(diaryInfo.diaryId)];
    }];
}

#pragma mark - Private

- (EMDiaryInfo *)buildDiaryInfoWithResult:(FMResultSet *)result
{
    EMDiaryInfo *diaryInfo = [[EMDiaryInfo alloc] init];
    diaryInfo.diaryId = [[result stringForColumn:@"diaryId"] integerValue];
    diaryInfo.diaryDate = [result stringForColumn:@"diaryDate"];
    diaryInfo.diaryContent = [result stringForColumn:@"diaryContent"];
    diaryInfo.diaryMiddleImage = [[UIImage imageWithData:[result dataForColumn:@"diaryImage"]] aspectResizeWithWidth:400];
    return diaryInfo;
}


- (UIImage *)selectImageWithDiaryId:(NSInteger)diaryId
{
   __block UIImage *image = nil;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT * FROM emark_diary_list WHERE diaryId = ? ", @(diaryId)];
        while (result.next) {
            image = [UIImage imageWithData:[result dataForColumn:@"diaryImage"]];
        }
    }];
    
    return image;
}

@end

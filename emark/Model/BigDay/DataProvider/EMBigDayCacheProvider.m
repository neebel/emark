//
//  EMBigDayCacheProvider.m
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBigDayCacheProvider.h"
#import "FMDB.h"

@implementation EMBigDayCacheProvider

#pragma mark - Override

- (NSString *)name
{
    return @"emark_bigday_list";
}


- (NSInteger)version
{
    return 1;
}


- (BOOL)onCreateTable:(FMDatabase *)db
{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS emark_bigday_list ("
    @"bigDayId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
    @"bigDayName             TEXT, "
    @"bigDayType             TEXT, "
    @"bigDayDate             TEXT, "
    @"bigDayRemark           TEXT "
    @");";
    
    BOOL result = [db executeUpdate:sql];
    return result;
}


#pragma mark - Public

- (NSArray<EMBigDayInfo *> *)selectBigDayInfosFromStart:(NSInteger)startIndex
                                             totalCount:(NSInteger)totalCount
{
    __weak typeof(self) weakSelf = self;
    NSMutableArray *tmpArr = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = nil;
        if (0 == startIndex) {
            result = [db executeQuery:@"SELECT * FROM emark_bigday_list ORDER BY bigDayId DESC LIMIT ? ", @(totalCount)];
        } else {
            result = [db executeQuery:@"SELECT * FROM emark_bigday_list where bigDayId < ? ORDER BY bigDayId DESC LIMIT ? ", @(startIndex), @(totalCount)];
        }
        
        while (result.next) {
            EMBigDayInfo *dayInfo = [weakSelf buildBigDayInfoWithResult:result];
            [tmpArr addObject:dayInfo];
        }
        [result close];
    }];
    
    return tmpArr;
}


- (void)cacheBigDayInfo:(EMBigDayInfo *)bigDayInfo
{
    if (nil == bigDayInfo) {
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL success = [db executeUpdate:@"INSERT INTO "
         @"emark_bigday_list (bigDayId, bigDayName, bigDayType, bigDayDate, "
         @"bigDayRemark"
         @") "
    
         @"VALUES (?, ?, ?, ?, ?"
         @")",
         nil, bigDayInfo.bigDayName, bigDayInfo.bigDayType, bigDayInfo.bigDayDate,
         bigDayInfo.bigDayRemark];
        //插入成功后要更新内存中的节日id以便删除时使用
        if (success) {
            FMResultSet *result = [db executeQuery:@"SELECT * FROM emark_bigday_list ORDER BY bigDayId DESC LIMIT 1 "];
            while (result.next) {
                bigDayInfo.bigDayId = [[result stringForColumn:@"bigDayId"] integerValue];
            }
        }
    }];
}


- (void)deleteBigDayInfo:(EMBigDayInfo *)bigDayInfo
{
    if (nil == bigDayInfo) {
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM emark_bigday_list WHERE bigDayId = ?", @(bigDayInfo.bigDayId)];
    }];
}

#pragma mark - Private

- (EMBigDayInfo *)buildBigDayInfoWithResult:(FMResultSet *)result
{
    EMBigDayInfo *dayInfo = [[EMBigDayInfo alloc] init];
    dayInfo.bigDayId = [[result stringForColumn:@"bigDayId"] integerValue];
    dayInfo.bigDayName = [result stringForColumn:@"bigDayName"];
    dayInfo.bigDayType = [result stringForColumn:@"bigDayType"];
    dayInfo.bigDayDate = [result stringForColumn:@"bigDayDate"];
    dayInfo.bigDayRemark = [result stringForColumn:@"bigDayRemark"];
    return dayInfo;
}

@end

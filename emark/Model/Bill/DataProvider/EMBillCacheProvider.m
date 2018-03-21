//
//  EMBillCacheProvider.m
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBillCacheProvider.h"
#import "FMDB.h"

@implementation EMBillCacheProvider

#pragma mark - Override

- (NSString *)name
{
    return @"emark_bill_list";
}


- (NSInteger)version
{
    return 1;
}


- (BOOL)onCreateTable:(FMDatabase *)db
{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS emark_bill_list ("
    @"billId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
    @"billType               INTEGER, "
    @"billCount              REAL, "
    @"billDate               DATE, "
    @"billRemark             TEXT "
    @");";
    
    BOOL result = [db executeUpdate:sql];
    return result;
}


#pragma mark - Public

- (NSArray<EMBillInfo *> *)selectBillInfosBeforeDate:(NSDate *)date totalCount:(NSInteger)totalCount
{
    __weak typeof(self) weakSelf = self;
    NSMutableArray *tmpArr = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = nil;
        if (nil == date) {
            result = [db executeQuery:@"SELECT * FROM emark_bill_list ORDER BY billDate DESC LIMIT ? ", @(totalCount)];
        } else {
            result = [db executeQuery:@"SELECT * FROM emark_bill_list WHERE billDate < ? ORDER BY billDate DESC LIMIT ? ", date, @(totalCount)];
        }
        
        while (result.next) {
            EMBillInfo *billInfo = [weakSelf buildBillInfoWithResult:result];
            [tmpArr addObject:billInfo];
        }
        [result close];
    }];
    
    return tmpArr;
}


- (void)cacheBillInfo:(EMBillInfo *)billInfo
{
    if (nil == billInfo) {
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL success = [db executeUpdate:@"INSERT INTO "
         @"emark_bill_list (billId, billType, billCount, billDate, "
         @"billRemark"
         @") "
    
         @"VALUES (?, ?, ?, ?, ?"
         @")",
         nil, @(billInfo.billType), @(billInfo.billCount), billInfo.billDate,
         billInfo.billRemark];
        //插入成功后要更新内存中的账单id以便删除时使用
        if (success) {
            FMResultSet *result = [db executeQuery:@"SELECT * FROM emark_bill_list ORDER BY billId DESC LIMIT 1 "];
            while (result.next) {
                billInfo.billId = [[result stringForColumn:@"billId"] integerValue];
            }
        }
    }];
}


- (void)deleteBillInfo:(EMBillInfo *)billInfo
{
    if (nil == billInfo) {
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM emark_bill_list WHERE billId = ?", @(billInfo.billId)];
    }];
}


- (NSArray<EMBillInfo *> *)selectBillInfosBetween:(NSDate *)fromDate and:(NSDate *)toDate
{
    __weak typeof(self) weakSelf = self;
    NSMutableArray *tmpArr = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = nil;
        
        result = [db executeQuery:@"SELECT * FROM emark_bill_list WHERE billDate >= ? AND billDate <= ?", fromDate, toDate];
        
        while (result.next) {
            EMBillInfo *billInfo = [weakSelf buildBillInfoWithResult:result];
            [tmpArr addObject:billInfo];
        }
        [result close];
    }];
    
    return tmpArr;
}

#pragma mark - Private

- (EMBillInfo *)buildBillInfoWithResult:(FMResultSet *)result
{
    EMBillInfo *billInfo = [[EMBillInfo alloc] init];
    billInfo.billId = [[result stringForColumn:@"billId"] integerValue];
    billInfo.billType = [[result stringForColumn:@"billType"] integerValue];
    billInfo.billDate = [result dateForColumn:@"billDate"];
    billInfo.billCount = [result doubleForColumn:@"billCount"];
    billInfo.billRemark = [result stringForColumn:@"billRemark"];
    return billInfo;
}

@end

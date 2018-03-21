//
//  EMPlaceCacheProvider.m
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMPlaceCacheProvider.h"
#import "FMDB.h"

@implementation EMPlaceCacheProvider

#pragma mark - Override

- (NSString *)name
{
    return @"emark_place_list";
}


- (NSInteger)version
{
    return 1;
}


- (BOOL)onCreateTable:(FMDatabase *)db
{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS emark_place_list ("
    @"placeId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
    @"placeName              TEXT, "
    @"goodsName              TEXT "
    @");";
    
    BOOL result = [db executeUpdate:sql];
    return result;
}


#pragma mark - Public

- (NSArray<EMPlaceInfo *> *)selectPlaceInfosFromStart:(NSInteger)startIndex
                                           totalCount:(NSInteger)totalCount
{
    __weak typeof(self) weakSelf = self;
    NSMutableArray *tmpArr = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = nil;
        if (0 == startIndex) {
            result = [db executeQuery:@"SELECT * FROM emark_place_list ORDER BY placeId DESC LIMIT ? ", @(totalCount)];
        } else {
            result = [db executeQuery:@"SELECT * FROM emark_place_list where placeId < ? ORDER BY placeId DESC LIMIT ? ", @(startIndex), @(totalCount)];
        }
        
        while (result.next) {
            EMPlaceInfo *placeInfo = [weakSelf buildPlaceInfoWithResult:result];
            [tmpArr addObject:placeInfo];
        }
        [result close];
    }];
    
    return tmpArr;
}


- (void)cachePlaceInfo:(EMPlaceInfo *)placeInfo
{
    if (nil == placeInfo) {
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL success = [db executeUpdate:@"INSERT INTO "
         @"emark_place_list (placeId, placeName, goodsName"
         @") "
    
         @"VALUES (?, ?, ?"
         @")",
         nil, placeInfo.placeName, placeInfo.goodsName];
        //插入成功后要更新内存中的placeId以便删除时使用
        if (success) {
            FMResultSet *result = [db executeQuery:@"SELECT * FROM emark_place_list ORDER BY placeId DESC LIMIT 1 "];
            while (result.next) {
                placeInfo.placeId = [[result stringForColumn:@"placeId"] integerValue];
            }
        }
    }];
}


- (void)deletePlaceInfo:(EMPlaceInfo *)placeInfo
{
    if (nil == placeInfo) {
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM emark_place_list WHERE placeId = ?", @(placeInfo.placeId)];
    }];
}

#pragma mark - Private

- (EMPlaceInfo *)buildPlaceInfoWithResult:(FMResultSet *)result
{
    EMPlaceInfo *placeInfo = [[EMPlaceInfo alloc] init];
    placeInfo.placeId = [[result stringForColumn:@"placeId"] integerValue];
    placeInfo.placeName = [result stringForColumn:@"placeName"];
    placeInfo.goodsName = [result stringForColumn:@"goodsName"];
    return placeInfo;
}

@end

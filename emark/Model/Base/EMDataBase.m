//
//  EMDataBase.m
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMDataBase.h"
#import "FMDB.h"

NSInteger const kEMInvalidVersion = 0;

@interface EMDatabase()

@property (atomic) FMDatabaseQueue     *dbQueue;

//数据库内表的版本号
@property (atomic, copy) NSDictionary<NSString*, NSNumber *> *tableVersionMap;

@end

@implementation EMDatabase

- (instancetype)initWithDBPath:(NSString *)path
{
    self = [super init];
    if (self) {
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
        [self loadTableVersions];
    }
    
    return self;
}


- (void)loadTableVersions
{
    __weak __typeof(self) weakSelf = self;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        BOOL isSuccessed = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS table_versions ("
                            @"name TEXT PRIMARY KEY, "
                            @"version INTEGER DEFAULT 0);"];
        if (isSuccessed) {
            [db executeUpdate:@"CREATE INDEX IF NOT EXISTS index_name ON table_versions(name);"];
        }
        
        
        FMResultSet * resultSet = [db executeQuery:@"SELECT * FROM table_versions"];
        NSMutableDictionary *versionsDict = [NSMutableDictionary dictionary];
        while ([resultSet next]) {
            NSString * tableName = [resultSet stringForColumn:@"name"];
            NSInteger version = [resultSet intForColumn:@"version"];
            if (tableName.length > 0) {
                [versionsDict setObject:@(version) forKey:tableName];
            }
        }
        [resultSet close];
        
        weakSelf.tableVersionMap = versionsDict;
    }];
}


- (NSInteger)getVersionOfTable:(NSString *)tableName
{
    NSNumber * versionNum = nil;
    if (nil == self.tableVersionMap) {
        return kEMInvalidVersion;
    }
    
    versionNum = [self.tableVersionMap objectForKey:tableName];
    
    if (nil == versionNum) {
        return kEMInvalidVersion;
    }
    
    return [versionNum integerValue];
}


- (BOOL)updateVersion:(NSInteger)version ofTable:(NSString *)tableName
{
    if (tableName.length == 0) {
        return NO;
    }
    
    NSAssert(version > 0, @"The version of table %@ should be bigger than 0!", tableName);
    
    NSInteger currVersion = [self getVersionOfTable:tableName];
    if (currVersion == version) {
        return NO;
    }
    
    __block BOOL isSuccessed = NO;
    __weak __typeof(self) weakSelf = self;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        isSuccessed = [db executeUpdate:@"INSERT OR REPLACE INTO table_versions (name, version) VALUES(?, ?);", tableName, @(version)];
        if (isSuccessed) {
            NSMutableDictionary * versionsDict = [NSMutableDictionary dictionaryWithDictionary:weakSelf.tableVersionMap];
            [versionsDict setObject:@(version) forKey:tableName];
            
            weakSelf.tableVersionMap = versionsDict;
        }
        
    }];
    
    return isSuccessed;
}

@end

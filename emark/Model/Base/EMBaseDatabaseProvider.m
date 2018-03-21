//
//  EMBaseDatabaseProvider.m
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBaseDatabaseProvider.h"
#import "FMDB.h"

@implementation EMBaseDatabaseProvider

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark - Implemente EMBaseDataProvider

- (NSString *)name
{
    NSAssert(NO, @"tableName should not be nil!");
    return nil;
}


- (NSInteger)version
{
    return 1;
}


- (BOOL)onCreateTable:(FMDatabase *)db
{
    NSAssert(NO, @"SEL(onCreateTable:) should be override");
    return NO;
}


- (BOOL)onUpgradeTable:(FMDatabase *)db fromVersion:(NSInteger)fromVersion toVersion:(NSInteger)toVersion
{
    NSAssert(NO, @"SEL(onUpgradeTable: fromVersion: toVersion:) should be override");
    return NO;
}


- (FMDatabaseQueue *)dbQueue
{
    NSAssert(NO, @"SEL(dbQueue) should be override");
    return nil;
}



#pragma mark - Public

- (void)buildTable:(EMDatabase *)databse
{
    if ([NSThread isMainThread]) {
        NSLog(@"Don't build table in main thread!");
    }
    
    if (0 == self.name.length) {
        return;
    }
    
    NSInteger version = [databse getVersionOfTable:self.name];
    NSInteger latestVersion = [self version];
    __block BOOL updatedVersion = NO;
    
    if (version == kEMInvalidVersion) {
        __weak __typeof(self) weakSelf = self;
        [databse.dbQueue inDatabase:^(FMDatabase *db) {
            updatedVersion = [weakSelf onCreateTable:db];
        }];
        
        
    } else if (latestVersion > version) {
        __weak __typeof(self) weakSelf = self;
        [databse.dbQueue inDatabase:^(FMDatabase *db) {
            updatedVersion = [weakSelf onUpgradeTable:db fromVersion:version toVersion:latestVersion];
        }];
    }
    
    if (updatedVersion) {
        [databse updateVersion:latestVersion ofTable:self.name];
    }
}

@end

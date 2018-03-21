//
//  EMBaseDatabaseCommonProvider.m
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBaseDatabaseCommonProvider.h"
#import "EMFileUtil.h"

@interface EMBaseDatabaseCommonProvider()

@property (nonatomic, strong) EMDatabase *database;

@end

@implementation EMBaseDatabaseCommonProvider

- (instancetype)init
{
    self = [super init];
    if (self) {
        _database = [[self class] getDefaultDatabase];
        [self buildTable:_database];
    }
    
    return self;
}


#pragma mark - Override

- (FMDatabaseQueue *)dbQueue
{
    return self.database.dbQueue;
}


#pragma mark - Class

+ (EMDatabase *)getDefaultDatabase
{
    static EMDatabase *sDatabase;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString * dbPath = [[EMFileUtil dataRootPath] stringByAppendingPathComponent:@"emark.dat"];
        sDatabase = [[EMDatabase alloc] initWithDBPath:dbPath];
        sDatabase.tag = @"common";
    });
    
    return sDatabase;
}

@end

//
//  EMDataBase.h
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSInteger const kEMInvalidVersion;

@class FMDatabase;
@class FMDatabaseQueue;

@interface EMDatabase : NSObject

@property (readonly) FMDatabaseQueue    *dbQueue;
@property (nonatomic, copy) NSString    *tag;

/**
 *  初始化
 */
- (instancetype)initWithDBPath:(NSString *)path;


/**
 *  获取某个表的版本号
 *
 *  @param tableName 表名称
 *
 *  @return 版本号，没有表则返回kEMInvalidVersion(0)
 */
- (NSInteger)getVersionOfTable:(NSString *)tableName;


/**
 *  更新某个表的版本号，正常的版本号应该是：version > 0
 *
 *  @param version   版本号
 *  @param tableName 表名称
 *
 */
- (BOOL)updateVersion:(NSInteger)version ofTable:(NSString *)tableName;

@end

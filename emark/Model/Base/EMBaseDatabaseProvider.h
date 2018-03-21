//
//  EMBaseDatabaseProvider.h
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBaseDataProvider.h"
#import "EMDataBase.h"

//接口表示子类需要重写的
@protocol EMBaseDatabaseProvider <EMBaseDataProvider>

/**
 *  创建表
 *  @return  是否创建成功
 */
- (BOOL)onCreateTable:(FMDatabase *)db;


/**
 *  更新表
 *  @return 是否更新成功
 */
- (BOOL)onUpgradeTable:(FMDatabase *)db fromVersion:(NSInteger)fromVersion toVersion:(NSInteger)toVersion;

@end

@interface EMBaseDatabaseProvider : EMBaseDataProvider<EMBaseDatabaseProvider>

@property (nonatomic, readonly) FMDatabaseQueue * dbQueue;

/**
 * 根据database进行建表
 *
 */
- (void)buildTable:(EMDatabase *)database;

@end

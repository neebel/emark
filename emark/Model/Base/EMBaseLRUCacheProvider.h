//
//  EMBaseLRUCacheProvider.h
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBaseDataProvider.h"
#import "YYCache.h"

@interface EMBaseLRUCacheProvider : EMBaseDataProvider

@property (nonatomic, readonly) YYCache *yyCache;

- (instancetype)initWithName:(NSString *)name;

@end

//
//  EMBaseLRUCacheProvider.m
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBaseLRUCacheProvider.h"
#import "EMFileUtil.h"

@implementation EMBaseLRUCacheProvider

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        if (name) {
            NSString *path = [[EMFileUtil dataRootPath] stringByAppendingPathComponent:name];
            _yyCache = [[YYCache alloc] initWithPath:path];
        }
    }

    return self;
}


#pragma mark - Override

- (NSString *)name
{
    if (nil != _yyCache) {
        return _yyCache.name;
    }
    
    return NSStringFromClass([self class]);
}


- (NSInteger)version
{
    return 1;
}

@end

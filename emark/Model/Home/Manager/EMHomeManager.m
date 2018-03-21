//
//  EMHomeManager.m
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMHomeManager.h"

@interface EMHomeManager()

@property (nonatomic, strong) EMHomeHandler *handler;

@end

@implementation EMHomeManager

+ (instancetype)sharedManager
{
    static EMHomeManager *_sManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sManager = [[self alloc] init];
    });

    return _sManager;
}


- (void)fetchHeadInfoWithResultBlock:(EMResultBlock)resultBlock
{
    [self.handler fetchHeadInfoWithResultBlock:resultBlock];
}


- (void)cacheHeadInfo:(EMHomeHeadInfo *)headInfo
{
    [self.handler cacheHeadInfo:headInfo];
}


- (void)fetchConfigInfoWithResultBlock:(EMResultBlock)resultBlock
{
    [self.handler fetchConfigInfoWithResultBlock:resultBlock];
}


- (void)cacheConfigInfo:(EMAlertConfigInfo *)configInfo
{
    [self.handler cacheConfigInfo:configInfo];
}


- (EMHomeHandler *)handler
{
    if (!_handler) {
        _handler = [[EMHomeHandler alloc] init];
    }

    return _handler;
}

@end

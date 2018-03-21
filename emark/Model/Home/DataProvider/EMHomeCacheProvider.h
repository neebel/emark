//
//  EMHomeCacheProvider.h
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBaseLRUCacheProvider.h"
#import "EMHomeHeadInfo.h"
#import "EMAlertConfigInfo.h"

@interface EMHomeCacheProvider : EMBaseLRUCacheProvider

- (EMHomeHeadInfo *)queryHeadInfo;

- (void)cacheHeadInfo:(EMHomeHeadInfo *)headInfo;

- (EMAlertConfigInfo *)queryConfigInfo;

- (void)cacheConfigInfo:(EMAlertConfigInfo *)configInfo;

@end

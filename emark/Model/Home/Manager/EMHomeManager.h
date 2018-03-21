//
//  EMHomeManager.h
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMHomeHandler.h"

@interface EMHomeManager : NSObject

+ (instancetype)sharedManager;

- (void)fetchHeadInfoWithResultBlock:(EMResultBlock)resultBlock;

- (void)cacheHeadInfo:(EMHomeHeadInfo *)headInfo;

- (void)fetchConfigInfoWithResultBlock:(EMResultBlock)resultBlock;

- (void)cacheConfigInfo:(EMAlertConfigInfo *)configInfo;

@end

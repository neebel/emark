//
//  EMHomeCacheProvider.m
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMHomeCacheProvider.h"

static NSString *homeHeadInfoKey = @"homeHeadInfoKey";
static NSString *alertNotifiHasClearKey = @"alertNotifiHasClearKey";

@implementation EMHomeCacheProvider

- (EMHomeHeadInfo *)queryHeadInfo
{
    return (EMHomeHeadInfo *)[self.yyCache objectForKey:homeHeadInfoKey];
}


- (void)cacheHeadInfo:(EMHomeHeadInfo *)headInfo
{
    [self.yyCache setObject:headInfo forKey:homeHeadInfoKey];
}


- (EMAlertConfigInfo *)queryConfigInfo
{
    return (EMAlertConfigInfo *)[self.yyCache objectForKey:alertNotifiHasClearKey];
}


- (void)cacheConfigInfo:(EMAlertConfigInfo *)configInfo
{
    [self.yyCache setObject:configInfo forKey:alertNotifiHasClearKey];
}

@end

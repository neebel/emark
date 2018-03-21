//
//  EMBigDayManager.m
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBigDayManager.h"

@interface EMBigDayManager()

@property (nonatomic, strong) EMBigDayHandler *handler;

@end

@implementation EMBigDayManager

+ (instancetype)sharedManager
{
    static EMBigDayManager *_sManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sManager = [[self alloc] init];
    });
    
    return _sManager;
}


- (void)fetchBigDayInfosWithStartIndex:(NSInteger)startIndex
                            totalCount:(NSInteger)totalCount
                                result:(EMResultBlock)resultBlock
{
    [self.handler fetchBigDayInfosWithStartIndex:startIndex
                                      totalCount:totalCount
                                          result:resultBlock];
}


- (void)cacheBigDayInfo:(EMBigDayInfo *)bigDayInfo result:(void (^)(void))resultBlock
{
    [self.handler cacheBigDayInfo:bigDayInfo result:resultBlock];
}


- (void)deleteBigDayInfo:(EMBigDayInfo *)bigDayInfo result:(void (^)(void))resultBlock
{
    [self.handler deleteBigDayInfo:bigDayInfo result:resultBlock];
}


- (EMBigDayHandler *)handler
{
    if (!_handler) {
        _handler = [[EMBigDayHandler alloc] init];
    }
    
    return _handler;
}

@end

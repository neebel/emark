//
//  EMBillManager.m
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBillManager.h"

@interface EMBillManager()

@property (nonatomic, strong) EMBillHandler *handler;

@end

@implementation EMBillManager

+ (instancetype)sharedManager
{
    static EMBillManager *_sManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sManager = [[self alloc] init];
    });
    
    return _sManager;
}


- (void)fetchBillInfosBeforeDate:(NSDate *)date
                      totalCount:(NSInteger)totalCount
                          result:(EMResultBlock)resultBlock
{
    [self.handler fetchBillInfosBeforeDate:date
                                totalCount:totalCount
                                    result:resultBlock];
}


- (void)cacheBillInfo:(EMBillInfo *)billInfo result:(void (^)(void))resultBlock
{
    [self.handler cacheBillInfo:billInfo result:resultBlock];
}


- (void)deleteBillInfo:(EMBillInfo *)billInfo result:(void (^)(void))resultBlock
{
    [self.handler deleteBillInfo:billInfo result:resultBlock];
}


- (void)fetchMonthBillInMonth:(NSString *)month result:(EMResultBlock)resultBlock
{
    [self.handler fetchMonthBillInMonth:month result:resultBlock];
}


- (EMBillHandler *)handler
{
    if (!_handler) {
        _handler = [[EMBillHandler alloc] init];
    }
    
    return _handler;
}

@end

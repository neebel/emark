//
//  EMBaseHandler.m
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBaseHandler.h"

@interface EMBaseHandler()

@property (nonatomic, strong) dispatch_queue_t handleQueue;

@end

@implementation EMBaseHandler

- (instancetype)initWithQueue:(dispatch_queue_t)queue
{
    self = [super init];
    if (self) {
        _handleQueue = queue;
    }

    return self;
}


#pragma mark - Getter

- (dispatch_queue_t)handleQueue
{
    if (!_handleQueue) {
        const char * queueName = [NSStringFromClass(self.class) UTF8String];
        _handleQueue = dispatch_create_serial_queue_for_name(queueName);
    }
    
    return _handleQueue;
}

- (dispatch_queue_t)callBackQueue
{
    if (nil == _callBackQueue) {
        return dispatch_get_main_queue();
    }
    
    return _callBackQueue;
}
@end

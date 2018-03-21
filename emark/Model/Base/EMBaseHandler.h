//
//  EMBaseHandler.h
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMBaseHandler : NSObject

//处理Queue，调getter方法会自动生成，也可以通过initWithQueue传入
@property (nonatomic, readonly) dispatch_queue_t    handleQueue;

//回调的Queue，默认为main queue
@property (nonatomic, strong)   dispatch_queue_t    callBackQueue;


/**
 *  初始化
 *
 *  @param queue 查询或者请求的queue
 *
 */
- (instancetype)initWithQueue:(dispatch_queue_t)queue;

@end

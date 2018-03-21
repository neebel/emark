//
//  EMQueueDef.h
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>

__BEGIN_DECLS

#pragma mark - Create Queue
/**
 *  创建串行线程队列queue
 *
 *  @param name queue的名称
 *
 *  @return 返回创建的queue
 */
dispatch_queue_t dispatch_create_serial_queue_for_name(const char * name);


/**
 *  创建并行线程队列queue
 *
 *  @param name queue的名称
 *
 *  @return 返回创建的queue
 */
dispatch_queue_t dispatch_create_concurrent_queue_for_name(const char * name);



#pragma mark - check queue

/**
 *  返回当前所在的queue是否是主线程所在的queue
 *
 */
BOOL dispatch_current_queue_is_main_queue();



/**
 *  返回当前的线程队列是否是目标queue
 *
 *  @param queue 对比的queue
 *
 */
BOOL dispatch_current_queue_same_as(dispatch_queue_t queue);



#pragma mark - Run block in queue

/**
 *  在queue同步执行block，注意与dispatch_sync的区别
 *  当前函数就在queue的线程内执行，则直接执行block；
 *  当前函数在其他queue内，则调用dispatch_sync执行
 *
 *  @param queue 目标线程池
 *  @param block 执行的block
 */
void dispatch_sync_in_queue(dispatch_queue_t queue, dispatch_block_t block);



/**
 *  在queue异步执行block，注意与dispatch_async的区别
 *  当前函数就在queue的线程内执行，则直接执行block；
 *  当前函数在其他queue内，则调用dispatch_async执行
 *
 *  @param queue 目标线程池
 *  @param block 执行的block
 */
void dispatch_async_in_queue(dispatch_queue_t queue, dispatch_block_t block);



/**
 *  同步在主线程上执行block
 *
 */
void dispatch_sync_in_main_queue(dispatch_block_t block);




/**
 *  异步到主线程上执行block
 *
 */
void dispatch_async_in_main_queue(dispatch_block_t block);


__END_DECLS

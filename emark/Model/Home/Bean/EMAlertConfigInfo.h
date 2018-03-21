//
//  EMAlertConfigInfo.h
//  emark
//
//  Created by neebel on 2017/6/11.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMAutoCoding.h"

@interface EMAlertConfigInfo : EMAutoCoding

@property (nonatomic, assign) BOOL hasClearAlert;//app卸载后再重装，以前的通知需要全部清除，不清楚的话还会提醒

@end

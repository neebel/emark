//
//  EMMonthBillLegend.h
//  emark
//
//  Created by neebel on 2017/6/8.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMBillMonthInfo.h"

@interface EMMonthBillLegend : UIView

- (void)updateViewWithType:(NSString *)type billInfo:(EMBillMonthInfo *)info;

@end

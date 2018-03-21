//
//  EMMonthBillTableViewCell.h
//  emark
//
//  Created by neebel on 2017/6/6.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMBillMonthInfo.h"

@interface EMMonthBillTableViewCell : UITableViewCell

- (void)updateCellWithTitle:(NSString *)title monthInfo:(EMBillMonthInfo *)info;

@end

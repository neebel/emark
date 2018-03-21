//
//  EMBillTableViewCell.h
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMBillInfo.h"

@interface EMBillTableViewCell : UITableViewCell

- (void)updateCellWithBillInfo:(EMBillInfo *)billInfo;

@end

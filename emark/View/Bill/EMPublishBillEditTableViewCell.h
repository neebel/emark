//
//  EMPublishBillEditTableViewCell.h
//  emark
//
//  Created by neebel on 2017/6/1.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMBillItemInfo.h"

@interface EMPublishBillEditTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextField *valueTextField;

- (void)updateCellWithItemInfo:(EMBillItemInfo *)info;

@end

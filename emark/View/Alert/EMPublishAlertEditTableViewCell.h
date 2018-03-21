//
//  EMPublishAlertEditTableViewCell.h
//  emark
//
//  Created by neebel on 2017/6/1.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAlertItemInfo.h"

@interface EMPublishAlertEditTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextField *valueTextField;

- (void)updateCellWithItemInfo:(EMAlertItemInfo *)info;

@end

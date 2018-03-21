//
//  EMPublishBigDayEditTableViewCell.h
//  emark
//
//  Created by neebel on 2017/6/1.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMBigDayItemInfo.h"

@interface EMPublishBigDayEditTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextField *valueTextField;

- (void)updateCellWithItemInfo:(EMBigDayItemInfo *)info;

@end

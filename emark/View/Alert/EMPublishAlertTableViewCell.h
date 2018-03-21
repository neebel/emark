//
//  EMPublishAlertTableViewCell.h
//  emark
//
//  Created by neebel on 2017/5/31.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAlertItemInfo.h"

@interface EMPublishAlertTableViewCell : UITableViewCell

- (void)updateCellWithItemInfo:(EMAlertItemInfo *)info;

@end

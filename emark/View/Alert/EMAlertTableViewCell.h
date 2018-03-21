//
//  EMAlertTableViewCell.h
//  emark
//
//  Created by neebel on 2017/6/3.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAlertInfo.h"

@interface EMAlertTableViewCell : UITableViewCell

- (void)updateCellWithAlertInfo:(EMAlertInfo *)alertInfo color:(UIColor *)color;

@end

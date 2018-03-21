//
//  EMDiaryNoPicTableViewCell.h
//  emark
//
//  Created by neebel on 2017/5/30.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMDiaryInfo.h"

@interface EMDiaryNoPicTableViewCell : UITableViewCell

- (void)updateCellWithDiaryInfo:(EMDiaryInfo *)diaryInfo;

@end

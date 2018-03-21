//
//  EMBillHeaderView.h
//  emark
//
//  Created by neebel on 2017/6/5.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EMBillHeaderViewDelegate <NSObject>

- (void)enterMonthBillWithMonth:(NSString *)month;

@end

@interface EMBillHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<EMBillHeaderViewDelegate> delegate;

- (void)updateViewWithTitle:(NSString *)title;

@end

//
//  EMDatePicker.h
//  emark
//
//  Created by neebel on 2017/6/1.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EMDatePickerDelegate <NSObject>

@optional

- (void)leftButtonAction;
- (void)rightButtonAction;
- (void)changeTime:(UIDatePicker *)datePicker;

@end

@interface EMDatePicker : NSObject

@property (nonatomic, weak) id<EMDatePickerDelegate> delegate;

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode;

- (void)setMinimumDate:(NSDate *)minimumDate;

- (void)show;

@end

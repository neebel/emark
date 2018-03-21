//
//  EMBillTypePicker.h
//  emark
//
//  Created by neebel on 2017/6/5.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EMBillTypePickerDelegate <NSObject>

@optional

- (void)leftButtonAction;
- (void)rightButtonAction;
- (void)pickerViewDidSelectType:(NSString *)type subType:(NSString *)subType;

@end

@interface EMBillTypePicker : NSObject

@property (nonatomic, weak) id<EMBillTypePickerDelegate> delegate;

- (void)show;

@end

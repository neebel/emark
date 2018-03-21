//
//  EMPlaceHolderTextView.h
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMPlaceHolderTextView : UITextView

@property(nonatomic, copy) NSString *placeholder;

- (instancetype)initWithFrame:(CGRect)frame placeHolderPosition:(CGPoint)placeHolderPosition;

@end

//
//  EMSettingActionSheet.h
//  emark
//
//  Created by neebel on 2017/5/28.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EMSettingActionSheetDelegate <NSObject>

- (void)takePhoto;
- (void)searchFromAlbum;

@end

@interface EMSettingActionSheet : NSObject

@property (nonatomic, weak) id<EMSettingActionSheetDelegate> delegate;

- (void)show;

@end

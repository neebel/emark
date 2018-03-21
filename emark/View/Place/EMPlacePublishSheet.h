//
//  EMPlacePublishSheet.h
//  emark
//
//  Created by neebel on 2017/6/2.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMPlaceInfo.h"

@protocol EMPlacePublishSheetDelegate <NSObject>

- (void)confirmWithPlaceInfo:(EMPlaceInfo *)placeInfo;

@end

@interface EMPlacePublishSheet : NSObject

@property (nonatomic, weak) id<EMPlacePublishSheetDelegate> delegate;

- (void)show;

- (void)dismiss;

@end

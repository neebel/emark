//
//  EMDeviceUtil.h
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMDeviceUtil : NSObject

@property (nonatomic, copy, readonly)   NSString *appName;
@property (nonatomic, copy, readonly)   NSString *appVersion;
@property (nonatomic, copy, readonly)   NSString *appBuildVersion;
@property (nonatomic, strong, readonly) UIImage  *appIcon;

+ (instancetype)sharedDevice;

@end

//
//  EMFileUtil.h
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMFileUtil : NSObject

//应用Documents所在目录
+ (NSString *)documentsPath;

//保存应用数据的根目录
+ (NSString *)dataRootPath;

@end

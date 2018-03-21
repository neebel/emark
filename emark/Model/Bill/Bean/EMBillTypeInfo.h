//
//  EMBillTypeInfo.h
//  emark
//
//  Created by neebel on 2017/6/5.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMAutoCoding.h"

@interface EMBillTypeInfo : EMAutoCoding

@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, strong) NSArray *groupItems;

@end

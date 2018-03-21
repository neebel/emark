//
//  EMBigDayInfo.h
//  emark
//
//  Created by neebel on 2017/6/1.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMAutoCoding.h"

@interface EMBigDayInfo : EMAutoCoding

@property (nonatomic, assign) NSInteger bigDayId;
@property (nonatomic, copy)   NSString  *bigDayName;
@property (nonatomic, copy)   NSString  *bigDayType;
@property (nonatomic, copy)   NSString  *bigDayDate;
@property (nonatomic, copy)   NSString  *bigDayRemark;
@property (nonatomic, assign) BOOL      showDelete;

@end

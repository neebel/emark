//
//  EMPlaceInfo.h
//  emark
//
//  Created by neebel on 2017/6/2.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMAutoCoding.h"

@interface EMPlaceInfo : EMAutoCoding

@property (nonatomic, assign) NSInteger placeId;
@property (nonatomic, strong) NSString  *placeName;
@property (nonatomic, strong) NSString  *goodsName;

@end

//
//  EMPlaceCacheProvider.h
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBaseDatabaseCommonProvider.h"
#import "EMPlaceInfo.h"

@interface EMPlaceCacheProvider : EMBaseDatabaseCommonProvider

- (NSArray<EMPlaceInfo *> *)selectPlaceInfosFromStart:(NSInteger)startIndex
                                           totalCount:(NSInteger)totalCount;

- (void)cachePlaceInfo:(EMPlaceInfo *)placeInfo;

- (void)deletePlaceInfo:(EMPlaceInfo *)placeInfo;

@end

//
//  EMPlaceHandler.h
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBaseHandler.h"
#import "EMPlaceCacheProvider.h"

@interface EMPlaceHandler : EMBaseHandler

- (void)fetchPlaceInfosWithStartIndex:(NSInteger)startIndex
                            totalCount:(NSInteger)totalCount
                                result:(EMResultBlock)resultBlock;

- (void)cachePlaceInfo:(EMPlaceInfo *)placeInfo result:(void (^)(void))resultBlock;

- (void)deletePlaceInfo:(EMPlaceInfo *)placeInfo result:(void (^)(void))resultBlock;

@end

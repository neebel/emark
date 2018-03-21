//
//  EMPlaceManager.m
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMPlaceManager.h"

@interface EMPlaceManager()

@property (nonatomic, strong) EMPlaceHandler *handler;

@end

@implementation EMPlaceManager

+ (instancetype)sharedManager
{
    static EMPlaceManager *_sManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sManager = [[self alloc] init];
    });
    
    return _sManager;
}


- (void)fetchPlaceInfosWithStartIndex:(NSInteger)startIndex
                            totalCount:(NSInteger)totalCount
                                result:(EMResultBlock)resultBlock
{
    [self.handler fetchPlaceInfosWithStartIndex:startIndex
                                      totalCount:totalCount
                                          result:resultBlock];
}


- (void)cachePlaceInfo:(EMPlaceInfo *)placeInfo result:(void (^)(void))resultBlock
{
    [self.handler cachePlaceInfo:placeInfo result:resultBlock];
}


- (void)deletePlaceInfo:(EMPlaceInfo *)placeInfo result:(void (^)(void))resultBlock
{
    [self.handler deletePlaceInfo:placeInfo result:resultBlock];
}


- (EMPlaceHandler *)handler
{
    if (!_handler) {
        _handler = [[EMPlaceHandler alloc] init];
    }
    
    return _handler;
}

@end

//
//  EMResult.h
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMResult<__covariant ObjectType> : NSObject

@property (nonatomic, strong) ObjectType    result;
@property (nonatomic, strong) NSError       *error;
@property (nonatomic, copy)   NSString      *message;

@end


typedef void (^EMResultBlock)(EMResult *result);

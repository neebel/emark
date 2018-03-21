//
//  EMAutoCoding.h
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMAutoCoding : NSObject<NSSecureCoding>

//coding

+ (NSDictionary *)codableProperties;
- (void)setWithCoder:(NSCoder *)aDecoder;

//property access

- (NSDictionary *)codableProperties;
- (NSDictionary *)dictionaryRepresentation;

//loading / saving

+ (instancetype)objectWithContentsOfFile:(NSString *)path;
- (BOOL)writeToFile:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile;

@end

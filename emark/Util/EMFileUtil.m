//
//  EMFileUtil.m
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMFileUtil.h"

@implementation EMFileUtil

+ (NSString *)documentsPath
{
    static NSString * sDocPath = nil;
    if (nil == sDocPath) {
        NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
        sDocPath = [paths lastObject];
    }
    
    return sDocPath;
}


+ (NSString *)libarayPath
{
    static NSString * sLibarayPath = nil;
    if (nil == sLibarayPath) {
        NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        sLibarayPath = [paths lastObject];
    }
    
    return sLibarayPath;
}


+ (NSString *)dataRootPath
{
    
    static NSString * sDataPath = nil;
    if (nil == sDataPath) {
        sDataPath = [[self libarayPath] stringByAppendingPathComponent:@"EMark"];
        BOOL isDir = NO;
        BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:sDataPath isDirectory:&isDir];
        if (!isExists || !isDir) {
            NSError * error = nil;
            BOOL sucessed = [[NSFileManager defaultManager] createDirectoryAtPath:sDataPath
                                                      withIntermediateDirectories:YES
                                                                       attributes:nil
                                                                            error:&error];
            if (!sucessed) {
                NSAssert(NO, @"Create data dir failed: %@! %@", sDataPath, error);
                sDataPath = nil;
            }
        }
    }
    
    return sDataPath;
}

@end

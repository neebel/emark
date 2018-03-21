//
//  EMDiaryInfo.h
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMAutoCoding.h"

@interface EMDiaryInfo : EMAutoCoding

@property (nonatomic, assign) NSInteger diaryId;
@property (nonatomic, copy)   NSString  *diaryDate;
@property (nonatomic, copy)   NSString  *diaryContent;
@property (nonatomic, strong) UIImage   *diaryMiddleImage;
@property (nonatomic, strong) UIImage   *diaryImage;

@end

//
//  EMDiaryEditViewController.h
//  emark
//
//  Created by neebel on 2017/5/31.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMDiaryInfo.h"

static NSString *diaryUpdateSuccessNotification = @"diaryUpdateSuccessNotification";

@interface EMDiaryEditViewController : UIViewController

@property (nonatomic, strong) EMDiaryInfo *diaryInfo;

@end

//
//  EMSettingViewController.h
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIView+EMTips.h"

typedef NS_ENUM(NSUInteger, EMSettingHeadImageType) {
    kEMSettingHeadImageTypeCamera,
    kEMSettingHeadImageTypeAlbum,
};

@interface EMSettingViewController : UIViewController

@end

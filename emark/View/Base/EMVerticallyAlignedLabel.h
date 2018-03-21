//
//  EMVerticallyAlignedLabel.h
//  emark
//
//  Created by neebel on 2017/5/30.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface EMVerticallyAlignedLabel : UILabel
{
    @private VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end

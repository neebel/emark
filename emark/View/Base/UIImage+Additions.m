//
//  UIImage+Additions.m
//  emark
//
//  Created by neebel on 2017/6/10.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)

- (UIImage *)aspectResizeWithWidth:(CGFloat)width
{
    CGFloat height = self.size.height * width / self.size.width;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end

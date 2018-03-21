//
//  EMToolbar.m
//  emark
//
//  Created by neebel on 2017/6/1.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMToolbar.h"

@implementation EMToolbar

- (instancetype)initWithFrame:(CGRect)frame leftButtonTitle:(NSString *)leftTitle middleLabel:(NSString *)middleLabelStr rightButtonTitle:(NSString *)rightTitle
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    [leftButton setTitle:leftTitle forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:self
                   action:@selector(toolbarLeftButtonClick)
         forControlEvents:UIControlEventTouchUpInside];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    UILabel *middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    middleLabel.text = middleLabelStr;
    middleLabel.textColor = [UIColor whiteColor];
    middleLabel.textAlignment = NSTextAlignmentCenter;
    middleLabel.font = [UIFont systemFontOfSize:15.0];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    [rightButton setTitle:rightTitle forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self
                    action:@selector(toolbarRightButtonClick)
          forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    return [self initWithFrame:frame leftView:leftButton middleView:middleLabel rightView:rightButton];
}

- (instancetype)initWithFrame:(CGRect)frame leftView:(UIView *)left middleView:(UIView *)middle rightView:(UIView *)rightView
{
    self = [self initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        
        
        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
        [barItems addObject:leftButtonItem];
        
        UIBarButtonItem *flexSpace0 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                    target:self
                                                                                    action:nil];
        [barItems addObject:flexSpace0];
        
        UIBarButtonItem *middleButtonItem = [[UIBarButtonItem alloc] initWithCustomView:middle];
        [barItems addObject:middleButtonItem];
        
        UIBarButtonItem *flexSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                    target:self
                                                                                    action:nil];
        [barItems addObject:flexSpace1];
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        [barItems addObject:rightButtonItem];
        [self setItems:barItems animated:YES];
    }
    
    return self;
}

#pragma mark - Override

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [UIColorFromHexRGB(0x1AAB19) set];
    CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
}

#pragma mark - Action

- (void)toolbarLeftButtonClick
{
    if (self.toolbarDelegate && [self.toolbarDelegate respondsToSelector:@selector(leftButtonAction)]) {
        [self.toolbarDelegate leftButtonAction];
    }
    
}


- (void)toolbarRightButtonClick
{
    if (self.toolbarDelegate && [self.toolbarDelegate respondsToSelector:@selector(rightButtonAction)]) {
        [self.toolbarDelegate rightButtonAction];
    }
}

@end

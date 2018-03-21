//
//  EMBaseNavigationController.m
//  emark
//
//  Created by neebel on 2017/5/26.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMBaseNavigationController.h"

@implementation EMBaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    EMTheme *theme = [EMTheme currentTheme];
    self.navigationBar.tintColor = theme.navTintColor;
    self.navigationBar.barTintColor = theme.navBarBGColor;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : theme.navTintColor, NSFontAttributeName : theme.navTitleFont};
    [self.navigationBar setShadowImage:[UIImage new]];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end

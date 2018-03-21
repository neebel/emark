//
//  EMSplashViewController.m
//  emark
//
//  Created by neebel on 2017/6/11.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMSplashViewController.h"
#import "EMHomeViewController.h"
#import "EMBaseNavigationController.h"

@interface EMSplashViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation EMSplashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf showHomeVC];
    });
}


- (void)initUI
{
    self.view.backgroundColor = [EMTheme currentTheme].navBarBGColor;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.imageView];
}


- (void)showHomeVC
{
    EMHomeViewController *vc = [[EMHomeViewController alloc] init];
    EMBaseNavigationController *nav = [[EMBaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.imageView removeFromSuperview];
    }];
}


- (UIImageView *)imageView
{
    if (!_imageView) {
        UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
        _imageView = [[UIImageView alloc] initWithFrame:mainWindow.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.image = [self launchImage];
    }

    return _imageView;
}


- (UIImage *)launchImage
{
    UIImage *image = nil;
    
    if (IS_5_5_INCH) {
        image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h"];
    } else if (IS_4_7_INCH) {
        image = [UIImage imageNamed:@"LaunchImage-800-667h"];
    } else if (IS_4_0_INCH) {
        image = [UIImage imageNamed:@"LaunchImage-700-568h"];
    } else if (IS_3_5_INCH) {
        image = [UIImage imageNamed:@"LaunchImage-700"];
    }

    return image;
}

@end

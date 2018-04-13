//
//  PlayViewController.m
//  Taro
//
//  Created by wushuying on 2018/4/11.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "PlayViewController.h"
#import "GolbalDefine.h"

@interface PlayViewController ()


@end


static NSString * const VIDEO_CONTROLLER_CLASS_NAME_IOS7 = @"MPInlineVideoFullscreenViewController";
static NSString * const VIDEO_CONTROLLER_CLASS_NAME_IOS8 = @"AVFullScreenViewController";


@implementation PlayViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES; // 返回YES表示隐藏，返回NO表示显示
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.player = [[AVPlayer alloc] initWithURL:self.videoUrl];
    [self.player play];
}


#pragma mark -- 需要设置全局支持旋转方向，然后重写下面三个方法可以让当前页面支持多个方向

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

@end

//
//  ViewController.m
//  Taro
//
//  Created by wushuying on 2018/3/16.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationBarButton:nil title:@"Taro" image:nil];
    [self setRightNavigationBarButton:@selector(galleryAction) title:@"Gallery" image:nil];
    self.navigationController.navigationBar.barTintColor = NaviBarColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

/**
 push to the Gallery viewController
 */
- (void)galleryAction{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

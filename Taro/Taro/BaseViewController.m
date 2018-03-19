//
//  RootNavigationController.m
//  Taro
//
//  Created by wushuying on 2018/3/18.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setRightNavigationBarButton:(SEL)action title:(NSString *)title image:(NSString *)image
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightButton.frame = CGRectMake(0, 0, 65, 44);
    [rightButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    rightButton.tintColor = [UIColor whiteColor];
    if (title) {
        [rightButton setTitle:title forState:UIControlStateNormal];
        if (image) {
            rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        }else{
            rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 64 - 14*title.length, 0, 0);
        }
        rightButton.titleLabel.font = RightNaviTitleFont;
    }
    if (image) {
        [rightButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        if (title) {
            rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        }else{
            rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 44, 0, 0);
        }
    }
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)setLeftNavigationBarButton:(SEL)action title:(NSString *)title image:(NSString *)image
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leftButton.frame = CGRectMake(0, 0, 65, 44);
    [leftButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    leftButton.tintColor = [UIColor whiteColor];
    if (title) {
        [leftButton setTitle:title forState:UIControlStateNormal];
        if (image) {
            leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        }else{
            leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 64 - 14*title.length);
        }
        leftButton.titleLabel.font = LeftNaviTitleFont;
    }
    if (image) {
        [leftButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 44);
    }
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

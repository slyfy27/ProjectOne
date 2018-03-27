//
//  RootNavigationController.h
//  Taro
//
//  Created by wushuying on 2018/3/18.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GolbalDefine.h"

@interface BaseViewController : UIViewController

- (void)setLeftNavigationBarButton:(SEL)action title:(NSString *)title image:(NSString *)image;

- (void)setRightNavigationBarButton:(SEL)action title:(NSString *)title image:(NSString *)image;

@end
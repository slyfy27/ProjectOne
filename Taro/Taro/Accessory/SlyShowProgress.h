//
//  SlyShowProgress.h
//  Taro
//
//  Created by wushuying on 2018/4/8.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlyShowProgress : UIView{
    UIActivityIndicatorView *activity;
}

+ (instancetype)shareInstance;

- (void)show;

- (void)dismiss;

@end

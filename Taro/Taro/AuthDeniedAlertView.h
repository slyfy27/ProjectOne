//
//  AuthDeniedAlertView.h
//  Taro
//
//  Created by wushuying on 2018/3/19.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void(^ChooseBlock)(NSInteger index);

@interface AuthDeniedAlertView : UIView
{
    BOOL isAnimation;
}

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UIImageView *iconImageView;

@property (strong, nonatomic) UILabel *contentLabel;

@property (strong, nonatomic) UIButton *comfirmBtn;

@property (nonatomic, copy) ChooseBlock choose;

/**
 *  显示
 */
- (void)show;

/**
 *  取消显示
 */
- (void)dismiss;

+ (void)alertWithIconName:(NSString *)iconName content:(NSString *)content choose:(ChooseBlock)choose;

@end

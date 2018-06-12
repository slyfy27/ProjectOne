//
//  AuthDeniedAlertView.m
//  Taro
//
//  Created by wushuying on 2018/3/19.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "AuthDeniedAlertView.h"
#import "UIView+Category.h"
#import "GolbalDefine.h"

@implementation AuthDeniedAlertView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupSelf];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSelf];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSelf];
    }
    return self;
}

- (void)setupSelf
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = UIColorFromRGBAndAlpha(000000, 0.3);
    self.userInteractionEnabled = YES;
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:(CGRect){0,0,360,110}];
        _contentView.center = self.center;
        [self addSubview:_contentView];
        UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0,0,360,3}];
        headerView.backgroundColor = AlertBlueColor;
        [_contentView addSubview:headerView];
        _contentView.layer.cornerRadius = 3;
        _contentView.layer.shadowColor = AlertBlueColor.CGColor;
        _contentView.layer.shadowOffset = CGSizeMake(2, 5);
        _contentView.layer.shadowOpacity = 0.5;
        _contentView.layer.shadowRadius = 5;
        _contentView.backgroundColor = [UIColor whiteColor];
        _iconImageView = [[UIImageView alloc] initWithFrame:(CGRect){20,20,20,29}];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_contentView addSubview:_iconImageView];
        _contentLabel = [[UILabel alloc] initWithFrame:(CGRect){60,20,280,32}];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = AlertContentFont;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 2;
        [_contentView addSubview:_contentLabel];
        _comfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _comfirmBtn.frame = CGRectMake(270, 75, 67, 24);
        [_comfirmBtn setTitle:NSLocalizedString(@"AlertComfirmTitle", nil) forState:UIControlStateNormal];
        _comfirmBtn.titleLabel.font = AlertContentFont;
        [_comfirmBtn setTitleColor:AlertBlueColor forState:UIControlStateNormal];
        [_comfirmBtn setBackgroundColor:AlertButtonBackColor];
        _comfirmBtn.layer.cornerRadius = 3;
        [_comfirmBtn addTarget:self action:@selector(comfirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_comfirmBtn];
    }
}

- (void)comfirmBtnAction{
    self.choose(1);
    [self dismiss];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isAnimation) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *testView = [self hitTest:location withEvent:event];
    if ([testView isKindOfClass:[UIButton class]]) {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }else{
        [self dismiss];
    }
}

- (void)show{
    if (isAnimation) {
        return;
    }
    isAnimation = YES;
    
    self.contentView.frame_y = self.bounds.size.height;
    self.alpha = 0.0;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.75 initialSpringVelocity:0.8 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.contentView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    } completion:^(BOOL finished) {
        isAnimation = NO;
    }];
}

- (void)dismiss
{
    if (isAnimation) {
        return;
    }
    isAnimation = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.75 initialSpringVelocity:0.8 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.contentView.frame_y = self.bounds.size.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        isAnimation = NO;
    }];
}

+ (void)alertWithIconName:(NSString *)iconName content:(NSString *)content comfirmTitle:(NSString *)comfireTitle choose:(ChooseBlock)choose{
    AuthDeniedAlertView *alert = [[AuthDeniedAlertView alloc] init];
    alert->_contentLabel.text = content;
    alert->_iconImageView.image = [UIImage imageNamed:iconName];
    alert->_choose = choose;
    [alert->_comfirmBtn setTitle:comfireTitle forState:UIControlStateNormal];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    [alert show];
}

@end

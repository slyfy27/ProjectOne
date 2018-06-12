//
//  SlyShowProgress.m
//  Taro
//
//  Created by wushuying on 2018/4/8.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "SlyShowProgress.h"
#import "GolbalDefine.h"

@implementation SlyShowProgress

+ (instancetype)shareInstance{
    static SlyShowProgress *_shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[SlyShowProgress alloc] init];
    });
    return _shareManager;
}

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

- (void)setupSelf{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = UIColorFromRGBAndAlpha(000000, 0.3);
    self.userInteractionEnabled = YES;
    activity = [[UIActivityIndicatorView alloc] initWithFrame:(CGRect){0,0,100,100}];
    activity.center = self.center;
    [self addSubview:activity];
}

- (void)show{
    dispatch_async(dispatch_get_main_queue(), ^{
        [activity startAnimating];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    });
}

- (void)dismiss{
    dispatch_async(dispatch_get_main_queue(), ^{
        [activity stopAnimating];
        [self removeFromSuperview];
    });
}

@end

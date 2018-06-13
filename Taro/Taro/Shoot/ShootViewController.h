//
//  ShootViewController.h
//  Taro
//
//  Created by wushuying on 2018/3/27.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "BaseViewController.h"
#import "YYKit.h"

@interface ShootViewController : BaseViewController<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *bluetoothBtn;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *deviceBtn;
@property (weak, nonatomic) IBOutlet UIButton *yuntaiBtn;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIView *settingView;
@property (weak, nonatomic) IBOutlet UILabel *settingTitle;
@property (weak, nonatomic) IBOutlet UITableView *settingTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingViewLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingViewWidth;
@property (weak, nonatomic) IBOutlet UITableView *subTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maskViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maskViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trackingAlertViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *trackingAlertView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *recordTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *turnOffBtn;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet UILabel *recordViewTimeLabel;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *gifImageView;
@property (weak, nonatomic) IBOutlet UIButton *trakingBtn;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIImageView *redImageView;
@property (weak, nonatomic) IBOutlet UIImageView *maskRedImageView;
@property (weak, nonatomic) IBOutlet UIView *settingMaskView;

@end

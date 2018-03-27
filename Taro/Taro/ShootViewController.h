//
//  ShootViewController.h
//  Taro
//
//  Created by wushuying on 2018/3/27.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "BaseViewController.h"

@interface ShootViewController : BaseViewController
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

@end

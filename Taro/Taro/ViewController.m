//
//  ViewController.m
//  Taro
//
//  Created by wushuying on 2018/3/16.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "ViewController.h"
#import "GalleryViewController.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AuthDeniedAlertView.h"
#import "BluetoothManager.h"
#import "ShootViewController.h"
#import "SlyShowProgress.h"

@interface ViewController ()

@property (assign, nonatomic) NSInteger authCount;
@property (weak, nonatomic) IBOutlet UIButton *startbtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationBarButton:nil title:@"Taro" image:nil];
    [self setRightNavigationBarButton:@selector(galleryAction) title:@"Gallery" image:nil];
    [BluetoothManager shareInstance];
    self.navigationController.navigationBar.barTintColor = NaviBarColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    _authCount = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoCamera) name:@"deviceConnected" object:nil];
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(startLongPress:)];
    [self.startbtn addGestureRecognizer:longGesture];
}

- (void)startLongPress:(UIGestureRecognizer *)gesture{
    //长按开始
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstAuth"]) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                        if (granted) {
                            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (status == PHAuthorizationStatusAuthorized) {
                                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstAuth"];
                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                        ShootViewController *vc = [[ShootViewController alloc] init];
                                        [self.navigationController pushViewController:vc animated:YES];
                                    }
                                    else{
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [AuthDeniedAlertView alertWithIconName:@"保存" content:NSLocalizedString(@"PhotoAuthDenied", nil) comfirmTitle:NSLocalizedString(@"AlertComfirmTitle",nil) choose:^(NSInteger index) {
                                                if (index == 1) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                                                            
                                                        }];
                                                    });
                                                }
                                            }];
                                        });
                                    }
                                });
                            }];
                        }
                        else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [AuthDeniedAlertView alertWithIconName:@"麦克风" content:NSLocalizedString(@"MicrophoneAuthDenied", nil) comfirmTitle:NSLocalizedString(@"AlertComfirmTitle",nil) choose:^(NSInteger index) {
                                    if (index == 1) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                                                
                                            }];
                                        });
                                    }
                                }];
                            });
                        }
                    }];
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [AuthDeniedAlertView alertWithIconName:@"录像" content:NSLocalizedString(@"CameraAuthDenied", nil) comfirmTitle:NSLocalizedString(@"AlertComfirmTitle",nil) choose:^(NSInteger index) {
                            if (index == 1) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                                    }];
                                });
                            }
                        }];
                    });
                }
            }];
        }
        else{
            if ([self CameraAuthStatus]) {
                if ([self microphoneAuthStatus]) {
                    if ([self photoLibraryAuthStatus]) {
                        ShootViewController *vc = [[ShootViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else{
                        [AuthDeniedAlertView alertWithIconName:@"保存" content:NSLocalizedString(@"PhotoAuthDenied", nil) comfirmTitle:NSLocalizedString(@"AlertComfirmTitle",nil) choose:^(NSInteger index) {
                            if (index == 1) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                                        
                                    }];
                                });
                            }
                        }];
                    }
                }
                else{
                    [AuthDeniedAlertView alertWithIconName:@"麦克风" content:NSLocalizedString(@"MicrophoneAuthDenied", nil) comfirmTitle:NSLocalizedString(@"AlertComfirmTitle",nil) choose:^(NSInteger index) {
                        if (index == 1) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                                    
                                }];
                            });
                        }
                    }];
                }
            }
            else{
                [AuthDeniedAlertView alertWithIconName:@"录像" content:NSLocalizedString(@"CameraAuthDenied", nil) comfirmTitle:NSLocalizedString(@"AlertComfirmTitle",nil) choose:^(NSInteger index) {
                    if (index == 1) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                                
                            }];
                        });
                    }
                }];
            }
        }
    }else {
        
    }
}

- (void)gotoCamera{
    dispatch_async(dispatch_get_main_queue(), ^{
        ShootViewController *vc = [[ShootViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    });
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

/**
 push to the Gallery viewController
 */
- (void)galleryAction{
    GalleryViewController *vc = [[GalleryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 start record Video (require auth)
 
 @param sender button
 */
- (IBAction)startAction:(id)sender {
//    ShootViewController *vc = [[ShootViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    return;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstAuth"]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                    if (granted) {
                        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (status == PHAuthorizationStatusAuthorized) {
                                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstAuth"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    if ([BluetoothManager shareInstance].state == CBManagerStatePoweredOn) {
                                        //搜索蓝牙列表，如果只有一个设备则直接连接并进入拍摄界面，否则弹出选择框
                                        [[SlyShowProgress shareInstance] show];
                                        [[BluetoothManager shareInstance] scanWithResult:^(ConnectResultType result) {
                                            [[SlyShowProgress shareInstance] dismiss];
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                if (result == ConnectResultTypeSuccess) {
                                                    
                                                    ShootViewController *vc = [[ShootViewController alloc] init];
                                                    [self.navigationController pushViewController:vc animated:YES];
                                                    
                                                }
                                                else if(result == ConnectResultTypeNoneDevice){
                                                    [AuthDeniedAlertView alertWithIconName:@"找不到设备" content:NSLocalizedString(@"NoneDevice", nil) comfirmTitle:NSLocalizedString(@"AlertComfirmTitle",nil) choose:^(NSInteger index) {
                                                        if (index == 1) {
                                                            [self startAction:nil];
                                                        }
                                                    }];
                                                }                                      });
                                        }];
                                    }
                                    else{
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [AuthDeniedAlertView alertWithIconName:@"蓝牙" content:NSLocalizedString(@"BlueToothOpenTip", nil) comfirmTitle:NSLocalizedString(@"AlertBlueToothComfirmTitle",nil) choose:^(NSInteger index) {
                                            }];
                                        });
                                    }
                                }
                                else{
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [AuthDeniedAlertView alertWithIconName:@"保存" content:NSLocalizedString(@"PhotoAuthDenied", nil) comfirmTitle:NSLocalizedString(@"AlertComfirmTitle",nil) choose:^(NSInteger index) {
                                            if (index == 1) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                                                        
                                                    }];
                                                });
                                            }
                                        }];
                                    });
                                }
                            });
                        }];
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [AuthDeniedAlertView alertWithIconName:@"麦克风" content:NSLocalizedString(@"MicrophoneAuthDenied", nil) comfirmTitle:NSLocalizedString(@"AlertComfirmTitle",nil) choose:^(NSInteger index) {
                                if (index == 1) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                                            
                                        }];
                                    });
                                }
                            }];
                        });
                    }
                }];
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [AuthDeniedAlertView alertWithIconName:@"录像" content:NSLocalizedString(@"CameraAuthDenied", nil) comfirmTitle:NSLocalizedString(@"AlertComfirmTitle",nil) choose:^(NSInteger index) {
                        if (index == 1) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                                }];
                            });
                        }
                    }];
                });
            }
        }];
    }
    else{
        if ([self CameraAuthStatus]) {
            if ([self microphoneAuthStatus]) {
                if ([self photoLibraryAuthStatus]) {
                    //判断蓝牙是否打开
                    if ([BluetoothManager shareInstance].state == CBManagerStatePoweredOn) {
                        //搜索蓝牙列表，如果只有一个设备则直接连接并进入拍摄界面，否则弹出选择框
                        [[SlyShowProgress shareInstance] show];
                        [[BluetoothManager shareInstance] scanWithResult:^(ConnectResultType result) {
                            [[SlyShowProgress shareInstance] dismiss];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (result == ConnectResultTypeSuccess) {
                                    ShootViewController *vc = [[ShootViewController alloc] init];
                                    [self.navigationController pushViewController:vc animated:YES];
                                }
                                else if(result == ConnectResultTypeNoneDevice){
                                    [AuthDeniedAlertView alertWithIconName:@"找不到设备" content:NSLocalizedString(@"NoneDevice", nil) comfirmTitle:NSLocalizedString(@"AlertComfirmTitle",nil) choose:^(NSInteger index) {
                                        if (index == 1) {
                                            [self startAction:nil];
                                        }
                                    }];
                                }
                            });
                        }];
                    }
                    else{
                        [AuthDeniedAlertView alertWithIconName:@"蓝牙" content:NSLocalizedString(@"BlueToothOpenTip", nil) comfirmTitle:NSLocalizedString(@"AlertBlueToothComfirmTitle",nil) choose:^(NSInteger index) {
                        }];
                    }
                }
                else{
                    [AuthDeniedAlertView alertWithIconName:@"保存" content:NSLocalizedString(@"PhotoAuthDenied", nil) comfirmTitle:NSLocalizedString(@"AlertComfirmTitle",nil) choose:^(NSInteger index) {
                        if (index == 1) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                                    
                                }];
                            });
                        }
                    }];
                }
            }
            else{
                [AuthDeniedAlertView alertWithIconName:@"麦克风" content:NSLocalizedString(@"MicrophoneAuthDenied", nil) comfirmTitle:NSLocalizedString(@"AlertComfirmTitle",nil) choose:^(NSInteger index) {
                    if (index == 1) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                                
                            }];
                        });
                    }
                }];
            }
        }
        else{
            [AuthDeniedAlertView alertWithIconName:@"录像" content:NSLocalizedString(@"CameraAuthDenied", nil) comfirmTitle:NSLocalizedString(@"AlertComfirmTitle",nil) choose:^(NSInteger index) {
                if (index == 1) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                            
                        }];
                    });
                }
            }];
        }
    }
}

//get microphone auth status
- (BOOL)microphoneAuthStatus{
    AVAudioSession* sharedSession = [AVAudioSession sharedInstance];
    AVAudioSessionRecordPermission permission = [sharedSession recordPermission];
    if (permission == AVAudioSessionRecordPermissionUndetermined) {
        
    }
    else if (permission == AVAudioSessionRecordPermissionGranted){
        return YES;
    }
    return NO;
}

/**
 Get Camera auth status
 */
- (BOOL)CameraAuthStatus{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusAuthorized) {
        return YES;
    } else if(status == AVAuthorizationStatusDenied){
        // denied
        return NO;
    } else if(status == AVAuthorizationStatusRestricted){
        return NO;
    } else if(status == AVAuthorizationStatusNotDetermined){
        // not determined
    }
    return NO;
}

//Get PhotoLibrary auth status
- (BOOL)photoLibraryAuthStatus{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        return YES;
    }
    else if (status == PHAuthorizationStatusDenied){
        return NO;
    }
    else if (status == PHAuthorizationStatusNotDetermined){
        
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


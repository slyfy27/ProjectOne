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
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController ()<CBCentralManagerDelegate>

@property (strong, nonatomic) CBCentralManager *bluetoothManager;

@property (assign, nonatomic) NSInteger authCount;

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
    _bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self
                                                             queue:nil];
    _authCount = 0;
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
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstAuth"]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                _authCount += 1;
            }
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                if (granted) {
                    _authCount += 1;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (status == PHAuthorizationStatusAuthorized) {
                                _authCount += 1;
                            }
                            if (_authCount == 3) {
                                //判断蓝牙是否打开
                                if (_bluetoothManager.state == CBManagerStatePoweredOn) {
                                    //搜索蓝牙列表，如果只有一个设备则直接连接并进入拍摄界面，否则弹出选择框
                                    
                                }
                                else{
                                    [AuthDeniedAlertView alertWithIconName:@"蓝牙" content:NSLocalizedString(@"BlueToothOpenTip", nil) comfirmTitle:NSLocalizedString(@"AlertBlueToothComfirmTitle",nil) choose:^(NSInteger index) {
                                    }];
                                }
                            }
                        });
                    }];
                });
            }];
        }];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstAuth"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else{
        if ([self CameraAuthStatus]) {
            if ([self microphoneAuthStatus]) {
                if ([self photoLibraryAuthStatus]) {
                    //判断蓝牙是否打开
                    if (_bluetoothManager.state == CBManagerStatePoweredOn) {
                        //搜索蓝牙列表，如果只有一个设备则直接连接并进入拍摄界面，否则弹出选择框
                        
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
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=Photos"] options:@{} completionHandler:^(BOOL success) {
                                    
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
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=Photos"] options:@{} completionHandler:^(BOOL success) {
                                
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
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=Photos"] options:@{} completionHandler:^(BOOL success) {
                            
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

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


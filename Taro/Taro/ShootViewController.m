//
//  ShootViewController.m
//  Taro
//
//  Created by wushuying on 2018/3/27.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "ShootViewController.h"
#import <AVKit/AVKit.h>

@interface ShootViewController ()

@property (nonatomic, strong) AVCaptureSession *captureSession;

@end

@implementation ShootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    _captureSession = [[AVCaptureSession alloc] init];
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    previewLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:previewLayer];
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

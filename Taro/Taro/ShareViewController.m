//
//  ShareViewController.m
//  Taro
//
//  Created by wushuying on 2018/4/17.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "ShareViewController.h"
#import "SVProgressHUD.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _videoImageView.image = _videoImage;
    _videoImageView.layer.borderWidth = 10;
    _videoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _videoImageView.layer.cornerRadius = 5;
    _videoImageView.layer.masksToBounds = YES;
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)facebookAction:(id)sender {
    NSMutableDictionary *param = @{}.mutableCopy;
    [param SSDKSetupShareParamsByText:@"分享视频" images:nil url:_videoUrl title:@"Taro" type:SSDKContentTypeVideo];
    [param SSDKEnableUseClientShare];
    [ShareSDK share:SSDKPlatformTypeFacebook parameters:param onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        if (state == SSDKResponseStateBeginUPLoad) {
            [SVProgressHUD showWithStatus:@"正在上传视频"];
        }
        else if (state == SSDKResponseStateSuccess) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self closeAction:nil];
            });
        }
        else if (state == SSDKResponseStateFail) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"上传失败"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self closeAction:nil];
            });
        }
    }];
}

- (IBAction)youtubeAction:(id)sender {
    NSMutableDictionary *param = @{}.mutableCopy;
    [param SSDKSetupShareParamsByText:@"分享视频" images:nil url:_videoUrl title:@"Taro" type:SSDKContentTypeVideo];
    [ShareSDK share:SSDKPlatformTypeYouTube parameters:param onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        if (state == SSDKResponseStateBeginUPLoad) {
            [SVProgressHUD showWithStatus:@"正在上传视频"];
        }
        else if (state == SSDKResponseStateSuccess) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self closeAction:nil];
            });
        }
        else if (state == SSDKResponseStateFail) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"上传失败"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self closeAction:nil];
            });
        }
    }];
}

- (IBAction)twitterAction:(id)sender {
    
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

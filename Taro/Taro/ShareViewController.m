//
//  ShareViewController.m
//  Taro
//
//  Created by wushuying on 2018/4/17.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "ShareViewController.h"
#import "SVProgressHUD.h"
#import <Social/Social.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <TwitterKit/TWTRKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ShareViewController ()<TWTRComposerViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *pickVC;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pickVC = [[UIImagePickerController alloc] init];
    _pickVC.delegate = self;
    _pickVC.mediaTypes = @[(NSString *)kUTTypeMovie];
    _videoImageView.image = _videoImage;
    _videoImageView.layer.borderWidth = 10;
    _videoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _videoImageView.layer.masksToBounds = YES;
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    [[PHImageManager defaultManager] requestAVAssetForVideo:_shareAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        AVURLAsset *urlAsset = (AVURLAsset *)asset;
        _videoUrl = urlAsset.URL;
//        [self saveToCameraRoll:_videoUrl];
    }];
//    NSString *localStr = _shareAsset.localIdentifier;
//    NSRange range = [localStr rangeOfString:@"/"];
//    NSString *newString = [localStr substringToIndex:range.location];
//    NSString *appendedString = [NSString stringWithFormat:@"%@%@%@",@"assets-library://asset/asset.MOV?id=",newString,@"&ext=MOV"];
//    _videoUrl = [NSURL URLWithString:appendedString];
    
}

- (void)saveToCameraRoll:(NSURL *)srcURL
{
    NSLog(@"srcURL: %@", srcURL);
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    ALAssetsLibraryWriteVideoCompletionBlock videoWriteCompletionBlock =
    ^(NSURL *newURL, NSError *error) {
        if (error) {
            NSLog( @"Error writing image with metadata to Photo Library: %@", error );
        } else {
            NSLog( @"Wrote image with metadata to Photo Library %@", newURL.absoluteString);
            _videoUrl = newURL;
            // 这里用url_new 分享试试
        }
    };
    
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:srcURL])
    {
        [library writeVideoAtPathToSavedPhotosAlbum:srcURL
                                    completionBlock:videoWriteCompletionBlock];
    }
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)facebookAction:(id)sender {
    NSMutableDictionary *param = @{}.mutableCopy;
    [param SSDKSetupShareParamsByText:nil images:nil url:_videoUrl title:nil type:SSDKContentTypeVideo];
//    [param SSDKEnableUseClientShare];
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
//    [param SSDKSetupYouTubeParamsByVideo:[NSData dataWithContentsOfFile:_videoUrl.absoluteString] title:@"title" description:@"desc" tags:nil privacyStatus:SSDKPrivacyStatusPrivate];
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
//    TWTRComposer *composer = [[TWTRComposer alloc] init];
//    [composer setText:@"123"];
//    [composer setURL:_videoUrl];
//    [composer showFromViewController:self completion:^(TWTRComposerResult result) {
//
//    }];
//    return;
//    [self presentViewController:_pickVC animated:YES completion:^{
//
//    }];
//    return ;
    if ([[TWTRTwitter sharedInstance].sessionStore hasLoggedInUsers]) {
        TWTRComposerViewController *composer = [[TWTRComposerViewController alloc] initWithInitialText:nil image:nil videoURL:_videoUrl];
//        composer = [composer initWithInitialText:@"fasdfas" image:nil videoURL:_videoUrl];
        composer.delegate = self;
        [self presentViewController:composer animated:YES completion:nil];
    }
    else{
        [[TWTRTwitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
            if (session) {
                TWTRComposerViewController *composer = [[TWTRComposerViewController alloc] initWithInitialText:nil image:nil videoURL:_videoUrl];
                
                [self presentViewController:composer animated:YES completion:nil];
            } else {
                //分享失败
            }
        }];
    }
    return;
    NSMutableDictionary *param = @{}.mutableCopy;
    [param SSDKSetupShareParamsByText:nil images:nil url:_videoUrl title:@"Taro" type:SSDKContentTypeVideo];
    [param SSDKEnableUseClientShare];
    [ShareSDK share:SSDKPlatformTypeTwitter parameters:param onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
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

- (IBAction)otherAction:(id)sender {
    UIActivityViewController *activityController=[[UIActivityViewController alloc]initWithActivityItems:@[_videoUrl] applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (void)composerDidCancel:(TWTRComposerViewController *)controller{
    
}

- (void)composerDidFail:(TWTRComposerViewController *)controller withError:(NSError *)error{
    
}

- (void)composerDidSucceed:(TWTRComposerViewController *)controller withTweet:(TWTRTweet *)tweet{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSURL *url = info[UIImagePickerControllerMediaURL];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    TWTRComposerViewController *composer = [[TWTRComposerViewController alloc] initWithInitialText:@"123" image:nil videoURL:url];
    //        composer = [composer initWithInitialText:@"fasdfas" image:nil videoURL:_videoUrl];
    composer.delegate = self;
    [self presentViewController:composer animated:YES completion:nil];
    
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

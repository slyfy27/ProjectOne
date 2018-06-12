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
@property (nonatomic, strong) NSURL *twitterUrl;

@property (nonatomic, strong) NSURL *fileUrl;

@property (nonatomic, copy) NSString *createTimeString;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    _pickVC = [[UIImagePickerController alloc] init];
    _pickVC.delegate = self;
    _pickVC.mediaTypes = @[(NSString *)kUTTypeMovie];
    _pickVC.videoQuality = UIImagePickerControllerQualityType640x480;
    _videoImageView.image = _videoImage;
    _videoImageView.layer.borderWidth = 10;
    _videoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _videoImageView.layer.masksToBounds = YES;
    _createTimeString = @([_shareAsset.creationDate timeIntervalSince1970]).stringValue;
    _fileUrl = [self getFilePath:_createTimeString];
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    [[PHImageManager defaultManager] requestAVAssetForVideo:_shareAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        AVURLAsset *urlAsset = (AVURLAsset *)asset;
        _videoUrl = urlAsset.URL;
        [self saveToCameraRoll:_videoUrl];
        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPreset640x480];
        _twitterUrl = [self getFilePath:@""];
        session.outputURL = _twitterUrl;
        session.outputFileType = AVFileTypeQuickTimeMovie;
        [session exportAsynchronouslyWithCompletionHandler:^{
            
        }];
    }];
}

- (NSURL *)getFilePath:(NSString *)identifier{
    NSString *times = identifier;
    times = [times stringByAppendingString:@".mov"];
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSURL *outputURL = [NSURL fileURLWithPath:document isDirectory:YES];
    outputURL = [NSURL URLWithString:times relativeToURL:outputURL];
    return outputURL;
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
    [param SSDKSetupShareParamsByText:@"分享视频" images:nil url:_twitterUrl title:@"Taro" type:SSDKContentTypeVideo];
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
    NSMutableDictionary *param = @{}.mutableCopy;
    [param SSDKSetupShareParamsByText:@"分享视频" images:nil url:_fileUrl title:@"Taro" type:SSDKContentTypeVideo];
    [param SSDKEnableUseClientShare];
    [ShareSDK share:SSDKPlatformTypeInstagram parameters:param onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self closeAction:nil];
            });
        }
        else{
            [SVProgressHUD showSuccessWithStatus:@"上传失败"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self closeAction:nil];
            });
        }
    }];
    return;
//    TWTRComposer *composer = [[TWTRComposer alloc] init];
//    [composer setText:@"123"];
//    [composer setURL:_videoUrl];
//    [composer showFromViewController:self completion:^(TWTRComposerResult result) {
//
//    }];
//    return;
    if (!_twitterUrl) {
        [SVProgressHUD showInfoWithStatus:@"正在压缩视频，请稍后"];
        [SVProgressHUD dismissWithDelay:1.5];
        return;
    }
    if ([[TWTRTwitter sharedInstance].sessionStore hasLoggedInUsers]) {
        TWTRComposerViewController *composer = [[TWTRComposerViewController alloc] initWithInitialText:nil image:nil videoURL:_twitterUrl];
//        composer = [composer initWithInitialText:@"fasdfas" image:nil videoURL:_videoUrl];
        
        composer.delegate = self;
        [self presentViewController:composer animated:YES completion:nil];
    }
    else{
        [[TWTRTwitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
            if (session) {
                TWTRComposerViewController *composer = [[TWTRComposerViewController alloc] initWithInitialText:nil image:nil videoURL:_twitterUrl];
                
                [self presentViewController:composer animated:YES completion:nil];
            } else {
                //分享失败
            }
        }];
    }
    return;
    NSMutableDictionary *param1 = @{}.mutableCopy;
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
//    TWTRComposerViewController *composer = [[TWTRComposerViewController alloc] initWithInitialText:@"123" image:nil videoURL:url];
//    //        composer = [composer initWithInitialText:@"fasdfas" image:nil videoURL:_videoUrl];
//    composer.delegate = self;
//    [self presentViewController:composer animated:YES completion:nil];
    
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

//
//  GalleryCollectionViewCell.m
//  Taro
//
//  Created by wushuying on 2018/3/25.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "GalleryCollectionViewCell.h"
#import <AVKit/AVKit.h>
#import "GolbalDefine.h"

@implementation GalleryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bottomView.layer.shadowColor = UIColorFromRGB(0x000000).CGColor;
    self.bottomView.layer.shadowRadius = 4;
    self.bottomView.layer.shadowOffset = CGSizeMake(0, 3);
    self.bottomView.layer.shadowOpacity = 0.2;
}

- (void)setAsset:(PHAsset *)asset{
    _asset = asset;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        AVAssetImageGenerator *xx = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        CGImageRef im = [xx copyCGImageAtTime:CMTimeMake(0.0, 600) actualTime:NULL error:NULL];
        dispatch_async(dispatch_get_main_queue(), ^{
            _timeLabel.text = [self timeFromSeconds:CMTimeGetSeconds(asset.duration)];
            _audioImageVIew.image = [UIImage imageWithCGImage:im];
            CGImageRelease(im);
        });
//        _audioImageVIew.image = asset.com
    }];
}

- (IBAction)selectAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _whiteMaskView.hidden = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectIndex:)]) {
        [self.delegate selectIndex:sender.tag];
    }
}

- (void)setMoviePath:(NSString *)moviePath{
    _moviePath = moviePath;
    NSString *imageFile = [moviePath stringByReplacingOccurrencesOfString:@".mov" withString:@".jpg"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imageFile]) {
        UIImage *tempImage = [UIImage imageWithContentsOfFile:imageFile];
        _audioImageVIew.image = tempImage;
        return;
    }
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:moviePath] options:nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AVAssetImageGenerator *xx = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        CGImageRef im = [xx copyCGImageAtTime:CMTimeMake(0.0, 600) actualTime:NULL error:NULL];
        dispatch_async(dispatch_get_main_queue(), ^{
            _timeLabel.text = [self timeFromSeconds:CMTimeGetSeconds(asset.duration)];
            UIImage *tempImage = [UIImage imageWithCGImage:im];
            [UIImageJPEGRepresentation(tempImage, 0.8) writeToFile:imageFile atomically:YES];
            _audioImageVIew.image = tempImage;
            CGImageRelease(im);
        });
    });
}

- (NSString *)timeFromSeconds:(int)seconds
{
    int m =seconds/60;
    int s = seconds%60;
    NSString *mString ;
    NSString *sString ;
    if (m<10)
        mString =[NSString stringWithFormat:@"%d",m];
    else
        mString =[NSString stringWithFormat:@"%d",m];
    
    if (s<10)
        sString =[NSString stringWithFormat:@"0%d",s];
    else
        sString =[NSString stringWithFormat:@"%d",s];
    
    return  [NSString stringWithFormat:@"%@:%@",mString,sString];
    
}

@end

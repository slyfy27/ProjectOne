//
//  ShareViewController.h
//  Taro
//
//  Created by wushuying on 2018/4/17.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "BaseViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <Photos/Photos.h>

@interface ShareViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;

@property (strong, nonatomic) UIImage *videoImage;

@property (copy, nonatomic) NSURL *videoUrl;

@property (strong, nonatomic) PHAsset *shareAsset;

@end

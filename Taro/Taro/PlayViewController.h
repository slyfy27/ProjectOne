//
//  PlayViewController.h
//  Taro
//
//  Created by wushuying on 2018/4/11.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

@interface PlayViewController : UIViewController

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end

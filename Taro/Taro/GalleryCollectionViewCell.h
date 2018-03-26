//
//  GalleryCollectionViewCell.h
//  Taro
//
//  Created by wushuying on 2018/3/25.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface GalleryCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *audioImageVIew;

@property (strong, nonatomic) PHAsset *asset;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

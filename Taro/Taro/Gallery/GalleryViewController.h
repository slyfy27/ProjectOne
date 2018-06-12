//
//  GalleryViewController.h
//  Taro
//
//  Created by wushuying on 2018/3/25.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "BaseViewController.h"

@interface GalleryViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UICollectionView *galleryCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareViewTopConstraint;

@end

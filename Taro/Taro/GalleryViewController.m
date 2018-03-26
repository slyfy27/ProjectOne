//
//  GalleryViewController.m
//  Taro
//
//  Created by wushuying on 2018/3/25.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "GalleryViewController.h"
#import <Photos/Photos.h>
#import "GalleryCollectionViewCell.h"
#import <AVKit/AVKit.h>

@interface GalleryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) PHFetchResult *audioResult;

@property (nonatomic, strong) NSMutableArray *assets;

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _galleryCollectionView.delegate = self;
    _galleryCollectionView.dataSource = self;
    [_galleryCollectionView registerNib:[UINib nibWithNibName:@"GalleryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self setRightNavigationBarButton:@selector(edit) title:@"EDIT" image:nil];
    [self setTitle:@"Gallery"];
    [self enumerateGallery];
}

- (void)enumerateGallery{
    _assets = @[].mutableCopy;
    _audioResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:nil];
    [_audioResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_assets addObject:obj];
        if (stop) {
            [_galleryCollectionView reloadData];
        }
    }];
}

- (void)edit{
    
}

//有多少的分组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个分组里有多少个item
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _assets.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.asset = _assets[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [[PHImageManager defaultManager] requestPlayerItemForVideo:_assets[indexPath.row] options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        AVPlayerViewController *vc = [[AVPlayerViewController alloc] init];
        vc.player = player;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController presentViewController:vc animated:YES completion:^{
                
            }];
        });
    }];
}

/* 定义每个UICollectionView 的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(200, 150);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);//分别为上、左、下、右
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

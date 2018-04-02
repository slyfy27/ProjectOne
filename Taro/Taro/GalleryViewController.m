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

@property (nonatomic, assign) BOOL selectState;

@property (nonatomic, strong) NSMutableArray *movieArray;

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _movieArray = @[].mutableCopy;
    _selectState = NO;
    _galleryCollectionView.delegate = self;
    _galleryCollectionView.dataSource = self;
    [self setLeftNavigationBarButton:@selector(back) title:nil image:@"返回"];
    [_galleryCollectionView registerNib:[UINib nibWithNibName:@"GalleryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self setRightNavigationBarButton:@selector(edit) title:@"EDIT" image:nil];
    [self setTitle:@"Gallery"];
    [self enumerateGallery];
    [self getLocalVieo];
}

- (void)getLocalVieo{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:path];
    NSString *fileName;
    while (fileName = [dirEnum nextObject]) {
//        NSLog(@"短路径:%@", fileName);
//        NSLog(@"全路径:%@", [path stringByAppendingPathComponent:fileName]);
        if ([fileName hasSuffix:@".mov"]) {
            [_movieArray addObject:[path stringByAppendingPathComponent:fileName]];
        }
    }
    [self.galleryCollectionView reloadData];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
    _selectState = YES;
    [_galleryCollectionView reloadData];
}

//有多少的分组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个分组里有多少个item
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _movieArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.moviePath = _movieArray[indexPath.row];
    if (_selectState) {
        cell.selectBtn.hidden = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSURL *url = [NSURL fileURLWithPath:_movieArray[indexPath.row]];
    AVPlayer *player = [AVPlayer playerWithURL:url];
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.player = player;
    [self presentViewController:playerViewController animated:YES completion:nil];
    [playerViewController.player play];
}

/* 定义每个UICollectionView 的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(185, 180);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(28, 47, 28, 47);//分别为上、左、下、右
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

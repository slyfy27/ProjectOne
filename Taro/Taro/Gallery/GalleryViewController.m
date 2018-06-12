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
#import <Accounts/Accounts.h>
#import "PlayViewController.h"
#import "ShareViewController.h"

@interface GalleryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,GalleryCollectionCellDelegate>

@property (nonatomic, strong) PHFetchResult *audioResult;

@property (nonatomic, strong) NSMutableArray *assets;

@property (nonatomic, assign) BOOL selectState;

@property (nonatomic, strong) NSMutableArray *movieArray;

@property (nonatomic, strong) NSMutableSet *selectSet;

@property (nonatomic, strong) NSFileManager *fileManager;

@property (nonatomic, strong) PHAssetCollection *taroAssetCollection;

@end

@implementation GalleryViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTaroAlbum];
    _movieArray = @[].mutableCopy;
    _selectSet = [[NSMutableSet alloc] init];
    _galleryCollectionView.delegate = self;
    _galleryCollectionView.dataSource = self;
    [self setLeftNavigationBarButton:@selector(back) title:nil image:@"返回"];
    [_galleryCollectionView registerNib:[UINib nibWithNibName:@"GalleryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self setRightNavigationBarButton:@selector(edit) title:@"EDIT" image:nil];
    [self setTitle:@"Gallery"];
//    [self getLocalVieo];
    [self enumerateGallery];
}

- (void)creatTaroAlbum{
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in assetCollections) {
        if ([collection.localizedTitle isEqualToString:@"Taro"]) {
            _taroAssetCollection = collection;
            return;
        }
    }
    __block NSString *assetCollectionLocalIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        assetCollectionLocalIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"Taro"].placeholderForCreatedAssetCollection.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            _taroAssetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionLocalIdentifier] options:nil].firstObject;
        }
    }];
}

- (void)getLocalVieo{
    [_movieArray removeAllObjects];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    _fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [_fileManager enumeratorAtPath:path];
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

- (void)enumerateGallery{
    _assets = @[].mutableCopy;
    if (!_taroAssetCollection) {
        [_galleryCollectionView reloadData];
    }
    else{
        _audioResult = [PHAsset fetchAssetsInAssetCollection:_taroAssetCollection options:nil];
        if (_audioResult.count == 0) {
            [_galleryCollectionView reloadData];
            return ;
        }
        [_audioResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_assets addObject:obj];
            if (stop) {
                [_galleryCollectionView reloadData];
            }
        }];
    }
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)edit{
    _selectState = YES;
    [_galleryCollectionView reloadData];
    [self setRightNavigationBarButton:@selector(share) title:@"SHARE" image:nil barbutton1:@selector(deleteAction) title1:@"DELETE" image1:nil];
}

- (void)share{
    NSString *index = _selectSet.allObjects.firstObject;
//    NSURL *fileUrl = [NSURL fileURLWithPath:_movieArray[index.integerValue]];
    GalleryCollectionViewCell *cell = (GalleryCollectionViewCell *)[_galleryCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index.integerValue inSection:0]];
    ShareViewController *vc = [[ShareViewController alloc] init];
    vc.shareAsset = _assets[index.integerValue];
    vc.videoImage = cell.audioImageVIew.image;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)deleteAction{
    NSMutableArray *deleAsset = @[].mutableCopy;
    for (NSString *index in _selectSet) {
        [deleAsset addObject:_assets[index.integerValue]];
    }
    [self deleteWithAsset:deleAsset];
}

- (void)deleteFileWithUrl:(NSURL *)url{
    if([_fileManager isWritableFileAtPath:url.absoluteString]){
        [_fileManager removeItemAtPath:url.absoluteString error:NULL];
    }
}

- (void)deleteWithAsset:(NSArray<PHAsset *> *)assets{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:_taroAssetCollection];
        [request removeAssets:assets];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_selectSet removeAllObjects];
            [self enumerateGallery];
        });
    }];
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
    if (_selectState) {
        cell.selectBtn.hidden = NO;
    }
    else{
        cell.selectBtn.hidden = YES;
    }
    cell.delegate = self;
    if([_selectSet containsObject:@(indexPath.row).stringValue]){
        cell.selectBtn.selected = YES;
        cell.whiteMaskView.hidden = NO;
    }
    else{
        cell.selectBtn.selected = NO;
        cell.whiteMaskView.hidden = YES;
    }
    cell.selectBtn.tag = indexPath.row;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSURL *url = [NSURL fileURLWithPath:_movieArray[indexPath.row]];
//
//    PlayViewController *playerVC = [[PlayViewController alloc] init];
//    playerVC.videoUrl = url;
//    [self presentViewController:playerVC animated:YES completion:nil];
    
    [[PHImageManager defaultManager] requestPlayerItemForVideo:_assets[indexPath.row] options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        PlayViewController *vc = [[PlayViewController alloc] init];
        vc.player = player;
        [player play];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:vc animated:YES completion:nil];
        });
    }];
}

/* 定义每个UICollectionView 的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(Width*185/736, Height*180/414);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(28, 47, 28, 47);//分别为上、左、下、右
}

- (void)selectIndex:(NSInteger)index{
    if ([_selectSet containsObject:@(index).stringValue]) {
        [_selectSet removeObject:@(index).stringValue];
    }
    else{
        [_selectSet addObject:@(index).stringValue];
    }
    if (_selectSet.count == 0) {
        self.navigationController.navigationItem.rightBarButtonItems = nil;
        [self setRightNavigationBarButton:@selector(edit) title:@"EDIT" image:nil];
    }
    else if (_selectSet.count == 1){
        self.navigationController.navigationItem.rightBarButtonItems = nil;
        [self setRightNavigationBarButton:@selector(share) title:@"SHARE" image:nil barbutton1:@selector(deleteAction) title1:@"DELETE" image1:nil];
    }
    else{
        self.navigationController.navigationItem.rightBarButtonItems = nil;
        [self setRightNavigationBarButton:@selector(deleteAction) title:@"DELETE" image:nil];
    }
}

- (IBAction)youtubeAction:(id)sender {
    
//    GTLRDriveService *service = self.driveService;
//    
//    GTLRUploadParameters *uploadParameters =
//    [GTLRUploadParameters uploadParametersWithFileURL:fileToUploadURL
//                                             MIMEType:@"text/plain"];
//    
//    GTLRDrive_File *newFile = [GTLRDrive_File object];
//    newFile.name = path.lastPathComponent;
//    
//    GTLRDriveQuery_FilesCreate *query =
//    [GTLRDriveQuery_FilesCreate queryWithObject:newFile
//                               uploadParameters:uploadParameters];
//    
//    GTLRServiceTicket *uploadTicket =
//    [service executeQuery:query
//        completionHandler:^(GTLRServiceTicket *callbackTicket,
//                            GTLRDrive_File *uploadedFile,
//                            NSError *callbackError) {
//            if (callbackError == nil) {
//                // Succeeded
//            }
//        }];
    
    //only support fecebook and twitter
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

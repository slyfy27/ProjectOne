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

#import <MessageUI/MFMailComposeViewController.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "PlayViewController.h"

@interface GalleryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,GalleryCollectionCellDelegate>

@property (nonatomic, strong) PHFetchResult *audioResult;

@property (nonatomic, strong) NSMutableArray *assets;

@property (nonatomic, assign) BOOL selectState;

@property (nonatomic, strong) NSMutableArray *movieArray;

@property (nonatomic, strong) NSMutableSet *selectSet;

@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation GalleryViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _movieArray = @[].mutableCopy;
    _selectSet = [[NSMutableSet alloc] init];
    _galleryCollectionView.delegate = self;
    _galleryCollectionView.dataSource = self;
    [self setLeftNavigationBarButton:@selector(back) title:nil image:@"返回"];
    [_galleryCollectionView registerNib:[UINib nibWithNibName:@"GalleryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self setRightNavigationBarButton:@selector(edit) title:@"EDIT" image:nil];
    [self setTitle:@"Gallery"];
    [self getLocalVieo];
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

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)edit{
    _selectState = YES;
    [_galleryCollectionView reloadData];
    [self setRightNavigationBarButton:@selector(share) title:@"SHARE" image:nil barbutton1:@selector(deleteAction) title1:@"DELETE" image1:nil];
}

- (void)share{
    
}

- (void)deleteAction{
    for (NSString *index in _selectSet) {
        [self deleteFileWithUrl:[NSURL URLWithString:_movieArray[index.integerValue]]];
    }
    [_selectSet removeAllObjects];
    [self getLocalVieo];
}

- (void)deleteFileWithUrl:(NSURL *)url{
    if([_fileManager isWritableFileAtPath:url.absoluteString]){
        [_fileManager removeItemAtPath:url.absoluteString error:NULL];
    }
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
    NSURL *url = [NSURL fileURLWithPath:_movieArray[indexPath.row]];
    
    PlayViewController *playerVC = [[PlayViewController alloc] init];
    playerVC.videoUrl = url;
    [self presentViewController:playerVC animated:YES completion:nil];
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
    
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
    }
    SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [composeVC addURL:[NSURL fileURLWithPath:_movieArray.firstObject]];
    [composeVC setInitialText:@"share from Taro"];
    [self presentViewController:composeVC animated:YES completion:^{
        
    }];
    composeVC.completionHandler = ^(SLComposeViewControllerResult result) {
        if (result == SLComposeViewControllerResultDone) {
            
        }
        else if (result == SLComposeViewControllerResultCancelled){
            
        }
    };
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

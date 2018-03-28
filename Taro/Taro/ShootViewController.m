//
//  ShootViewController.m
//  Taro
//
//  Created by wushuying on 2018/3/27.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "ShootViewController.h"
#import <AVKit/AVKit.h>
#import "CameraCell.h"
#import "TaroCell.h"

typedef NS_ENUM(NSInteger, SettingType) {
    SettingTypeNone = 0,//默认从0开始
    SettingTypeBluetooth,
    SettingTypeCamera,
    SettingTypeCameraResolution,
    SettingTypeDevice,
    SettingTypeYunTai,
};

@interface ShootViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, copy) NSArray *cameraSettingArray;

@property (nonatomic, assign) SettingType type;

@property (nonatomic, copy) NSArray *bluetoothArray;

@property (nonatomic, copy) NSArray *resolutionArray;

@end

@implementation ShootViewController

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)bluetoothAction:(UIButton *)sender {
    if (sender.selected) {
        _settingViewWidth.constant = 0;
        [_settingView layoutIfNeeded];
        self.type = SettingTypeNone;
    }
    else{
        _settingViewWidth.constant = 300;
        self.type = SettingTypeBluetooth;
        [UIView animateWithDuration:0.25 animations:^{
            [_settingView layoutIfNeeded];
        }];
        [_settingTable reloadData];
        sender.selected = !sender.selected;
    }
}

- (void)setType:(SettingType)type{
    _type = type;
    _bluetoothBtn.selected = _cameraBtn.selected = _yuntaiBtn.selected = _deviceBtn.selected = NO;
    switch (type) {
        case SettingTypeNone:{
            _settingTitle.text = @"";
        }
            break;
        case SettingTypeBluetooth:{
            _settingTitle.text = @"Taro List";
        }
            break;
        case SettingTypeCamera:{
            _settingTitle.text = @"Settings";
        }
            break;
        case SettingTypeCameraResolution:{
            _settingTitle.text = @"Resolution";
        }
            break;
        default:
            break;
    }
}

- (IBAction)cameraACtion:(UIButton *)sender {
    if (sender.selected) {
        _settingViewWidth.constant = 0;
        self.type = SettingTypeNone;
        [_settingView layoutIfNeeded];
    }
    else{
        _settingViewWidth.constant = 300;
        self.type = SettingTypeCamera;
        [UIView animateWithDuration:0.25 animations:^{
            [_settingView layoutIfNeeded];
        }];
        [_settingTable reloadData];
        sender.selected = !sender.selected;
    }
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self configView];
//    _captureSession = [[AVCaptureSession alloc] init];
//    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
//        [_captureSession setSessionPreset:AVCaptureSessionPreset1280x720];
//    }
//    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:NULL];
//    if (videoInput) {
//        if ([_captureSession canAddInput:videoInput]){
//            [_captureSession addInput:videoInput];
//        }
//    }
//    // 音频输入
//    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio]; AVCaptureDeviceInput *audioIn = [[AVCaptureDeviceInput alloc] initWithDevice:audioDevice error:NULL];
//    if ([_captureSession canAddInput:audioIn]){
//        [_captureSession addInput:audioIn];
//    }
//    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
//    previewLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
//    [self.videoView.layer addSublayer:previewLayer];
//    [_captureSession startRunning];
}

- (void)configView{
    _cameraSettingArray = @[@{@"type":@"Resolution",@"value":@"1280x720 30fps"},
                            @{@"type":@"White Balance",@"value":@"Auto"},
                            @{@"type":@"ISO",@"value":@"0"},
                            @{@"type":@"Exposure Compensation",@"value":@"0"},
                            @{@"type":@"Flash",@"value":@"close"},
                            @{@"type":@"Mesh",@"value":@"None"}];
    _bluetoothArray = @[@"Taro-Test 1",@"Taro-Test 2",@"Taro-Test 3"];
    _resolutionArray = @[@{@"type":@"1080p",@"value":AVCaptureSessionPreset1920x1080},@{@"type":@"720p",@"value":AVCaptureSessionPreset1280x720},@{@"type":@"480p",@"value":AVCaptureSessionPreset640x480}];
    _settingTable.delegate = self;
    _settingTable.dataSource = self;
    [_settingTable registerNib:[UINib nibWithNibName:@"CameraCell" bundle:nil] forCellReuseIdentifier:@"cameraCell"];
    [_settingTable registerNib:[UINib nibWithNibName:@"TaroCell" bundle:nil] forCellReuseIdentifier:@"taroCell"];
    _settingTable.rowHeight = 60;
    _settingTable.tableFooterView = [UIView new];
    _settingTable.backgroundColor = [UIColor clearColor];
//    _subTable.delegate = self;
//    _settingTable.dataSource = self;
//    [_settingTable registerNib:[UINib nibWithNibName:@"CameraCell" bundle:nil] forCellReuseIdentifier:@"cameraCell"];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_type == SettingTypeCamera) {
        return _cameraSettingArray.count;
    }
    if (_type == SettingTypeBluetooth) {
        return _bluetoothArray.count;
    }
    if (_type == SettingTypeCameraResolution) {
        return _resolutionArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_type == SettingTypeCamera) {
        CameraCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cameraCell"];
        NSDictionary *dict = _cameraSettingArray[indexPath.row];
        cell.typeLabel.text = dict[@"type"];
        cell.valueLabel.text = dict[@"value"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (_type == SettingTypeBluetooth) {
        TaroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taroCell"];
        cell.bluetoothLabel.text = _bluetoothArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (_type == SettingTypeCamera) {
        CameraCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cameraCell"];
        NSDictionary *dict = _cameraSettingArray[indexPath.row];
        cell.typeLabel.text = dict[@"type"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_type == SettingTypeCamera) {
        NSDictionary *dict = _cameraSettingArray[indexPath.row];
        if ([dict[@"type"] isEqualToString:@"Resolution"]) {
            self.type = SettingTypeCameraResolution;
            [tableView beginUpdates];
            [tableView reloadData];
            [tableView endUpdates];
        }
        _cameraBtn.selected = YES;
    }
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

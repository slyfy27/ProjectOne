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
#import "WhiteBalanceCell.h"
#import "SliderCell.h"

typedef NS_ENUM(NSInteger, SettingType) {
    SettingTypeNone = 0,//默认从0开始
    SettingTypeBluetooth,
    SettingTypeCamera,
    SettingTypeCameraResolution,
    SettingTypeCameraWhiteBalance,
    SettingTypeCameraISO,
    SettingTypeCameraExposure,
    SettingTypeCameraMesh,
    SettingTypeCameraFlash,
    SettingTypeDevice,
    SettingTypeYunTai,
};

static NSString *resolution = @"resolution";
static NSString *mesh = @"mesh";
static NSString *whiteBalance = @"whiteBalance";
static NSString *exposureCompensation = @"exposureCompensation";
static NSString *flash = @"flash";
static NSString *iso = @"iso";

@interface ShootViewController ()<UITableViewDelegate,UITableViewDataSource,SliderCellDelegate,AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, copy) NSArray *cameraSettingArray;

@property (nonatomic, assign) SettingType type;

@property (nonatomic, copy) NSArray *bluetoothArray;

@property (nonatomic, copy) NSArray *resolutionArray;

@property (nonatomic, copy) NSArray *whiteBalanceArray;

@property (nonatomic, copy) NSArray *meshArray;

@property (nonatomic, copy) NSArray *deviceSettingArray;

@property (nonatomic, strong) AVCaptureDevice *backDevice;

@property (nonatomic, strong) AVCaptureDevice *frontDevice;

@property (nonatomic, strong) AVCaptureDeviceInput *backInput;

@property (nonatomic, strong) AVCaptureDeviceInput *frontInput;

@property (nonatomic, strong) AVCaptureFileOutput *output;

@property (nonatomic, assign) BOOL isFront;

@property (nonatomic, weak) IBOutlet UIButton *recordBtn;

@end

@implementation ShootViewController

- (void)configCameraSetting{
    if (![[NSUserDefaults standardUserDefaults] valueForKey:resolution]) {
        [[NSUserDefaults standardUserDefaults] setValue:AVCaptureSessionPreset1920x1080 forKey:resolution];
    }
    if (![[NSUserDefaults standardUserDefaults] valueForKey:mesh]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"None" forKey:mesh];
    }
    if (![[NSUserDefaults standardUserDefaults] valueForKey:iso]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:iso];
    }
    if (![[NSUserDefaults standardUserDefaults] valueForKey:exposureCompensation]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:exposureCompensation];
    }
    if (![[NSUserDefaults standardUserDefaults] valueForKey:flash]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"close" forKey:flash];
    }
    if (![[NSUserDefaults standardUserDefaults] valueForKey:whiteBalance]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"Auto" forKey:whiteBalance];
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSURL *)getFilePath{
    NSString *times = @([[NSDate date] timeIntervalSince1970]).stringValue;
    times = [times stringByAppendingString:@".mov"];
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSURL *outputURL = [NSURL fileURLWithPath:document isDirectory:YES];
    outputURL = [NSURL URLWithString:times relativeToURL:outputURL];
    return outputURL;
}

- (IBAction)recordAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_output startRecordingToOutputFileURL:[self getFilePath] recordingDelegate:self];
    }
    else{
        [_output stopRecording];
    }
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
            _subTable.hidden = YES;
            _settingTable.hidden = NO;
            [_settingTable reloadData];
        }
            break;
        case SettingTypeCameraResolution:{
            _settingTitle.text = @"Resolution";
            _subTable.hidden = NO;
            _settingTable.hidden = YES;
            [_subTable reloadData];
        }
            break;
        case SettingTypeCameraWhiteBalance:{
            _settingTitle.text = @"White Balance";
            _subTable.hidden = NO;
            _settingTable.hidden = YES;
            [_subTable reloadData];
        }
            break;
        case SettingTypeCameraISO:{
            _settingTitle.text = @"ISO";
            _subTable.hidden = NO;
            _settingTable.hidden = YES;
            [_subTable reloadData];
        }
            break;
        case SettingTypeCameraExposure:{
            _settingTitle.text = @"Exposure Compensation";
            _subTable.hidden = NO;
            _settingTable.hidden = YES;
            [_subTable reloadData];
        }
            break;
        case SettingTypeCameraMesh:{
            _settingTitle.text = @"Mesh";
            _subTable.hidden = NO;
            _settingTable.hidden = YES;
            [_subTable reloadData];
        }
            break;
        case SettingTypeYunTai:{
            _settingTitle.text = @"Device Setting";
            _subTable.hidden = YES;
            _settingTable.hidden = NO;
            [_settingTable reloadData];
        }
            break;
        case SettingTypeDevice:{
            _settingTitle.text = @"Device Setting";
            _subTable.hidden = YES;
            _settingTable.hidden = NO;
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

- (IBAction)cameraDeviceAction:(id)sender {
    self.type = SettingTypeDevice;
    //切换前后摄像头
    [_captureSession beginConfiguration];
    if (_isFront) {
        [_captureSession removeInput:_frontInput];
        [_captureSession addInput:_backInput];
        _isFront = NO;
    }
    else{
        [_captureSession removeInput:_backInput];
        [_captureSession addInput:_frontInput];
        _isFront = YES;
    }
    [_captureSession commitConfiguration];
}

- (IBAction)deviceAction:(UIButton *)sender {
    if (sender.selected) {
        _settingViewWidth.constant = 0;
        self.type = SettingTypeNone;
        [_settingView layoutIfNeeded];
    }
    else{
        _settingViewWidth.constant = 300;
        self.type = SettingTypeYunTai;
        [UIView animateWithDuration:0.25 animations:^{
            [_settingView layoutIfNeeded];
        }];
        sender.selected = !sender.selected;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCameraSetting];
    self.navigationController.navigationBarHidden = YES;
    [self configView];
    _captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        [_captureSession setSessionPreset:[[NSUserDefaults standardUserDefaults] valueForKey:resolution]];
    }
    _backDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    _frontDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
    _backInput = [AVCaptureDeviceInput deviceInputWithDevice:_backDevice error:NULL];
    _frontInput = [AVCaptureDeviceInput deviceInputWithDevice:_frontDevice error:NULL];
    if (_backInput) {
        if ([_captureSession canAddInput:_backInput]){
            [_captureSession addInput:_backInput];
        }
    }
    // 音频输入
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio]; AVCaptureDeviceInput *audioIn = [[AVCaptureDeviceInput alloc] initWithDevice:audioDevice error:NULL];
    if ([_captureSession canAddInput:audioIn]){
        [_captureSession addInput:audioIn];
    }
//    https://www.cnblogs.com/liangzhimy/archive/2012/10/26/2740905.html
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    previewLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    [self.videoView.layer addSublayer:previewLayer];
    [_captureSession startRunning];
    _output = [[AVCaptureMovieFileOutput alloc] init];
    CMTime maxDuration = CMTimeMake(1200, 1);//最大20分钟
    _output.maxRecordedDuration = maxDuration;
    _output.minFreeDiskSpaceLimit = 1024;
    if ([_captureSession canAddOutput:_output]) {
        [_captureSession addOutput:_output];
    }
}

- (NSString *)getResolution{
    NSString *res = [[NSUserDefaults standardUserDefaults] valueForKey:resolution];
    if ([res isEqualToString:AVCaptureSessionPreset1920x1080]) {
        return @"1920x1080 30fps";
    }
    if ([res isEqualToString:AVCaptureSessionPreset1280x720]) {
        return @"1280x720 30fps";
    }
    if ([res isEqualToString:AVCaptureSessionPreset640x480]) {
        return @"640x480 30fps";
    }
    return @"";
}

- (void)configView{
    _cameraSettingArray = @[@{@"type":@"Resolution",@"value":[self getResolution]},
                            @{@"type":@"White Balance",@"value":[[NSUserDefaults standardUserDefaults] valueForKey:whiteBalance]},
                            @{@"type":@"ISO",@"value":[[NSUserDefaults standardUserDefaults] valueForKey:iso]},
                            @{@"type":@"Exposure Compensation",@"value":[[NSUserDefaults standardUserDefaults] valueForKey:exposureCompensation]},
                            @{@"type":@"Flash",@"value":[[NSUserDefaults standardUserDefaults] valueForKey:flash]},
                            @{@"type":@"Mesh",@"value":[[NSUserDefaults standardUserDefaults] valueForKey:mesh]}];
    _bluetoothArray = @[@"Taro-Test 1",@"Taro-Test 2",@"Taro-Test 3"];
    _resolutionArray = @[@{@"type":@"1080p",@"value":AVCaptureSessionPreset1920x1080},@{@"type":@"720p",@"value":AVCaptureSessionPreset1280x720},@{@"type":@"480p",@"value":AVCaptureSessionPreset640x480}];
    _whiteBalanceArray = @[@{@"type":@"Auto",@"value":@""},@{@"type":@"Daylight",@"value":@""},@{@"type":@"Cloud Daylight",@"value":@""},@{@"type":@"Incandescent",@"value":@""},@{@"type":@"Fluorescent",@"value":@""}];
    _meshArray = @[@{@"type":@"None",@"value":@""},@{@"type":@"Mesh",@"value":@""},@{@"type":@"Mesh and Diagonal",@"value":@""},@{@"type":@"Center Point",@"value":@""}];
    _deviceSettingArray = @[@{@"type":@"Speed",@"value":@"Normal"},@{@"type":@"Device Mode",@"value":@"Full Follow"},@{@"type":@"Tracking Cursor",@"value":@"off"}];
    _settingTable.delegate = self;
    _settingTable.dataSource = self;
    [_settingTable registerNib:[UINib nibWithNibName:@"CameraCell" bundle:nil] forCellReuseIdentifier:@"cameraCell"];
    [_settingTable registerNib:[UINib nibWithNibName:@"TaroCell" bundle:nil] forCellReuseIdentifier:@"taroCell"];
    _settingTable.rowHeight = 60;
    _settingTable.tableFooterView = [UIView new];
    _settingTable.backgroundColor = [UIColor clearColor];
    _subTable.delegate = self;
    _subTable.dataSource = self;
    [_subTable registerNib:[UINib nibWithNibName:@"CameraCell" bundle:nil] forCellReuseIdentifier:@"cameraCell"];
    _subTable.rowHeight = 60;
    [_subTable registerNib:[UINib nibWithNibName:@"WhiteBalanceCell" bundle:nil] forCellReuseIdentifier:@"whiteBalanceCell"];
    [_subTable registerNib:[UINib nibWithNibName:@"SliderCell" bundle:nil] forCellReuseIdentifier:@"sliderCell"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"back" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(240, 10, 40, 40);
    [button addTarget:self action:@selector(subTableBack) forControlEvents:UIControlEventTouchUpInside];
    UIView *footerView = [[UIView alloc] initWithFrame:(CGRect){0,0,300,60}];
    [footerView addSubview:button];
    _subTable.tableFooterView = footerView;
    _subTable.backgroundColor = [UIColor clearColor];
}

- (void)subTableBack{
    self.type = SettingTypeCamera;
    _cameraBtn.selected = YES;
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
    if (_type == SettingTypeCameraWhiteBalance) {
        return _whiteBalanceArray.count;
    }
    if (_type == SettingTypeCameraMesh) {
        return _meshArray.count;
    }
    if (_type == SettingTypeYunTai) {
        return _deviceSettingArray.count;
    }
    if (_type == SettingTypeCameraISO || _type == SettingTypeCameraExposure) {
        return 1;
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
    if (_type == SettingTypeCameraResolution) {
        CameraCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cameraCell"];
        NSDictionary *dict = _resolutionArray[indexPath.row];
        cell.typeLabel.text = dict[@"type"];
        cell.valueLabel.text = @"";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([dict[@"value"] isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"resolution"]]) {
            [cell setCurrent:YES];
        }
        else{
            [cell setCurrent:NO];
        }
        return cell;
    }
    if (_type == SettingTypeCameraWhiteBalance) {
        WhiteBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"whiteBalanceCell"];
        NSDictionary *dict = _whiteBalanceArray[indexPath.row];
        cell.typeLabel.text = dict[@"type"];
        if ([dict[@"type"] isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:whiteBalance]]) {
            [cell setCurrent:YES];
        }
        else{
            [cell setCurrent:NO];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (_type == SettingTypeCameraMesh) {
        CameraCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cameraCell"];
        NSDictionary *dict = _meshArray[indexPath.row];
        cell.typeLabel.text = dict[@"type"];
        cell.valueLabel.text = dict[@"value"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([dict[@"type"] isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"mesh"]]) {
            [cell setCurrent:YES];
        }
        else{
            [cell setCurrent:NO];
        }
        return cell;
    }
    if (_type == SettingTypeYunTai) {
        CameraCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cameraCell"];
        NSDictionary *dict = _deviceSettingArray[indexPath.row];
        cell.typeLabel.text = dict[@"type"];
        cell.valueLabel.text = dict[@"value"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (_type == SettingTypeCameraISO) {
        SliderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sliderCell"];
        cell.minLabel.text = @(_backDevice.activeFormat.minISO).stringValue;
        cell.maxLabel.text = @(_backDevice.activeFormat.maxISO).stringValue;
        cell.delegate = self;
        return cell;
    }
    if (_type == SettingTypeCameraExposure) {
        SliderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sliderCell"];
        cell.minLabel.text = @"-12";
        cell.maxLabel.text = @"12";
        cell.delegate = self;
        return cell;
    }
    else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    if (_type == SettingTypeCamera) {
        NSDictionary *dict = _cameraSettingArray[indexPath.row];
        if ([dict[@"type"] isEqualToString:@"Resolution"]) {
            self.type = SettingTypeCameraResolution;
        }
        else if ([dict[@"type"] isEqualToString:@"White Balance"]){
            self.type = SettingTypeCameraWhiteBalance;
        }
        else if ([dict[@"type"] isEqualToString:@"Mesh"]){
            self.type = SettingTypeCameraMesh;
        }
        else if ([dict[@"type"] isEqualToString:@"ISO"]){
            self.type = SettingTypeCameraISO;
        }
        else if ([dict[@"type"] isEqualToString:@"Exposure Compensation"]){
            self.type = SettingTypeCameraExposure;
        }
        else if ([dict[@"type"] isEqualToString:@"Flash"]) {
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:flash] isEqualToString:@"close"]) {
                [_backDevice lockForConfiguration:NULL];
                [_backDevice setFlashMode:AVCaptureFlashModeOn];
                [_backDevice setTorchMode:AVCaptureTorchModeOn];
                [_backDevice unlockForConfiguration];
                CameraCell *c = (CameraCell *)cell;
                c.valueLabel.text = @"open";
                [[NSUserDefaults standardUserDefaults] setValue:@"open" forKey:flash];
            }
            else{
                [_backDevice lockForConfiguration:NULL];
                [_backDevice setFlashMode:AVCaptureFlashModeOff];
                [_backDevice setTorchMode:AVCaptureTorchModeOff];
                [_backDevice unlockForConfiguration];
                CameraCell *c = (CameraCell *)cell;
                c.valueLabel.text = @"close";
                [[NSUserDefaults standardUserDefaults] setValue:@"close" forKey:flash];
            }
        }
        _cameraBtn.selected = YES;
        return;
    }
    if (_type == SettingTypeCameraResolution) {
        NSDictionary *dict = _resolutionArray[indexPath.row];
        [_captureSession setSessionPreset:dict[@"value"]];
        [[NSUserDefaults standardUserDefaults] setValue:dict[@"value"] forKey:resolution];
        [self subTableBack];
    }
    if (_type == SettingTypeCameraMesh) {
        NSDictionary *dict = _meshArray[indexPath.row];
        [[NSUserDefaults standardUserDefaults] setValue:dict[@"type"] forKey:mesh];
        [self subTableBack];
    }
    if (_type == SettingTypeCameraWhiteBalance) {
        NSDictionary *dict = _whiteBalanceArray[indexPath.row];
        [[NSUserDefaults standardUserDefaults] setValue:dict[@"type"] forKey:whiteBalance];
        if ([dict[@"type"] isEqualToString:@"Auto"]) {
            [_backDevice lockForConfiguration:NULL];
            if ([_backDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
                [_backDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
                
//                _backDevice setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains:<#(AVCaptureWhiteBalanceGains)#> completionHandler:<#^(CMTime syncTime)handler#>
            }
            [_backDevice unlockForConfiguration];
        }
        [self subTableBack];
    }
}

- (void)sliderValueChange:(CGFloat)value{
    if (_type == SettingTypeCameraISO) {
        if (!_isFront) {
            [_backDevice lockForConfiguration:NULL];
            NSInteger v = (_backDevice.activeFormat.maxISO - _backDevice.activeFormat.minISO) * value + _backDevice.activeFormat.minISO;
            [_backDevice setExposureModeCustomWithDuration:AVCaptureExposureDurationCurrent ISO:v completionHandler:^(CMTime syncTime) {
                
            }];
            [_backDevice unlockForConfiguration];
        }
    }
    if (_type == SettingTypeCameraExposure) {
        if (!_isFront) {
            [_backDevice lockForConfiguration:NULL];
            CGFloat v = (CMTimeGetSeconds(_backDevice.activeFormat.maxExposureDuration) - CMTimeGetSeconds(_backDevice.activeFormat.minExposureDuration)) * value + CMTimeGetSeconds(_backDevice.activeFormat.minExposureDuration);
            [_backDevice setExposureTargetBias:v completionHandler:^(CMTime syncTime) {
                
            }];
            [_backDevice unlockForConfiguration];
        }
    }
}

- (void)captureOutput:(AVCaptureFileOutput *)output didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections{
    
}

- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error{
    
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

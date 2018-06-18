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
#import "GalleryViewController.h"
#import "BluetoothManager.h"
#import "UIImage+GradientColor.h"
#import <Photos/Photos.h>
#import "MTClockView.h"
#import "FocusSlider.h"
#import "CircleView.h"
#import "AdjustView.h"

@interface DiagonalView : UIView

@end

@implementation DiagonalView

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 0.5);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, 1,1,1,1.0);  //线的颜色
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);  //起点坐标
    CGContextAddLineToPoint(context, Width, Height);   //终点坐标
    
    CGContextMoveToPoint(context, Width, 0);  //起点坐标
    CGContextAddLineToPoint(context, 0, Height);   //终点坐标
    
    CGContextMoveToPoint(context, Width/3, 0);  //起点坐标
    CGContextAddLineToPoint(context, Width/3, Height);   //终点坐标

    CGContextMoveToPoint(context, Width*2/3, 0);  //起点坐标
    CGContextAddLineToPoint(context, Width*2/3, Height);   //终点坐标

    CGContextMoveToPoint(context, 0, Height/3);  //起点坐标
    CGContextAddLineToPoint(context, Width, Height/3);   //终点坐标

    CGContextMoveToPoint(context, 0, Height*2/3);  //起点坐标
    CGContextAddLineToPoint(context, Width, Height*2/3);   //终点坐标
    
    CGContextStrokePath(context);
}

@end

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

@interface ShootViewController ()<UITableViewDelegate,UITableViewDataSource,SliderCellDelegate,AVCaptureFileOutputRecordingDelegate,CAAnimationDelegate>
{
    CGFloat angle;
    CGFloat preAngle;
    CGFloat sub;
    
    CGFloat rightAngle;
}

@property (weak, nonatomic) CAShapeLayer *maskLayer;

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

@property (nonatomic, assign) AVCaptureWhiteBalanceGains autoGains;

@property (nonatomic, strong) NSTimer *recordTimer;

@property (nonatomic, assign) NSInteger second;

@property (nonatomic, strong) UIView *meshView;

@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, strong) DiagonalView *diagonalView;

@property (nonatomic, strong) CAGradientLayer *leftLayer;

@property (nonatomic, strong) CAGradientLayer *rightLayer;

@property (nonatomic, strong) PHAssetCollection *taroAssetCollection;

@property (nonatomic, strong) MTClockView *clockView;

@property (nonatomic, strong) UIView *panView;

@property (nonatomic, strong) UIImageView *arrowView;

@property (nonatomic, strong) UIView *swipeView;

@property (nonatomic, strong) FocusSlider *focusSlider;

@property (nonatomic, strong) UIImageView *circleImageView;

@property (nonatomic, strong) UILabel *focusLabel;

@property (nonatomic, strong) AdjustView *adjustView;

@end

@implementation ShootViewController

/**
 *  present 动画
 */
- (void)presentAnimation
{
    CGRect rect = CGRectMake(0, 0, 20, 20);
    /*⏰ ----- fromView 隐藏的动画 ----- ⏰*/
    
    /// 创建一个 CAShapeLayer 来负责展示圆形遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.bounds    = rect;
    maskLayer.position  = CGPointMake(self.saveBtn.bounds.size.width/2, self.saveBtn.bounds.size.height/2);
    maskLayer.fillColor = self.maskView.backgroundColor.CGColor;
    [self.saveBtn.layer addSublayer:maskLayer];
    self.maskLayer = maskLayer;
    
    /// 开始的圆环
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    /// 半径
    CGFloat radius = [self radiusOfBubbleInView:self.maskView startPoint:CGPointMake(CGRectGetMidX(rect),                 CGRectGetMidY(rect))];
    /// 结束的圆环
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, -radius, -radius)];
    
    maskLayer.path = endPath.CGPath;
    
    /// 圆形放大动画
    CABasicAnimation *sourceAnima = [CABasicAnimation animationWithKeyPath:@"path"];
    sourceAnima.fromValue = (__bridge id)(startPath.CGPath);
    sourceAnima.toValue   = (__bridge id)(endPath.CGPath);
    sourceAnima.duration  = 1;
    sourceAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    sourceAnima.delegate  = self;
    [maskLayer addAnimation:sourceAnima forKey:NULL];
    
    
    /*⏰ ----- toView 显示的动画 ----- ⏰*/
    /// 目标视图最终显示的位置
    self.maskView.layer.position = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    /// 位移与缩放的动画
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 1;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    /// 位移
    CABasicAnimation *positionAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnim.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(self.saveBtn.frame), CGRectGetMidY(self.saveBtn.frame))];
    positionAnim.toValue   = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(self.maskView.bounds), CGRectGetMidY(self.maskView.bounds))];
    /// 缩放
    CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnima.fromValue = @0;
    scaleAnima.toValue   = @1;
    
    group.animations = @[positionAnim, scaleAnima];
    [self.maskView.layer addAnimation:group forKey:NULL];
}

///**
// *  dismiss 动画
// */
//- (void)dismissAnimation
//{
//    [self.contaionerView addSubview:self.toView];
//    [self.contaionerView addSubview:self.fromView];
//
//    /*⏰ ----- toView 显示的动画 ----- ⏰*/
//
//    /// 创建一个 CAShapeLayer 来负责展示圆形遮盖
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    maskLayer.bounds    = self.toView.layer.bounds;
//    maskLayer.position  = self.toView.layer.position;
//    maskLayer.fillColor = self.strokeColor.CGColor ?: self.fromView.backgroundColor.CGColor;
//    [self.toView.layer addSublayer:maskLayer];
//    self.maskLayer = maskLayer;
//
//    /// 半径
//    CGFloat radius = [self radiusOfBubbleInView:self.toView startPoint:CGPointMake(CGRectGetMidX(self.sourceRect), CGRectGetMidY(self.sourceRect))];
//    /// 开始的圆环
//    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.sourceRect, -radius, -radius)];
//
//    /// 结束的圆环
//    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:self.sourceRect];
//
//    maskLayer.path = endPath.CGPath;
//
//    /// 圆形缩小动画
//    CABasicAnimation *destAnima = [CABasicAnimation animationWithKeyPath:@"path"];
//    destAnima.fromValue = (__bridge id)(startPath.CGPath);
//    destAnima.toValue   = (__bridge id)(endPath.CGPath);
//    destAnima.duration  = self.duration;
//    destAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    [maskLayer addAnimation:destAnima forKey:NULL];
//
//
//    /*⏰ ----- fromView 隐藏的动画 ----- ⏰*/
//    /// fromView 最终的位置
//    self.fromView.layer.position = CGPointMake(CGRectGetMidX(self.sourceRect), CGRectGetMidY(self.sourceRect));
//    self.fromView.transform = CGAffineTransformMakeScale(0, 0);
//    /// 位移与缩放的动画
//    CAAnimationGroup *group = [CAAnimationGroup animation];
//    group.delegate = self;
//    group.duration = self.duration;
//    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//
//    /// 位移
//    CABasicAnimation *positionAnim = [CABasicAnimation animationWithKeyPath:@"position"];
//    positionAnim.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(self.fromView.bounds), CGRectGetMidY(self.fromView.bounds))];
//    positionAnim.toValue   = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(self.sourceRect), CGRectGetMidY(self.sourceRect))];
//    positionAnim.duration = self.duration;
//    /// 缩放
//    CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    scaleAnima.fromValue = @1;
//    scaleAnima.toValue   = @0;
//
//    group.animations = @[positionAnim, scaleAnima];
//    [self.fromView.layer addAnimation:group forKey:NULL];
//}

/**
 *  获取 view 的四个顶点 与 startPoint 点之前的最大距离
 *
 *  @param view         视图
 *  @param startPoint   顶点
 */
- (CGFloat)radiusOfBubbleInView:(UIView *)view startPoint:(CGPoint)startPoint
{
    /// 获取 view 上面四个顶点的坐标
    CGPoint point1 = CGPointMake(0, 0);
    CGPoint point2 = CGPointMake(CGRectGetWidth(view.bounds), 0);
    CGPoint point3 = CGPointMake(0, CGRectGetHeight(view.bounds));
    CGPoint point4 = CGPointMake(CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    
    NSArray *pointsArr = @[[NSValue valueWithCGPoint:point1],
                           [NSValue valueWithCGPoint:point2],
                           [NSValue valueWithCGPoint:point3],
                           [NSValue valueWithCGPoint:point4]];
    
    CGFloat maxRadius = 0;
    
    for (NSValue *value in pointsArr)
    {
        CGPoint point = value.CGPointValue;
        
        CGFloat deltaX = point.x - startPoint.x;
        CGFloat deltaY = point.y - startPoint.y;
        
        CGFloat radius = sqrt(deltaX * deltaX + deltaY * deltaY);
        
        if (maxRadius < radius)
        {
            maxRadius = radius;
        }
    }
    
    return maxRadius;
}


#pragma mark - 💉 👀 CAAnimationDelegate 👀

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    // 移除遮罩layer
    [_maskLayer removeFromSuperlayer];
    _maskLayer = nil;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_recordTimer invalidate];
    _recordTimer = nil;
}

- (void)configCameraSetting{
//    if (![[NSUserDefaults standardUserDefaults] valueForKey:resolution]) {
        [[NSUserDefaults standardUserDefaults] setValue:AVCaptureSessionPreset1920x1080 forKey:resolution];
//    }
//    if (![[NSUserDefaults standardUserDefaults] valueForKey:mesh]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"None" forKey:mesh];
//    }
//    if (![[NSUserDefaults standardUserDefaults] valueForKey:iso]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:iso];
//    }
//    if (![[NSUserDefaults standardUserDefaults] valueForKey:exposureCompensation]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:exposureCompensation];
//    }
//    if (![[NSUserDefaults standardUserDefaults] valueForKey:flash]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"close" forKey:flash];
//    }
//    if (![[NSUserDefaults standardUserDefaults] valueForKey:whiteBalance]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"Auto" forKey:whiteBalance];
//    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSURL *)getFilePath{
    NSInteger time = [[NSDate date] timeIntervalSince1970];
    NSString *times = @(time).stringValue;
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
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstRecord"]) {
            _maskViewHeightConstraint.constant = 0;
            _maskViewWidthConstraint.constant = 0;
            [UIView animateWithDuration:1 animations:^{
                [self.view layoutIfNeeded];
            }];
        }
        else{
            _saveBtn.hidden = NO;
        }
        _recordTimeLabel.hidden = NO;
        _redImageView.hidden = NO;
        _maskRedImageView.hidden = NO;
        _second = 0;
        _trakingBtn.hidden = YES;
        self.type = SettingTypeNone;
        _recordTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_recordTimer forMode:NSRunLoopCommonModes];
        [_recordTimer fire];
        _recordViewTimeLabel.hidden = NO;
        _leftViewLeadingConstraint.constant = 70;
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    else{
        _saveBtn.hidden = YES;
        _trakingBtn.hidden = NO;
        _redImageView.hidden = YES;
        _maskRedImageView.hidden = YES;
        _leftViewLeadingConstraint.constant = 0;
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        }];
        _recordTimeLabel.hidden = YES;
        _recordViewTimeLabel.hidden = YES;
        [_output stopRecording];
        [_recordTimer invalidate];
        _recordTimer = nil;
    }
}

- (void)timerAction{
    _second += 1;
    _recordTimeLabel.text = [NSString stringWithFormat:@"  %@",[self timeFromSeconds:_second]];
    _recordViewTimeLabel.text = [NSString stringWithFormat:@"  %@",[self timeFromSeconds:_second]];
}

- (void)dealloc
{
    
}

- (NSString *)timeFromSeconds:(NSInteger)seconds
{
    int m = seconds/60;
    int s = seconds%60;
    NSString *mString ;
    NSString *sString ;
    if (m<10)
        mString =[NSString stringWithFormat:@"0%d",m];
    else
        mString =[NSString stringWithFormat:@"%d",m];
    
    if (s<10)
        sString =[NSString stringWithFormat:@"0%d",s];
    else
        sString =[NSString stringWithFormat:@"%d",s];
    
    return  [NSString stringWithFormat:@"%@:%@",mString,sString];
    
}

- (IBAction)bluetoothAction:(UIButton *)sender {
    if (sender.selected) {
        self.type = SettingTypeNone;
    }
    else{
        _settingViewWidth.constant = 300;
        [UIView animateWithDuration:0.25 animations:^{
            [_settingView layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
        self.type = SettingTypeBluetooth;
        sender.selected = !sender.selected;
    }
}

- (void)setType:(SettingType)type{
    if (type != SettingTypeNone) {
        [_leftLayer removeFromSuperlayer];
        _leftView.backgroundColor = UIColorFromRGBAndAlpha(0x000000, 0.8);
        _settingMaskView.hidden = NO;
    }
    if (type == SettingTypeNone) {
        _leftView.backgroundColor = [UIColor clearColor];
        [self setViewGradient];
        _settingMaskView.hidden = YES;
    }
    _type = type;
    _bluetoothBtn.selected = _cameraBtn.selected = _yuntaiBtn.selected = _deviceBtn.selected = NO;
    switch (type) {
        case SettingTypeNone:{
            _settingViewWidth.constant = 0;
            [_settingView layoutIfNeeded];
        }
            break;
        case SettingTypeBluetooth:{
            _settingTitle.text = @"Taro List";
            _subTable.hidden = YES;
            _settingTable.hidden = NO;
            [_settingTable reloadData];
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
        [UIView animateWithDuration:0.25 animations:^{
            [_settingView layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        self.type = SettingTypeCamera;
        sender.selected = !sender.selected;
    }
}

- (IBAction)cameraDeviceAction:(id)sender {
    self.type = SettingTypeNone;
    //切换前后摄像头
    [_captureSession beginConfiguration];
    if (_isFront) {
        [_captureSession removeInput:_frontInput];
        [_captureSession addInput:_backInput];
        _isFront = NO;
    }
    else{
        NSString *currentSolution = [[NSUserDefaults standardUserDefaults] valueForKey:resolution];
        if ([_frontDevice supportsAVCaptureSessionPreset:currentSolution]) {
            [_captureSession setSessionPreset:currentSolution];
        }
        else if ([_frontDevice supportsAVCaptureSessionPreset:AVCaptureSessionPreset1280x720]){
            [_captureSession setSessionPreset:AVCaptureSessionPreset1280x720];
            [[NSUserDefaults standardUserDefaults] setValue:AVCaptureSessionPreset1280x720 forKey:resolution];
        }
        else{
            [_captureSession setSessionPreset:AVCaptureSessionPreset640x480];
            [[NSUserDefaults standardUserDefaults] setValue:AVCaptureSessionPreset640x480 forKey:resolution];
        }
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

- (void)setViewGradient{
//    _leftView.backgroundColor = [UIColor colorWithPatternImage:[UIImage gradientColorImageFromColors:@[UIColorFromRGBAndAlpha(0x000000,1),UIColorFromRGBAndAlpha(0x000000,0)] gradientType:GradientTypeUpleftToLowright imgSize:_leftView.frame.size]];
//    _leftView.alpha = 0.2;
    if (_leftLayer) {
        [_leftView.layer addSublayer:_leftLayer];
    }
    else{
        UIColor *startColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        UIColor *endColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        _leftLayer = [[CAGradientLayer alloc] init];
        _leftLayer.colors = @[(__bridge id)startColor.CGColor,(__bridge id)endColor.CGColor];
        _leftLayer.startPoint = CGPointMake(0, 0);
        _leftLayer.endPoint = CGPointMake(1,0);
        _leftLayer.frame = CGRectMake(0, 0, 70, Height);
        _leftLayer.zPosition = -100;
        [_leftView.layer addSublayer:_leftLayer];
    }
    if (!_rightLayer) {
        UIColor *startColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        UIColor *endColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        _rightLayer = [[CAGradientLayer alloc] init];
        _rightLayer.colors = @[(__bridge id)startColor.CGColor,(__bridge id)endColor.CGColor];
        _rightLayer.startPoint = CGPointMake(1, 0);
        _rightLayer.endPoint = CGPointMake(0,0);
        _rightLayer.frame = CGRectMake(0, 0, 76, Height);
        _rightLayer.zPosition = -100;
        [_rightView.layer addSublayer:_rightLayer];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)tapAction{
    self.type = SettingTypeNone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTaroAlbum];
    [self setViewGradient];
    _type = SettingTypeNone;
    _gifImageView.image = [YYImage imageNamed:@"连接摄像头GIF.gif"];
    _maskViewWidthConstraint.constant = -Width;
    _maskViewHeightConstraint.constant = -Height;
    _turnOffBtn.layer.cornerRadius = 4;
    _turnOffBtn.layer.masksToBounds = YES;
    [_maskView layoutIfNeeded];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_settingMaskView addGestureRecognizer:tap];
    _trackingAlertViewTopConstraint.constant = - Height;
    [self.view layoutIfNeeded];
    [self configCameraSetting];
    [self configView];
    _captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        [_captureSession setSessionPreset:[[NSUserDefaults standardUserDefaults] valueForKey:resolution]];
    }
    _backDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    _autoGains = [_backDevice deviceWhiteBalanceGains];
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
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    previewLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;

    [self.videoView.layer addSublayer:previewLayer];
    [_captureSession startRunning];
    _output = [[AVCaptureMovieFileOutput alloc] init];
    CMTime maxDuration = CMTimeMake(3600, 1);//最大20分钟
    _output.maxRecordedDuration = maxDuration;
    _output.minFreeDiskSpaceLimit = 1024;
    if ([_captureSession canAddOutput:_output]) {
        [_captureSession addOutput:_output];
    }
    // 视频输出也需要设置成横屏的
    AVCaptureConnection *outputVideoConnection = [_output connectionWithMediaType:AVMediaTypeVideo];
    outputVideoConnection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
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

- (void)setconfigArray{
    _cameraSettingArray = @[@{@"type":@"Resolution",@"value":[self getResolution]},
                            @{@"type":@"White Balance",@"value":[[NSUserDefaults standardUserDefaults] valueForKey:whiteBalance]},
                            @{@"type":@"ISO",@"value":[[NSUserDefaults standardUserDefaults] valueForKey:iso]},
                            @{@"type":@"Exposure Compensation",@"value":[[NSUserDefaults standardUserDefaults] valueForKey:exposureCompensation]},
                            @{@"type":@"Flash",@"value":[[NSUserDefaults standardUserDefaults] valueForKey:flash]},
                            @{@"type":@"Mesh",@"value":[[NSUserDefaults standardUserDefaults] valueForKey:mesh]}];
    _bluetoothArray = [BluetoothManager shareInstance].bluetoothArray;
    _resolutionArray = @[@{@"type":@"1080p",@"value":AVCaptureSessionPreset1920x1080},@{@"type":@"720p",@"value":AVCaptureSessionPreset1280x720},@{@"type":@"480p",@"value":AVCaptureSessionPreset640x480}];
    _whiteBalanceArray = @[@{@"type":@"Auto",@"value":@"a w b"},@{@"type":@"Daylight",@"value":@"太阳"},@{@"type":@"Cloud Daylight",@"value":@"云"},@{@"type":@"Incandescent",@"value":@"灯泡"},@{@"type":@"Fluorescent",@"value":@"糖"}];
    _meshArray = @[@{@"type":@"None",@"value":@""},@{@"type":@"Mesh",@"value":@""},@{@"type":@"Mesh and Diagonal",@"value":@""},@{@"type":@"Center Point",@"value":@""}];
    _deviceSettingArray = @[@{@"type":@"Speed",@"value":@"Normal"},@{@"type":@"Device Mode",@"value":@"Full Follow"},@{@"type":@"Tracking Cursor",@"value":@"off"}];
}

- (void)configView{
    [self setconfigArray];
    _settingTable.delegate = self;
    _settingTable.dataSource = self;
    [_settingTable registerNib:[UINib nibWithNibName:@"TaroCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [_settingTable registerNib:[UINib nibWithNibName:@"CameraCell" bundle:nil] forCellReuseIdentifier:@"cameraCell"];
    _settingTable.rowHeight = 60;
    _settingTable.tableFooterView = [UIView new];
    _settingTable.backgroundColor = UIColorFromRGBAndAlpha(0x000000, 0.6);
    _subTable.delegate = self;
    _subTable.dataSource = self;
    [_subTable registerNib:[UINib nibWithNibName:@"CameraCell" bundle:nil] forCellReuseIdentifier:@"cameraCell"];
    _subTable.rowHeight = 60;
    [_subTable registerNib:[UINib nibWithNibName:@"WhiteBalanceCell" bundle:nil] forCellReuseIdentifier:@"whiteBalanceCell"];
    [_subTable registerNib:[UINib nibWithNibName:@"SliderCell" bundle:nil] forCellReuseIdentifier:@"sliderCell"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"back" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(235, 10, 50, 30);
    button.backgroundColor = AlertBlueColor;
    button.layer.cornerRadius = 6;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(subTableBack) forControlEvents:UIControlEventTouchUpInside];
    UIView *footerView = [[UIView alloc] initWithFrame:(CGRect){0,0,300,60}];
    [footerView addSubview:button];
    _subTable.tableFooterView = footerView;
    _subTable.backgroundColor = UIColorFromRGBAndAlpha(0x000000, 0.6);
    
//    angle = 0;
//    preAngle = 0;
//
//
//    _focusSlider = [[FocusSlider alloc] initWithFrame:(CGRect){Width - Height/2.0 - 35,-35,Height + 70, Height + 70}];
//    _focusSlider.transform = CGAffineTransformMakeRotation(-M_PI_2);
//    [_focusSlider addTarget:self action:@selector(focusSliderValueChange:) forControlEvents:UIControlEventValueChanged];
//    [self.view insertSubview:self.focusSlider belowSubview:_recordBtn];
//
//    _clockView = [[MTClockView alloc] initWithFrame:(CGRect){Width - Height/2,0,Height,Height}];
//    [self.view insertSubview:_clockView belowSubview:_recordBtn];
//
//    _panView = [[UIView alloc] initWithFrame:(CGRect){Width - Height/2+50,0,Height,Height}];
//    _panView.backgroundColor = [UIColor clearColor];
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleClockPan:)];
//    [panGesture setMaximumNumberOfTouches:1];
//    panGesture.delegate = self;
//
//    [_panView addGestureRecognizer:panGesture];
//    _panView.layer.cornerRadius = Height/2;
//    _panView.layer.masksToBounds = YES;
//    _panView.clipsToBounds = YES;
//    _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(Width-Height/2-6, Height/2 - 8, 16, 16)];
//    _arrowView.image = [UIImage imageNamed:@"箭头 三角形"];
//    [self.view addSubview:_arrowView];
//    [self.view insertSubview:_panView belowSubview:_recordBtn];
//
//    _focusLabel.hidden = _focusSlider.hidden = _panView.hidden = _arrowView.hidden = _clockView.hidden = YES;
    
    self.adjustView = [[AdjustView alloc] initWithFrame:(CGRect){Width - Height/2.0 - 50,-50,Height + 100, Height + 100}];
    [self.adjustView.sliderView addTarget:self action:@selector(focusSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    self.adjustView.hidden = YES;
    [self.view insertSubview:self.adjustView belowSubview:self.recordBtn];
    _swipeView = [[UIView alloc] initWithFrame:(CGRect){0,0,Width,Height}];
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    leftSwipeGesture.delegate = self;
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.swipeView addGestureRecognizer:leftSwipeGesture];
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.swipeView addGestureRecognizer:rightSwipeGesture];
    [self.view insertSubview:self.swipeView belowSubview:self.focusSlider];
    
    _focusLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,40,18}];
    _focusLabel.textColor = [UIColor whiteColor];
    _focusLabel.font = [UIFont systemFontOfSize:15];
    _focusLabel.center = CGPointMake(Width/2, Height/2);
    [self.view addSubview:_focusLabel];
    
//    CircleView *circleView = [[CircleView alloc] initWithFrame:(CGRect){100,0,Height,Height}];
//    circleView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:circleView];
//    [circleView addGestureRecognizer:panGesture];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    CGPoint point = [touch locationInView:touch.view];
//    if (point.x * point.x + point.y * point.y > Height/2*Height/2) {
//        return NO;
//    }
//    return YES;
//}

- (void)focusSliderValueChange:(FocusSlider *)slider{
    _focusLabel.hidden = NO;
    float value;
    if (slider.value < 0) {
        value = (0 - slider.value)*1.0/120.0 + 0.5;
    }
    else{
        value = (60-slider.value)*1.0/120;
    }
    _focusLabel.text = [NSString stringWithFormat:@"%.2f",value];
    if (!_isFront) {
        [_backDevice lockForConfiguration:NULL];
        [_backDevice setFocusModeLockedWithLensPosition:value completionHandler:^(CMTime syncTime) {
            
        }];
        [_backDevice unlockForConfiguration];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _focusLabel.hidden = YES;
    });
}

- (void)swipe:(UISwipeGestureRecognizer *)recognizer{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
//        _focusLabel.hidden = _focusSlider.hidden = _panView.hidden = _arrowView.hidden = _clockView.hidden = NO;
        _adjustView.hidden = NO;
//        _focusLabel.hidden = _focusSlider.hidden = NO;
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight){
//        _focusLabel.hidden = _focusSlider.hidden = _panView.hidden = _arrowView.hidden = _clockView.hidden = YES;
        _adjustView.hidden = YES;
    }
}


- (void)handleClockPan:(UIPanGestureRecognizer *)recognizer {
    UIView *view = recognizer.view;
    CGPoint translation = [recognizer locationInView:view];
    
    //    NSLog(@"translationX:%f\ntranslationY:%f",translation.x,translation.y);
    CGFloat angleInRadians = atan2f(translation.y - view.frame.size.height/2, translation.x - view.frame.size.width/2);
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        angle = angleInRadians;
    }
    sub = angleInRadians - angle;
    CGFloat sumAngle = sub + preAngle;
    self.clockView.transform = CGAffineTransformMakeRotation(sumAngle);
    rightAngle = (sumAngle) * 180 / M_PI;
    int x = rightAngle / 3.6;
    x = x%100;
    float y = x*1.0/10;
    NSLog(@"x=%.2f",x*1.0/10);
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        preAngle += sub;
    }
//    if (!_isFront) {
//        [_backDevice lockForConfiguration:NULL];
//        NSInteger v = (_backDevice.activeFormat.maxISO - _backDevice.activeFormat.minISO) * y + _backDevice.activeFormat.minISO;
//        [[NSUserDefaults standardUserDefaults] setValue:@(v).stringValue forKey:iso];
//        [_backDevice setExposureModeCustomWithDuration:AVCaptureExposureDurationCurrent ISO:v completionHandler:^(CMTime syncTime) {
//
//        }];
//        [_backDevice unlockForConfiguration];
//    }
}

- (void)subTableBack{
    self.type = SettingTypeCamera;
    _cameraBtn.selected = YES;
    [self setconfigArray];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_type == SettingTypeCamera) {
        return _cameraSettingArray.count;
    }
    if (_type == SettingTypeBluetooth) {
        return _bluetoothArray.count;
//        return 1;
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
        TaroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        CBPeripheral *per = _bluetoothArray[indexPath.row];
        NSString *connectDevice = [[NSUserDefaults standardUserDefaults] valueForKey:@"bluetooth"];
        if ([per.identifier.UUIDString isEqualToString:connectDevice]) {
            [cell setConnect:YES];
        }
        else{
            [cell setConnect:NO];
        }
        NSString *name = per.name;
        if ([name containsString:@"Smooth-"]) {
            name = [name stringByReplacingOccurrencesOfString:@"Smooth-" withString:@"Taro-"];
        }
        if ([name containsString:@"Smooth"]) {
            name = [name stringByReplacingOccurrencesOfString:@"Smooth" withString:@"Taro-"];
        }
        cell.bluetoothLabel.text = name;
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
        cell.iconImageView.image = [UIImage imageNamed:dict[@"value"]];
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
        [self setconfigArray];
        [self subTableBack];
    }
    if (_type == SettingTypeCameraMesh) {
        NSDictionary *dict = _meshArray[indexPath.row];
        [[NSUserDefaults standardUserDefaults] setValue:dict[@"type"] forKey:mesh];
        [self configNone];
        if ([dict[@"type"] isEqualToString:@"Mesh"]) {
            [self configMeshView];
        }
        else if ([dict[@"type"] isEqualToString:@"Mesh and Diagonal"]){
            [self configDiagonalView];
        }
        else if ([dict[@"type"] isEqualToString:@"Center Point"]){
            [self configCenterView];
        }
        [self setconfigArray];
        [self subTableBack];
    }
    if (_type == SettingTypeCameraWhiteBalance) {
        NSDictionary *dict = _whiteBalanceArray[indexPath.row];
        [[NSUserDefaults standardUserDefaults] setValue:dict[@"type"] forKey:whiteBalance];
        if ([dict[@"type"] isEqualToString:@"Auto"]) {
            [_backDevice lockForConfiguration:NULL];
            [_backDevice setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains:_autoGains completionHandler:^(CMTime syncTime) {
                
            }];
            [_backDevice unlockForConfiguration];
        }
        if ([dict[@"type"] isEqualToString:@"Incandescent"]) {
            [_backDevice lockForConfiguration:NULL];
            AVCaptureWhiteBalanceTemperatureAndTintValues tem;
            tem.temperature = 3500;
            tem.tint = 0;
            AVCaptureWhiteBalanceGains gains = [_backDevice deviceWhiteBalanceGainsForTemperatureAndTintValues:tem];
            [_backDevice setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains:gains completionHandler:^(CMTime syncTime) {
                
            }];
        }
        if ([dict[@"type"] isEqualToString:@"Daylight"]) {
            [_backDevice lockForConfiguration:NULL];
            AVCaptureWhiteBalanceTemperatureAndTintValues tem;
            tem.temperature = 4500;
            tem.tint = 0;
            AVCaptureWhiteBalanceGains gains = [_backDevice deviceWhiteBalanceGainsForTemperatureAndTintValues:tem];
            
            [_backDevice setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains:gains completionHandler:^(CMTime syncTime) {
                
            }];
        }
        if ([dict[@"type"] isEqualToString:@"Fluorescent"]) {
            [_backDevice lockForConfiguration:NULL];
            AVCaptureWhiteBalanceTemperatureAndTintValues tem;
            tem.temperature = 5500;
            tem.tint = 0;
            AVCaptureWhiteBalanceGains gains = [_backDevice deviceWhiteBalanceGainsForTemperatureAndTintValues:tem];
            
            [_backDevice setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains:gains completionHandler:^(CMTime syncTime) {
                
            }];
        }
        if ([dict[@"type"] isEqualToString:@"Cloud Daylight"]) {
            [_backDevice lockForConfiguration:NULL];
            AVCaptureWhiteBalanceTemperatureAndTintValues tem;
            tem.temperature = 6500;
            tem.tint = 0;
            AVCaptureWhiteBalanceGains gains = [_backDevice deviceWhiteBalanceGainsForTemperatureAndTintValues:tem];
            
            [_backDevice setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains:gains completionHandler:^(CMTime syncTime) {
                
            }];
        }
        [_backDevice unlockForConfiguration];
        [self setconfigArray];
        [self subTableBack];
    }
    if (_type == SettingTypeBluetooth) {
        CBPeripheral *per = _bluetoothArray[indexPath.row];
        [[BluetoothManager shareInstance] connect:per result:^(ConnectResultType result) {
            
        }];
    }
}

- (void)sliderValueChange:(CGFloat)value{
    if (_type == SettingTypeCameraISO) {
        if (!_isFront) {
            [_backDevice lockForConfiguration:NULL];
            NSInteger v = (_backDevice.activeFormat.maxISO - _backDevice.activeFormat.minISO) * value + _backDevice.activeFormat.minISO;
            [[NSUserDefaults standardUserDefaults] setValue:@(v).stringValue forKey:iso];
            [_backDevice setExposureModeCustomWithDuration:AVCaptureExposureDurationCurrent ISO:v completionHandler:^(CMTime syncTime) {
                
            }];
            [_backDevice unlockForConfiguration];
        }
    }
    if (_type == SettingTypeCameraExposure) {
        if (!_isFront) {
            [_backDevice lockForConfiguration:NULL];
            CGFloat v = (CMTimeGetSeconds(_backDevice.activeFormat.maxExposureDuration) - CMTimeGetSeconds(_backDevice.activeFormat.minExposureDuration)) * value + CMTimeGetSeconds(_backDevice.activeFormat.minExposureDuration);
            NSInteger inte = 24 * value - 12;
            [[NSUserDefaults standardUserDefaults] setValue:@(inte).stringValue forKey:exposureCompensation];
            [_backDevice setExposureTargetBias:v completionHandler:^(CMTime syncTime) {
                
            }];
            [_backDevice unlockForConfiguration];
        }
    }
}

- (void)captureOutput:(AVCaptureFileOutput *)output didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections{
    
}

- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error{
    __block NSString *createdAssetId = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:outputFileURL].placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:_taroAssetCollection];
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetId] options:nil].firstObject;
            NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            NSURL *outputURL = [NSURL fileURLWithPath:document isDirectory:YES];
            outputURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@.mov",@([asset.creationDate timeIntervalSince1970]).stringValue] relativeToURL:outputURL];
            NSError *error;
            if ([[NSFileManager defaultManager] moveItemAtURL:outputFileURL toURL:outputURL error:&error]) {
                NSLog(@"%@",outputURL);
            }
            else{
                
            }
            [request addAssets:@[asset]];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                GalleryViewController *vc = [[GalleryViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            });
        }];
    }];
}

- (NSURL *)getAssetFileOutUrl:(NSString *)identifier{
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileString = [identifier stringByAppendingString:@".mov"];
    document = [document stringByAppendingPathComponent:fileString];
    return [NSURL fileURLWithPath:fileString];
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

- (IBAction)trackingAction:(UIButton *)sender {
//    sender.selected = !sender.selected;
    _trackingAlertViewTopConstraint.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)trackingConfirmAction:(id)sender {
    _trackingAlertViewTopConstraint.constant = - Height;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)turnOffSaveModeAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstRecord"];
    _maskViewHeightConstraint.constant = -Height;
    _maskViewWidthConstraint.constant = -Width;
    [UIView animateWithDuration:1 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        _saveBtn.hidden = NO;
    }];
}

- (IBAction)saveBtnAction:(id)sender {
//    [self presentAnimation];
//    return;
    _maskViewHeightConstraint.constant = 0;
    _maskViewWidthConstraint.constant = 0;
    [UIView animateWithDuration:1 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        _saveBtn.hidden = YES;
    }];
}

- (void)configNone{
    [_meshView removeFromSuperview];
    [_centerView removeFromSuperview];
    [_diagonalView removeFromSuperview];
}

- (void)configMeshView{
    if (_meshView) {
        [self.videoView addSubview:_meshView];
    }
    else{
        _meshView = [[UIView alloc] initWithFrame:self.view.bounds];
        _meshView.backgroundColor = [UIColor clearColor];
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,Height/3,Width,0.5}];
        view.backgroundColor = [UIColor whiteColor];
        [_meshView addSubview:view];
        UIView *view1 = [[UIView alloc] initWithFrame:(CGRect){0,Height*2/3,Width,0.5}];
        view1.backgroundColor = [UIColor whiteColor];
        [_meshView addSubview:view1];
        UIView *view2 = [[UIView alloc] initWithFrame:(CGRect){Width/3,0,0.5,Height}];
        view2.backgroundColor = [UIColor whiteColor];
        [_meshView addSubview:view2];
        UIView *view3 = [[UIView alloc] initWithFrame:(CGRect){Width*2/3,0,0.5,Height}];
        view3.backgroundColor = [UIColor whiteColor];
        [_meshView addSubview:view3];
        [self.videoView addSubview:_meshView];
    }
}

- (void)configDiagonalView{
    if (_diagonalView) {
        [self.videoView addSubview:_diagonalView];
    }
    else{
        _diagonalView = [[DiagonalView alloc] init];
        _diagonalView.frame = self.videoView.bounds;
        _diagonalView.backgroundColor = [UIColor clearColor];
        [self.videoView addSubview:_diagonalView];
    }
}

- (void)configCenterView{
    if (_centerView) {
        [self.videoView addSubview:_centerView];
    }
    else{
        _centerView = [[UIView alloc] initWithFrame:self.view.bounds];
        _centerView.backgroundColor = [UIColor clearColor];
        UIView *horView = [[UIView alloc] initWithFrame:(CGRect){0,0,10,0.5}];
        horView.backgroundColor = [UIColor whiteColor];
        horView.center = _centerView.center;
        [_centerView addSubview:horView];
        UIView *verView = [[UIView alloc] initWithFrame:(CGRect){0,0,0.5,10}];
        verView.backgroundColor = [UIColor whiteColor];
        verView.center = _centerView.center;
        [_centerView addSubview:verView];
        [self.videoView addSubview:_centerView];
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

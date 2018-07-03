//
//  AdjustView.m
//  Taro
//
//  Created by wushuying on 2018/6/19.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "AdjustView.h"
#import "MTClockView.h"
#import "FocusSlider.h"
#import "GolbalDefine.h"

@implementation AdjustView
{
    UIView *panView;
    CGFloat angle;
    CGFloat preAngle;
    CGFloat sub;
    UIImageView *arrowView;
    CGFloat rightAngle;
    UIView *circleView;
    
    CGFloat totalAngle;
    
    UIButton *autoBtn;
    
    NSArray *dataArray;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        angle = 0;
        preAngle = 0;
        totalAngle = 0;
        dataArray = @[@"1000",@"997",@"975",@"904",@"755",@"600",@"553",@"364",@"227",@"140",@"88",@"56",@"37",@"25",@"18",@"13",@"9.1",@"6.7",@"5.1",@"3.9",@"3.0"];
        circleView = [[UIView alloc] initWithFrame:(CGRect){Width - Height/2.0 - 50,-50,Height + 100, Height + 100}];
        [self addSubview:circleView];
        circleView.hidden = YES;
        self.sliderView = [[FocusSlider alloc] initWithFrame:circleView.bounds];
        self.sliderView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        self.mtClockView = [[MTClockView alloc] initWithFrame:(CGRect){50,50,Height,Height}];
//        self.mtClockView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        [circleView addSubview:self.sliderView];
        [circleView addSubview:self.mtClockView];
        panView = [[UIView alloc] initWithFrame:self.mtClockView.frame];
        [circleView addSubview:panView];
        arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(44, self.center.y-8 + 50, 16, 16)];
        arrowView.image = [UIImage imageNamed:@"箭头 三角形"];
        [circleView addSubview:arrowView];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleClockPan:)];
        [panGesture setMaximumNumberOfTouches:1];
//        panGesture.delegate = self;
        [panView addGestureRecognizer:panGesture];
        autoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        autoBtn.frame = CGRectMake(Width-Height/2 - 60, 20, 70, 30);
        [autoBtn setTitle:@"Auto" forState:UIControlStateNormal];
        [autoBtn setTitle:@"Manual" forState:UIControlStateSelected];
        autoBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [autoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        autoBtn.layer.borderWidth = 2;
        autoBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        autoBtn.layer.cornerRadius = 15;
        autoBtn.layer.masksToBounds = YES;
        [autoBtn addTarget:self action:@selector(autoAction) forControlEvents:UIControlEventTouchUpInside];
        autoBtn.hidden = YES;
        [self addSubview:autoBtn];
        UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:leftSwipeGesture];
        UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:rightSwipeGesture];
    }
    return self;
}

- (void)setAutoAjust:(BOOL)autoAjust{
    _autoAjust = autoAjust;
    autoBtn.selected = !autoAjust;
}

- (void)autoAction{
    autoBtn.selected = !autoBtn.selected;
    if (autoBtn.selected) {
        //非自动
        self.autoAjust = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(autoAdjust:)]) {
            [self.delegate autoAdjust:NO];
        }
    }
    else{
        self.autoAjust = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(autoAdjust:)]) {
            [self.delegate autoAdjust:YES];
        }
    }
}

- (void)swipe:(UISwipeGestureRecognizer *)recognizer{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        //        _focusLabel.hidden = _focusSlider.hidden = _panView.hidden = _arrowView.hidden = _clockView.hidden = NO;
        autoBtn.hidden = NO;
        circleView.hidden = NO;
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight){
        //        _focusLabel.hidden = _focusSlider.hidden = _panView.hidden = _arrowView.hidden = _clockView.hidden = YES;
        circleView.hidden = YES;
        autoBtn.hidden = YES;
    }
}

- (void)handleClockPan:(UIPanGestureRecognizer *)recognizer {
    UIView *view = recognizer.view;
    CGPoint translation = [recognizer locationInView:view];
    CGFloat angleInRadians = atan2f(translation.y - view.frame.size.height, translation.x - view.frame.size.width)*2;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        angle = angleInRadians;
    }
    autoBtn.selected = YES;
    sub = angleInRadians - angle;
    angle = angleInRadians;
    CGFloat sumAngle = sub + preAngle;
//    while (sumAngle < 0) {
//        sumAngle += M_PI * 2;
//    }
//    while (sumAngle > M_PI * 2) {
//        sumAngle -= M_PI * 2;
//    }
    NSLog(@"angle:%.2f",sumAngle);
    if (totalAngle + sub >= M_PI_2) {
        totalAngle = M_PI_2;
        self.mtClockView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    else if (totalAngle + sub <= -M_PI_2) {
        totalAngle = -M_PI_2;
        self.mtClockView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    else{
        totalAngle += sub;
        self.mtClockView.transform = CGAffineTransformRotate(self.mtClockView.transform, sub);
    }
    rightAngle = (M_PI_2 - totalAngle) * 180 / M_PI;
    int x = rightAngle / 1.8;
    NSLog(@"x= %d",x);
    x = x%200;
    float y = x;
    if (totalAngle == M_PI) {
        x = 200;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(adjustISOWithFloat:)]) {
        [self.delegate adjustISOWithFloat:y];
    }
    NSLog(@"totalAngle:%.2f",totalAngle);
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        preAngle = sumAngle;
        NSLog(@"preAngle:%.2f",angleInRadians-angle);
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    if (point.x < 0) {
//        return [super hitTest:point withEvent:event];
//    }
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isEqual:autoBtn]) {
        return autoBtn;
    }
    if (circleView.hidden || point.x < Width - Height/2.0 - 50) {
        return self;
    }
//    NSLog(@"X = %.2f\nY= %.2f",point.x,point.y);
    if ((Width-point.x)*(Width-point.x) + (Height/2 - point.y)*(Height/2 - point.y) > Height*Height/4) {
        return self.sliderView;
    }
    return panView;
}

- (void)setSliderViewValue:(int)value{
    [self.sliderView autoAdjustWithAngle:value];
}

- (void)setClockViewValue:(CGFloat)second{
    float b = 1.0/second;
    int index = 0;
    NSLog(@"b:%f",b);
    NSString *pre = @"1000";
    NSString *next = @"997";
    for (int i = 0; i < dataArray.count - 1; i ++) {
        pre = dataArray[i];
        next = dataArray[i+1];
        if (pre.floatValue >= b && next.floatValue <= b ) {
            index = i;
            break;
        }
    }
    CGFloat sub = (b - next.floatValue)*(5/(pre.floatValue-next.floatValue));
    CGFloat an = (9*index*M_PI+sub*1.8)/180;
    if (an <= - M_PI_2) {
        an = - M_PI_2;
    }
    if (an >= M_PI) {
        an = M_PI;
    }
    self.mtClockView.transform = CGAffineTransformMakeRotation(M_PI_2-an);
    preAngle = M_PI_2-an;
    totalAngle = M_PI_2-an;
//    [self.mtClockView adjustWithSecond:second];
}


@end

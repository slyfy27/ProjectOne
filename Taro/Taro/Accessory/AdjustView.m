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
        
        UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:leftSwipeGesture];
        UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:rightSwipeGesture];
    }
    return self;
}

- (void)swipe:(UISwipeGestureRecognizer *)recognizer{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        //        _focusLabel.hidden = _focusSlider.hidden = _panView.hidden = _arrowView.hidden = _clockView.hidden = NO;
        
        circleView.hidden = NO;
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight){
        //        _focusLabel.hidden = _focusSlider.hidden = _panView.hidden = _arrowView.hidden = _clockView.hidden = YES;
        circleView.hidden = YES;
    }
}

- (void)handleClockPan:(UIPanGestureRecognizer *)recognizer {
    UIView *view = recognizer.view;
    CGPoint translation = [recognizer locationInView:view];
    CGFloat angleInRadians = atan2f(translation.y - view.frame.size.height, translation.x - view.frame.size.width)*2;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        angle = angleInRadians;
    }
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

//    NSLog(@"angleInRadians: %@",@(angleInRadians).stringValue);
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        angle = angleInRadians;
//    }
////    NSLog(@"xxxxxx:%@",@(angleInRadians).stringValue);
//    sub = angleInRadians - angle;
//    int x = 0;
//    CGFloat sumAngle = sub + preAngle;
//    rightAngle = (sumAngle) * 180 / M_PI + 30;
//    if (rightAngle > 0 && rightAngle < 360) {
//        x = rightAngle;
//    }
//    else if (rightAngle < 0){
//        while ((rightAngle + 360) < 0) {
//            rightAngle += 360;
//        }
//        x = rightAngle;
//    }
//    else if (rightAngle > 360){
//        while (rightAngle > 360) {
//            rightAngle -= 360;
//        }
//        x = rightAngle;
//    }
//    if (rightAngle >= 210) {
//        rightAngle = 210;
//        x = rightAngle;
////        self.mtClockView.transform = CGAffineTransformMakeRotation(M_PI);
//    }
//    if (rightAngle < 0) {
//        rightAngle = 0;
//        x = rightAngle;
////        self.mtClockView.transform = CGAffineTransformMakeRotation(-M_PI/6);
//    }
////    else if (rightAngle < 0){
////        rightAngle = 0;
////        x = 0;
////        preAngle = -M_PI/6;
////        self.mtClockView.transform = CGAffineTransformMakeRotation(-M_PI/6);
////    }
//    else{
////        self.mtClockView.transform = CGAffineTransformMakeRotation(sumAngle);
//    }
//    self.mtClockView.transform = CGAffineTransformMakeRotation(sumAngle);
//
//    NSLog(@"angle: %@",@(rightAngle).stringValue);
////    x = x%105;
////    float y = x*1.0/10;
////    NSLog(@"x=%.2f",x*1.0/10);
//    if (recognizer.state == UIGestureRecognizerStateEnded) {
//        preAngle = angleInRadians;
//    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(adjustISOWithFloat:)]) {
//        [self.delegate adjustISOWithFloat:x];
//    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    if (point.x < 0) {
//        return [super hitTest:point withEvent:event];
//    }
    if (circleView.hidden || point.x < Width - Height/2.0 - 50) {
        return self;
    }
//    NSLog(@"X = %.2f\nY= %.2f",point.x,point.y);
    if ((Width-point.x)*(Width-point.x) + (Height/2 - point.y)*(Height/2 - point.y) > Height*Height/4) {
        return self.sliderView;
    }
    return panView;
}


@end

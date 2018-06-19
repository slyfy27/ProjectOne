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
        circleView = [[UIView alloc] initWithFrame:(CGRect){Width - Height/2.0 - 50,-50,Height + 100, Height + 100}];
        [self addSubview:circleView];
        circleView.hidden = YES;
        self.sliderView = [[FocusSlider alloc] initWithFrame:circleView.bounds];
        self.sliderView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        self.mtClockView = [[MTClockView alloc] initWithFrame:(CGRect){50,50,Height,Height}];
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
    
    //    NSLog(@"translationX:%f\ntranslationY:%f",translation.x,translation.y);
    CGFloat angleInRadians = atan2f(translation.y - view.frame.size.height/2, translation.x - view.frame.size.width/2);
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        angle = angleInRadians;
    }
    sub = angleInRadians - angle;
    CGFloat sumAngle = sub + preAngle;
    self.mtClockView.transform = CGAffineTransformMakeRotation(sumAngle);
    rightAngle = (sumAngle) * 180 / M_PI;
    int x = rightAngle / 3.6;
    x = x%100;
    float y = x*1.0/10;
    NSLog(@"x=%.2f",x*1.0/10);
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        preAngle += sub;
        if (self.delegate && [self.delegate respondsToSelector:@selector(adjustISOWithFloat:)]) {
            [self.delegate adjustISOWithFloat:y/100];
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    if (point.x < 0) {
//        return [super hitTest:point withEvent:event];
//    }
    if (circleView.hidden || point.x < Width - Height/2.0 - 50) {
        return self;
    }
    NSLog(@"X = %.2f\nY= %.2f",point.x,point.y);
    if ((Width-point.x)*(Width-point.x) + (Height/2 - point.y)*(Height/2 - point.y) > Height*Height/4) {
        return self.sliderView;
    }
    return panView;
}


@end

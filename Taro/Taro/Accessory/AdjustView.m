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

@implementation AdjustView
{
    UIView *panView;
    CGFloat angle;
    CGFloat preAngle;
    CGFloat sub;
    UIImageView *arrowView;
    CGFloat rightAngle;
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
        self.sliderView = [[FocusSlider alloc] initWithFrame:self.bounds];
        self.sliderView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        self.mtClockView = [[MTClockView alloc] initWithFrame:(CGRect){50,50,frame.size.width-100,frame.size.height-100}];
        [self addSubview:self.sliderView];
        [self addSubview:self.mtClockView];
        panView = [[UIView alloc] initWithFrame:self.mtClockView.frame];
        [self addSubview:panView];
        arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(44, self.center.y-8 + 50, 16, 16)];
        arrowView.image = [UIImage imageNamed:@"箭头 三角形"];
        [self addSubview:arrowView];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleClockPan:)];
        [panGesture setMaximumNumberOfTouches:1];
//        panGesture.delegate = self;
        
        [panView addGestureRecognizer:panGesture];
    }
    return self;
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

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    if (point.x < 0) {
//        return [super hitTest:point withEvent:event];
//    }
    NSLog(@"X = %.2f\nY= %.2f",point.x,point.y);
    if ((self.mtClockView.frame.size.height/2 - point.x
         + 50)*(self.mtClockView.frame.size.height/2 - point.x + 50) + (self.mtClockView.frame.size.height/2 - point.y)*(self.mtClockView.frame.size.height/2 - point.y) > self.mtClockView.frame.size.height*self.mtClockView.frame.size.height/4) {
        return self.sliderView;
    }
    return panView;
}


@end

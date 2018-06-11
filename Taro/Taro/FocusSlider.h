//
//  FocusSlider.h
//  BEMAnalogClock
//
//  Created by wushuying on 2018/6/11.
//  Copyright © 2018年 Boris Emorine. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ToRad(deg)         ( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)        ( (180.0 * (rad)) / M_PI )
#define SQR(x)            ( (x) * (x) )

#define FreamWidth  200
#define FreamHeight  80

@interface FocusSlider : UIControl

@property (nonatomic) float minimumValue;
@property (nonatomic) float maximumValue;
@property (nonatomic) float currentValue;
@property(nonatomic) NSInteger money;
@property(nonatomic) NSInteger number;
@property(nonatomic) int value;
@property (nonatomic) int lineWidth;
@property (nonatomic, strong) UIColor* filledColor;
@property (nonatomic, strong) UIColor* unfilledColor;
//@property(nonatomic)int angle;
@property (nonatomic, strong) UIColor* handleColor;
//@property (nonatomic) HandleType handleType;

@property (nonatomic, strong) UIFont* labelFont;
@property (nonatomic, strong) UIColor* labelColor;
@property (nonatomic) BOOL snapToLabels;

@end

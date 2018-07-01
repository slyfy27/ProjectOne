//
//  AdjustView.h
//  Taro
//
//  Created by wushuying on 2018/6/19.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTClockView.h"
#import "FocusSlider.h"

@protocol AdjustViewDelegate <NSObject>

@optional
- (void)adjustISOWithFloat:(int)value;

- (void)autoAdjust;

@end

@interface AdjustView : UIView

@property (nonatomic, strong) MTClockView *mtClockView;
@property (nonatomic, strong) FocusSlider *sliderView;

@property (nonatomic, weak) id<AdjustViewDelegate> delegate;

@property (nonatomic, assign) BOOL autoAjust;

- (void)setSliderViewValue:(int)value;

- (void)setClockViewValue:(CGFloat)second;

@end

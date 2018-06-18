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

//@protocal AdjustViewDelegate
//
//@end

@interface AdjustView : UIView

@property (nonatomic, strong) MTClockView *mtClockView;
@property (nonatomic, strong) FocusSlider *sliderView;

@end

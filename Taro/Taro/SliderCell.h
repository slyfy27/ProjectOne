//
//  SliderCell.h
//  Taro
//
//  Created by wushuying on 2018/3/28.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SliderCellDelegate<NSObject>

- (void)sliderValueChange:(CGFloat)value;

@end

@interface SliderCell : UITableViewCell

@property (weak, nonatomic) id<SliderCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISlider *sliderView;

@property (weak, nonatomic) IBOutlet UILabel *minLabel;

@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

//
//  SliderCell.m
//  Taro
//
//  Created by wushuying on 2018/3/28.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "SliderCell.h"

@implementation SliderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _slider.continuous = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)sliderValueChange:(UISlider *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderValueChange:)]) {
        [self.delegate sliderValueChange:sender.value];
    }
}

@end

//
//  SliderCell.h
//  Taro
//
//  Created by wushuying on 2018/3/28.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *minLabel;

@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

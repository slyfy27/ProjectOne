//
//  CameraCell.m
//  Taro
//
//  Created by wushuying on 2018/3/27.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "CameraCell.h"
#import "GolbalDefine.h"

@implementation CameraCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setCurrent:(BOOL)selected{
    if (selected) {
        _typeLabel.textColor = AlertBlueColor;
        _valueLabel.textColor = AlertBlueColor;
    }
    else{
        _typeLabel.textColor = [UIColor whiteColor];
        _valueLabel.textColor = [UIColor whiteColor];
    }
}

@end

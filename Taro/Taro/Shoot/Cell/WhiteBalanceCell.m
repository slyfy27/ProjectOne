//
//  WhiteBalanceCell.m
//  Taro
//
//  Created by wushuying on 2018/3/28.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "WhiteBalanceCell.h"
#import "GolbalDefine.h"

@implementation WhiteBalanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCurrent:(BOOL)selected{
    if (selected) {
        _typeLabel.textColor = AlertBlueColor;
//        _valueLabel.textColor = AlertBlueColor;
    }
    else{
        _typeLabel.textColor = [UIColor whiteColor];
//        _valueLabel.textColor = [UIColor whiteColor];
    }
}

@end

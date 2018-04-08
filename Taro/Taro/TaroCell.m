//
//  TaroCell.m
//  Taro
//
//  Created by wushuying on 2018/3/27.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "TaroCell.h"
#import "GolbalDefine.h"

@implementation TaroCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    return [super initWithStyle:style reuseIdentifier:reuseIdentifier];
}

- (void)setConnect:(BOOL)connect{
    if (connect) {
        _selectedIconImageView.image = [UIImage imageNamed:@"蓝牙选中"];
        _bluetoothLabel.textColor = AlertBlueColor;
    }
    else{
        _selectedIconImageView.image = [UIImage imageNamed:@"蓝牙圈"];
        _bluetoothLabel.textColor = [UIColor whiteColor];
    }
}

@end

//
//  TaroCell.h
//  Taro
//
//  Created by wushuying on 2018/3/27.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaroCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bluetoothLabel;

@property (weak, nonatomic) IBOutlet UIImageView *selectedIconImageView;

@property (assign, nonatomic) BOOL isAlert;

- (void)setConnect:(BOOL)connect;

@end

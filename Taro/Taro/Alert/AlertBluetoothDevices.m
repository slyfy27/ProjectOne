//
//  AlertBluetoothDevices.m
//  Taro
//
//  Created by wushuying on 2018/4/6.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "AlertBluetoothDevices.h"
#import "BluetoothManager.h"
#import "TaroCell.h"
#import "UIView+Category.h"
#import "GolbalDefine.h"
#import "SlyShowProgress.h"

@implementation AlertBluetoothDevices

- (IBAction)closeAction:(id)sender {
    [self dismiss];
}

- (void)show{
    if (isAnimation) {
        return;
    }
    isAnimation = YES;
    
    self.contentView.frame_y = self.bounds.size.height;
    self.alpha = 0.0;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.75 initialSpringVelocity:0.8 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.contentView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    } completion:^(BOOL finished) {
        isAnimation = NO;
    }];
}

- (void)dismiss
{
    if (isAnimation) {
        return;
    }
    isAnimation = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.75 initialSpringVelocity:0.8 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.contentView.frame_y = self.bounds.size.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        isAnimation = NO;
    }];
}

+ (void)alert{
    AlertBluetoothDevices *alert = [[NSBundle mainBundle] loadNibNamed:@"AlertBluetoothDevices" owner:nil options:nil].firstObject;
    alert.frame_width = Width;
    alert.frame_height = Height;
    alert->_contentView.layer.cornerRadius = 8;
    alert->_contentView.layer.masksToBounds = YES;
    alert->_bluetoothTable.delegate = alert;
    alert->_bluetoothTable.dataSource = alert;
    alert->_bluetoothTable.tableFooterView = [UIView new];
    alert->_bluetoothTable.rowHeight = 60;
    [alert->_bluetoothTable registerNib:[UINib nibWithNibName:@"TaroCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    [alert show];
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [BluetoothManager shareInstance].bluetoothArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    CBPeripheral *per = [BluetoothManager shareInstance].bluetoothArray[indexPath.row];
    NSString *name = per.name;
    if ([name containsString:@"Smooth-"]) {
        name = [name stringByReplacingOccurrencesOfString:@"Smooth-" withString:@"Taro-"];
    }
    if ([name containsString:@"Smooth"]) {
        name = [name stringByReplacingOccurrencesOfString:@"Smooth" withString:@"Taro-"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bluetoothLabel.text = name;
    cell.bluetoothLabel.textColor = [UIColor blackColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[SlyShowProgress shareInstance] show];
    CBPeripheral *per = [BluetoothManager shareInstance].bluetoothArray[indexPath.row];
    [[BluetoothManager shareInstance] connect:per result:^(ConnectResultType result) {
        [[SlyShowProgress shareInstance] dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deviceConnected" object:nil];
        [self dismiss];
    }];
}

@end

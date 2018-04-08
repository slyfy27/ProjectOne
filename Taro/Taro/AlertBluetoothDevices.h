//
//  AlertBluetoothDevices.h
//  Taro
//
//  Created by wushuying on 2018/4/6.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertBluetoothDevices : UIView<UITableViewDelegate,UITableViewDataSource>{
    BOOL isAnimation;
}

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UITableView *bluetoothTable;

+ (void)alert;

@end

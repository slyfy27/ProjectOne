//
//  BluetoothManager.m
//  Taro
//
//  Created by wushuying on 2018/4/3.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "BluetoothManager.h"

@implementation BluetoothManager

+ (instancetype)shareInstance{
    static BluetoothManager *_shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[BluetoothManager alloc] init];
        _shareManager.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:_shareManager
                                                                 queue:nil];
        _shareManager.bluetoothArray = @[].mutableCopy;
    });
    return _shareManager;
}

- (void)scan{
    [_bluetoothManager scanForPeripheralsWithServices:nil options:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_bluetoothManager stopScan];
    });
}

- (void)connect{
    if (_bluetoothArray.count) {
        if (_bluetoothArray.count == 1) {
            [_bluetoothManager connectPeripheral:_bluetoothArray.firstObject options:nil];
        }
    }
    //没有蓝牙设备
}

- (CBManagerState)state{
    return _bluetoothManager.state;
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if ([peripheral.name hasPrefix:@"Smooth"]) {
        [_bluetoothArray addObject:peripheral];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
}

@end

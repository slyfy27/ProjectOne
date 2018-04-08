//
//  BluetoothManager.m
//  Taro
//
//  Created by wushuying on 2018/4/3.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "BluetoothManager.h"
#import "AlertBluetoothDevices.h"
#import "SlyShowProgress.h"

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

- (void)scanWithResult:(ConnectResult)result{
    [_bluetoothManager scanForPeripheralsWithServices:nil options:nil];
    _result = result;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_bluetoothManager stopScan];
        [self connect];
    });
}

- (void)connect{
    if (_bluetoothArray.count) {
        if (_bluetoothArray.count == 1) {
            [_bluetoothManager connectPeripheral:_bluetoothArray.firstObject options:nil];
        }
        else{
            BOOL hasConnectedDevice = NO;
            for (CBPeripheral *per in _bluetoothArray) {
                if ([per.identifier.UUIDString isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"bluetooth"]]) {
                    hasConnectedDevice = YES;
                    [_bluetoothManager connectPeripheral:per options:nil];
                }
            }
            if (!hasConnectedDevice) {
                //显示弹框
                [AlertBluetoothDevices alert];
                [[SlyShowProgress shareInstance] dismiss];
            }
        }
    }
    else{
        //没有蓝牙设备 显示没有找到蓝牙设备提醒
        self.result(ConnectResultTypeNoneDevice);
    }
}

- (void)connect:(CBPeripheral *)peripheral result:(ConnectResult)result{
    _result = result;
    [_bluetoothManager connectPeripheral:peripheral options:nil];
}

- (CBManagerState)state{
    return _bluetoothManager.state;
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    if ([peripheral.name hasPrefix:@"Smooth"]) {
        BOOL exist = NO;
        for (CBPeripheral *peri in _bluetoothArray) {
            if ([peri.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
                exist = YES;
            }
        }
        if (!exist) {
            [_bluetoothArray addObject:peripheral];
        }
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    [[NSUserDefaults standardUserDefaults] setValue:peripheral.identifier.UUIDString forKey:@"bluetooth"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.result(ConnectResultTypeSuccess);
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    self.result(ConnectResultTypeFailure);
}

@end

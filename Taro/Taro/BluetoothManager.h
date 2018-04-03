//
//  BluetoothManager.h
//  Taro
//
//  Created by wushuying on 2018/4/3.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BluetoothManager : NSObject<CBCentralManagerDelegate>

@property (strong, nonatomic) CBCentralManager *bluetoothManager;

@property (assign, nonatomic, readonly) CBManagerState state;

@property (strong, nonatomic) NSMutableArray<CBPeripheral *> *bluetoothArray;

+ (instancetype)shareInstance;

@end

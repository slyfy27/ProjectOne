//
//  BluetoothManager.h
//  Taro
//
//  Created by wushuying on 2018/4/3.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM(NSInteger, ConnectResultType){
    ConnectResultTypeSuccess,
    ConnectResultTypeFailure,
    ConnectResultTypeNoneDevice,
};

typedef void(^ConnectResult)(ConnectResultType result);

@interface BluetoothManager : NSObject<CBCentralManagerDelegate>

@property (strong, nonatomic) CBCentralManager *bluetoothManager;

@property (assign, nonatomic, readonly) CBManagerState state;

@property (copy, nonatomic) ConnectResult result;

@property (strong, nonatomic) NSMutableArray<CBPeripheral *> *bluetoothArray;

+ (instancetype)shareInstance;

- (void)scanWithResult:(ConnectResult)result;

- (void)connect:(CBPeripheral *)peripheral result:(ConnectResult)result;

@end

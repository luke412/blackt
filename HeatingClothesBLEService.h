//
//  HeatingClothesBLEService.h
//  AIKAHeatingClothes
//
//  Created by 王帅王帅 on 7/12/16.
//  Copyright © 2016 AIKALife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGBluetooth.h"
extern NSString * const HeatingClothesBLEConected;
extern NSString * const HeatingClothesBLEDisconnect;


@interface HeatingClothesBLEService : DOSingleton
@property(nonatomic, retain)NSMutableDictionary *peripheralsDictionary;
@property(nonatomic, retain)NSMutableDictionary *sendDataCharacteristicDictionary;
@property(nonatomic, retain)NSMutableDictionary *reciveDataCharacteristicDictionary;
/*
 *  设置服务
 */
- (void)setupService;
/*
 *  开始扫描
 */
- (void)startScanBLEDevice;
/*
 *  查询是都连接
 */
- (BOOL)queryIsBLEConnected:(NSString *)macAddress;
/*
 *  获取当前设备温度
 */
- (float)getDeviceCurrentTemperature:(NSString *)macAddress andsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara;
/*
 *  获取信号强度
 */
- (NSInteger)getRSSI:(NSString *)macAddress;
/*
 *  验证mac地址
 */
- (NSString *)getBLEMacAddressAndDoVerify:(LGCharacteristic *)sendChara reciveCharacteristic:(LGCharacteristic *)reciveChara peripheral:(LGPeripheral *)peripheral;
/*
 *  获取剩余电量
 */
- (int)getPowerLeft:(NSString *)macAddress andandsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara;
/*
 *  获取开机时间
 */
- (int)getPowerOnTimeSpan:(NSString *)macAddress andandsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara;
/*
 *  获取倒计时时间
 */
- (int)getHeatingCountDownTime:(NSString *)macAddress andandsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara;
/*
 *  获取加热状态
 */
- (int)getHeatStatus:(NSString *)macAddress  andandsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara;
/*
 *  获取倒计时时间
 */
- (float)getTimeLeft:(NSString *)macAddress andandsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara;
/*
 *  获取最大设置温度
 */
- (float)getMaxSetedTemp:(NSString *)macAddress andandsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara;
/*
 *  写入倒计时时间
 */
- (void)writeHeatTimeCount:(NSString *)macAddress value:(uint)valueToWrite andandsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara;
/*
 *  写入最高温度
 */
- (void)writeSettedTemperature:(NSString *)macAddress value:(uint)valueToWrite andandsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara;
@end

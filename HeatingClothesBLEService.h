//
//  HeatingClothesBLEService.h
//  AIKAHeatingClothes
//
//  Created by 王帅王帅 on 7/12/16.
//  Copyright © 2016 AIKALife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGBluetooth.h"

@protocol  ChangeStateDelegate <NSObject>
@required
-(void)changeState:(NSString *)text;
@end






extern NSString * const HeatingClothesBLEConected;
extern NSString * const HeatingClothesBLEDisconnect;


@interface HeatingClothesBLEService : DOSingleton

@property (nonatomic,strong)dispatch_queue_t myQueue;


@property(nonatomic,strong)NSTimer *timer;
@property (nonatomic, weak) id <ChangeStateDelegate>delegate;
@property(nonatomic,strong) Base_ViewController *myViewController;//存放需要跳转的界面
@property(nonatomic,assign)BOOL isBound;     //是否是绑定操作
@property(nonatomic, retain)NSMutableDictionary *peripheralsDictionary;
@property(nonatomic, retain)NSMutableDictionary *sendDataCharacteristicDictionary;
@property(nonatomic, retain)NSMutableDictionary *reciveDataCharacteristicDictionary;
@property(nonatomic,assign)int SearchNumber;//搜索次数
-(int)getDaoJiShi_Mac:(NSString *)macAddress;


- (LGCharacteristic *)getReciveDataCharacteristic:(NSString *)macAddress;
- (LGCharacteristic *)getSendDataCharacteristic:(NSString *)macAddress;
- (LGPeripheral *)getCachedPeripheral:(NSString *)macAddress;
-(float)getDangQianWenDu_Mac:(NSString *)macAddress;
/*
 * 获取一个缓存设备
 */
-(LGPeripheral *)getCachedPeripheral:(NSString *)mac;
/*
 *  读取一个展板的信息
 */
-(WarmShowInfoModel *)ReadInfoFromBluetoothWith:(NSString *)macAddress;
/*
 *  设置服务
 */
- (void)setupService;
/*
 *  清除某个设备
 */
- (void)cleanDevice:(NSString *)macAddress;
/*
 *  开始心跳
 */
-(void)startTheHeart;
/*
 * 停止心跳
 */
-(void)stopTheHeart;
/*
 *  开始扫描
 */
- (void)StartScanningDeviceWithMac:(NSString *)mac;
/*
 *  初始化记录字典（初始化缓存）
 */
- (void)initCacheDictionary;
/*
 *  尝试连接设备
 */
- (void)testPeripheral:(LGPeripheral *)peripheral WithMac:(NSString *)mac;
/*
 *  向指定设备发射心跳命令，防止其断开连接
 */
-(void)KeepTheHeart;
/*
 *  获取已经绑定的设备mac数组
 *  返回值：已经绑定的设备的mac数组
 */
- (NSArray *)getHaveBindingDevice;

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
- (BOOL)writeHeatTimeCount:(NSString *)macAddress value:(uint)valueToWrite andandsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara;
/*
 *  写入最高温度
 */
- (BOOL)writeSettedTemperature:(NSString *)macAddress value:(uint)valueToWrite andandsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara;
@end

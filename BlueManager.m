//
//  BlueManager.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/7.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "BlueManager.h"
#import "BLEUdidManager.h"
#import "HeatingClothesBLEService.h"
@implementation BlueManager
#pragma mark - 断开连接
-(void)disconnectWithMac:(NSString *)mac
                  Sucess:(void(^)(NSString * mac))sucess
                 Failure:(void(^)(NSString *mac))failure{
    LGPeripheral *peripheral =  [[HeatingClothesBLEService sharedInstance]getCachedPeripheral:mac];
    if (peripheral) {
        dispatch_queue_t myQueue = [HeatingClothesBLEService sharedInstance].myQueue;
        dispatch_async(myQueue, ^{
            [peripheral disconnectWithCompletion:^(NSError *error) {
                NSLog(@"解绑断开连接，错误:%@",error);
                if (error == nil) {
                    if (sucess) {
                        sucess(mac);
                    }
                    [[HeatingClothesBLEService sharedInstance]cleanDevice:mac];
                }else{
                    if (failure) {
                        failure(mac);
                    }
                }
            }];
        });
    }
}

#pragma mark - 重连蓝牙
-(void)reconnectionWithMac:(NSString *)mac
                    Sucess:(void(^)(NSString * mac))sucess
                   Failure:(void(^)(NSString *mac))failur
          andIsRunDelegate:(BOOL)isRunDelegate{
    BLEUdidManager *bleManager = [[BLEUdidManager alloc]init];
    NSUUID  *uuid = [bleManager getUUIDFromDataBase_mac:mac];
    if (!uuid) {
        if (failur) {
            failur(mac);
        }
    }
    if (!uuid) {
        return;
    }
    NSArray *uuidArr = @[uuid];
    NSArray *PeripheralArr = [[LGCentralManager sharedInstance] retrievePeripheralsWithIdentifiers:uuidArr];
    LGPeripheral *Peripheral = PeripheralArr.lastObject;
    [[HeatingClothesBLEService sharedInstance] testPeripheral:Peripheral WithMac:mac Success:^(NSString *mac) {
        if (sucess) {
            sucess(mac);
        }
    } Failure:^(NSString *mac) {
        if (failur) {
            failur(mac);
        }
        
    } andIsRunDelegate:isRunDelegate];
}

/**蓝牙智能连接  有udid走协议栈重连,没有的话扫描连接*/
-(void)smartctionWithMac:(NSString *)mac
                  Sucess:(void(^)(NSString * mac))sucess
                 Failure:(void(^)(NSString *mac))failure
        andIsRunDelegate:(BOOL)isRunDelegate{
    //判断蓝牙开关是否打开
    if([[[LGCentralManager sharedInstance] stateMessage] isEqualToString:@"蓝牙关闭状态"]){
        [Win_Manager showWin_bluePoweredOff];
        if (failure) {
            failure(mac);
        }
        return;
    }
    
    //如果在线的话
    if ([[HeatingClothesBLEService sharedInstance]queryIsBLEConnected:mac]) {
        if (sucess) {
            sucess(mac);
        }
        return;
    }
    
    if (mac == nil) {
        
        mac = App_Manager.currDevice.clothesMac;
    }
    
    
    BLEUdidManager *bleManager = [[BLEUdidManager alloc]init];
    NSUUID  *uuid              = [bleManager getUUIDFromDataBase_mac:mac];
    LKLog(@"%@",uuid);
    if (!uuid) {
        [[HeatingClothesBLEService sharedInstance] StartScanningDeviceWithMac:mac Success:^(NSString *mac) {
            if (sucess) {
                sucess(mac);
            }
        } Failure:^(NSString *mac) {
            if (failure) {
                failure(mac);
            }
        } andIsRunDelegate:isRunDelegate];
    }else{
        NSArray *uuidArr         = @[uuid];
        NSArray *PeripheralArr   = [[LGCentralManager sharedInstance] retrievePeripheralsWithIdentifiers:uuidArr];
        LGPeripheral *Peripheral = PeripheralArr.lastObject;
        LKLog(@"重连设备是老岳：%@",Peripheral.name);
        [[HeatingClothesBLEService sharedInstance] testPeripheral:Peripheral WithMac:mac Success:^(NSString *mac) {
            if (sucess) {
                sucess(mac);
            }
        } Failure:^(NSString *mac) {
            if (failure) {
                failure(mac);
                
            }
        } andIsRunDelegate:isRunDelegate];
    }
}

/**设置目标温度 */
-(BOOL)setWenDuWithMac:(NSString *)mac
              andWenDu:(int)wenDu{
    LGCharacteristic *read = [[HeatingClothesBLEService sharedInstance].reciveDataCharacteristicDictionary objectForKey:mac];
    LGCharacteristic *send = [[HeatingClothesBLEService sharedInstance].sendDataCharacteristicDictionary   objectForKey:mac];
    BOOL   isOK = [[HeatingClothesBLEService sharedInstance]writeSettedTemperature:mac value:wenDu andandsendChara:send andreciveChara:read];
    return isOK;
}

/**读取目标温度*/
-(NSInteger)readCurrMuBiao_Mac:(NSString *)mac{
    LGCharacteristic *read = [[HeatingClothesBLEService sharedInstance].reciveDataCharacteristicDictionary objectForKey:mac];
    LGCharacteristic *send = [[HeatingClothesBLEService sharedInstance].sendDataCharacteristicDictionary   objectForKey:mac];
    float wenDu  = [[HeatingClothesBLEService sharedInstance] getMaxSetedTemp:mac andandsendChara:send andreciveChara:read];
    NSInteger wenDuInt = (NSInteger)wenDu;
    return wenDuInt;
}

/**读取当前温度*/
-(NSInteger)readCurrTemp_Mac:(NSString *)mac{
    LGCharacteristic *read = [[HeatingClothesBLEService sharedInstance].reciveDataCharacteristicDictionary objectForKey:mac];
    LGCharacteristic *send = [[HeatingClothesBLEService sharedInstance].sendDataCharacteristicDictionary   objectForKey:mac];
    
    float wenDu  = [[HeatingClothesBLEService sharedInstance] getDeviceCurrentTemperature:mac andsendChara:send andreciveChara:read];
    NSInteger wenDuInt = (NSInteger)wenDu;
    return wenDuInt;
}


/**设置加热时间  （分钟） */
-(BOOL)setShiJianWithMac:(NSString *)mac
              andShiJian:(int)ShiJianMin{
    LGCharacteristic *send = [[HeatingClothesBLEService sharedInstance]getSendDataCharacteristic :mac];
    LGCharacteristic *read = [[HeatingClothesBLEService sharedInstance]getReciveDataCharacteristic:mac];
    
    int miaoShu = ShiJianMin * 60;
    if (ShiJianMin == MAX_UPSCALE) {
        miaoShu = MAX_UPSCALE;
    }
    BOOL isOk= [[HeatingClothesBLEService sharedInstance]writeHeatTimeCount:mac value:miaoShu andandsendChara:send andreciveChara:read];
    return isOk;
}








/**二码合一*/
-(NSString *)getMacFromQRcode:(NSString *)qrStr{
    
    NSArray *strArr=[qrStr componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"?&"]];
    NSString *mac;
    if (strArr.count<=1) {
        if ([qrStr hasPrefix:@"http://www."]) {
            NSLog(@"这是旧码，是链接:%@",qrStr);
        }else if(qrStr.length==12){
            NSLog(@"这是旧码，是mac:%@",qrStr);
            mac=qrStr;
        }
    }else if(strArr.count>1){
        NSLog(@"这是新码，它所包含的信息为：");
        for (int i=0;i<strArr.count; i++) {
            NSString *indexStr=strArr[i];
            if ([indexStr hasPrefix:@"mac="]){
                NSArray *arr=[indexStr componentsSeparatedByString:@"mac="];
                NSString *strlastObject=[arr lastObject];
                NSLog(@"mac:%@",strlastObject);
                mac=strlastObject;
            }
            if ([indexStr hasPrefix:@"tag="]){
                NSArray *arr=[indexStr componentsSeparatedByString:@"tag="];
                NSString *strlastObject=[arr lastObject];
                NSLog(@"tag:%@",strlastObject);
            }
            if ([indexStr hasPrefix:@"http"]){
                NSLog(@"链接:%@",indexStr);
            }
            
        }
        
    }else{
        NSLog(@"扫码出错");
    }
    
    return mac;
}

@end

//
//  HeatingClothesBLEService.m
//  AIKAHeatingClothes
//
//  Created by 王帅王帅 on 7/12/16.
//  Copyright © 2016 AIKALife. All rights reserved.
//

#import "HeatingClothesBLEService.h"
#import "LGBluetooth.h"


NSString * const HeatingClothesBLEConected = @"HeatingClothesBLEConected";
NSString * const HeatingClothesBLEDisconnect = @"HeatingClothesBLEDisconnect";


@interface HeatingClothesBLEService ()



@end


@implementation HeatingClothesBLEService

- (id)init
{
    if (!self.isInitialized) {
        self = [super init];
        if (self) {
        }
    }
    return self;
}


- (void)setupService {
    [LGCentralManager sharedInstance];
    [self initCacheDictionary];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBLEDisconnected:) name:kLGPeripheralDidDisconnect object:nil];
}


- (void)handleBLEDisconnected:(NSNotification *)n {
    LGPeripheral *nperipheral = n.object;
    
    NSString *macString = [self findMacAddressOfPeripheral:nperipheral];
    if (macString != nil) {
        [self cleanDevice:macString];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HeatingClothesBLEDisconnect object:macString];
}


#pragma mark - public methods

#pragma mark  开始扫描
- (void)startScanBLEDevice{ 
    
    // 扫描外围设备2秒
    [[LGCentralManager sharedInstance] scanForPeripheralsByInterval:4
                                                         completion:^(NSArray *peripherals)
     {
         NSLog(@"%d",peripherals.count);
         for (LGPeripheral *peripheral in peripherals) {
             [self handlePeripheral:peripheral];
         }
     }];
}

#pragma mark 查询是否连接
- (BOOL)queryIsBLEConnected:(NSString *)macAddress {
    
    return [self isDeviceCached:macAddress];
}

#pragma mark 获取信号强度
- (NSInteger)getRSSI:(NSString *)macAddress {
    LGPeripheral *peripheral = [self getCachedPeripheral:macAddress];
    
    __block NSInteger rssi = 0;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [peripheral readRSSIValueCompletion:^(NSNumber *RSSI, NSError *error) {
        rssi = RSSI.integerValue;
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15.0 * NSEC_PER_SEC));
    dispatch_semaphore_wait(semaphore, timeout);
    return rssi;
}

#pragma mark 获取当前的温度
- (float)getDeviceCurrentTemperature:(NSString *)macAddress andsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara{
    Byte value[] = {0xaa, 0x0a, 0x00, 0x02};
    LGCharacteristic *this_sendChara = sendChara;
    LGCharacteristic *this_reciveChara = reciveChara;
    if (!this_sendChara || !this_reciveChara) {
        return 0;
    }
    
    NSData *temperatureData= [self doJob:this_sendChara writeValue:value writelength:4 reciveCharacteristic:this_reciveChara];
    if (!temperatureData) {
        return 0;
    }
    Byte *tempByteLittle = (Byte *)[temperatureData bytes];
    Byte tempByte[] = {tempByteLittle[2], tempByteLittle[1]};
    short s = (short) (((tempByte[0] & 0xff) << 8) | (tempByte[1] & 0xff));
    float f = s;
    float temperature = f / 10.0f;
    NSLog(@"呵呵%f", temperature);
    return temperature;
}

#pragma mark 获取最大设置温度
- (float)getMaxSetedTemp:(NSString *)macAddress andandsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara{
    Byte value[] = {0xaa, 0x1e, 0x00, 0x02};
    NSData *temperatureData = [self doJob:sendChara writeValue:value writelength:4 reciveCharacteristic:reciveChara];
    if (!temperatureData) {
        return 0;
    }
    Byte *tempByteLittle = (Byte *)[temperatureData bytes];
    Byte tempByte[] = {tempByteLittle[2], tempByteLittle[1]};
    short s = (short) (((tempByte[0] & 0xff) << 8) | (tempByte[1] & 0xff));
    float f = s;
    float temperature = f / 10.0f;
    NSLog(@"%f", temperature);
    return temperature;
}

#pragma mark 获取剩余电量
- (int)getPowerLeft:(NSString *)macAddress andandsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara{
    
    Byte value[] = {0xaa, 0x06, 0x00, 0x01};
    NSData *powerLeft = [self doJob:sendChara writeValue:value writelength:4 reciveCharacteristic:reciveChara];
    if (!powerLeft){
        return 0;
    }
    Byte *powerLeftLittle = (Byte *)[powerLeft bytes];
    
    if (powerLeft.length != 2) {
        return -1;
    }
    Byte b = powerLeftLittle[1];
    
    
    NSLog(@"power : %d", b);
    
//    Byte b = powerLeftLittle[1];
    
    return b;
}

#pragma mark 获取开机时间
- (int)getPowerOnTimeSpan:(NSString *)macAddress andandsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara{
    
    Byte value[] = {0xaa, 0x18, 0x00, 0x14};
    NSData *powerOnTimeSpan = [self doJob:sendChara writeValue:value writelength:4 reciveCharacteristic:reciveChara];

    if (!powerOnTimeSpan) {
        return 0;
    }
    Byte *powerOnTimeLittle = (Byte *)[powerOnTimeSpan bytes];
    
    
    Byte tempByte[] = {powerOnTimeLittle[4], powerOnTimeLittle[3], powerOnTimeLittle[2], powerOnTimeLittle[1]};
    
    NSData *tempData = [NSData dataWithBytes:tempByte length:4];
    NSString *hexString = [self dataToHexString:tempData];
    
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&result];
    return result;
    
}

#pragma mark 获取倒计时时间
- (int)getHeatingCountDownTime:(NSString *)macAddress andandsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara{
    
    Byte value[] = {0xaa, 0x20, 0x00, 0x12};
    
    NSData *countDownTime = [self doJob:sendChara writeValue:value writelength:4 reciveCharacteristic:reciveChara];
    if (!countDownTime) {
        return 0;
    }
    Byte *countDownTimeLittle = (Byte *)[countDownTime bytes];
    
    Byte tempByte[] = {countDownTimeLittle[2], countDownTimeLittle[1]};
    
    NSData *tempData = [NSData dataWithBytes:tempByte length:2];
    
    NSString *hexString = [self dataToHexString:tempData];
    
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&result];
    return result;
}

#pragma mark 获取加热状态
- (int)getHeatStatus:(NSString *)macAddress  andandsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara{
    int countDownTime = [self getHeatingCountDownTime:macAddress andandsendChara:sendChara andreciveChara:reciveChara];
    NSLog(@"读取到的countDownTime: %d", countDownTime);
    
    if (countDownTime <= 0 || countDownTime == 65535) {
        return 0;
    }
    return 1;
}


- (float)getTimeLeft:(NSString *)macAddress andandsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara{
    return [self getHeatingCountDownTime:macAddress andandsendChara:sendChara andreciveChara:reciveChara];
}

#pragma mark 写入倒计时时间
- (void)writeHeatTimeCount:(NSString *)macAddress value:(uint)valueToWrite andandsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara{
    uint highValue = valueToWrite >> 8;
    uint lowValue  = valueToWrite & 0x00ff;
    //数据小端
    Byte value[] = {0xab, 0x20, 0x00, 0x12, lowValue, highValue};
    NSData *data =  [self doJob:sendChara writeValue:value writelength:6 reciveCharacteristic:reciveChara];
    if (!data){
        return;
    }
    if([data isEqualToData:[self hexStringToData:@"ab"]]) {
        NSLog(@"写入倒计时时间成功!");
    }
}

#pragma mark 写入最高温度
- (void)writeSettedTemperature:(NSString *)macAddress value:(uint)valueToWrite andandsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara{
    uint tempValueMax = (valueToWrite + 2) * 10;
    uint highTempValueMax = tempValueMax >> 8;
    uint lowTempValueMax = tempValueMax & 0x00ff;
    
    //最高温度
    Byte valueMax[] = {0xab, 0x1e, 0x00, 0x02, lowTempValueMax, highTempValueMax};
    NSData *dataMaxReturn =  [self doJob:sendChara writeValue:valueMax writelength:6 reciveCharacteristic:reciveChara];
    uint tempValueMin = (valueToWrite - 2) * 10;
    uint highTempValueMin = tempValueMin >> 8;
    uint lowTempValueMin = tempValueMin & 0x00ff;
    
    //最高温度
    Byte valueMin[] = {0xab, 0x1c, 0x00, 0x02, lowTempValueMin, highTempValueMin};
    NSData *dataMinReturn =  [self doJob:sendChara writeValue:valueMin writelength:6 reciveCharacteristic:reciveChara];
    BOOL maxSuccesFlag = [dataMaxReturn isEqualToData:[self hexStringToData:@"ab"]];
    BOOL minSuccesFlag = [dataMinReturn isEqualToData:[self hexStringToData:@"ab"]];

    if (maxSuccesFlag && minSuccesFlag) {
        NSLog(@"写入最高最低温度成功！！");
    }
}



#pragma mark - private methods
- (void)handlePeripheral:(LGPeripheral *)peripheral {
    [LGUtils discoverCharactUUID:@"1001"  //write only
                     serviceUUID:@"1000"
                      peripheral:peripheral
                      completion:^(LGCharacteristic *sendChara, NSError *error) {
                          if (!sendChara) {
                              return ;
                          }
                          
                          [LGUtils discoverCharactUUID:@"1002" //read only
                                           serviceUUID:@"1000"
                                            peripheral:peripheral
                                            completion:^(LGCharacteristic *reciveChara, NSError *error) {
                                                if (!reciveChara) {
                                                    return ;
                                                }
                                                [self getBLEMacAddressAndDoVerify:sendChara reciveCharacteristic:reciveChara peripheral:peripheral];
                                            }];
                      }];
}

- (NSData *)doJob:(LGCharacteristic* )sendCharacteristic writeValue:(Byte[])value writelength:(NSUInteger)length reciveCharacteristic:(LGCharacteristic *)reciveCharacteristic {
    if (!sendCharacteristic || !value || !reciveCharacteristic) {
        return nil;
    }
    
    __block NSData *retValue = nil;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [reciveCharacteristic setNotifyValue:YES completion:^(NSError *error) {
        //NSLog(@"setNotifyValue Error : %@", error);
    } onUpdate:^(NSData *data, NSError *error) {
        retValue = data;
        dispatch_semaphore_signal(semaphore);
    }];
    
    [sendCharacteristic writeValue:[NSData dataWithBytes:value length:length] completion:nil];
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15.0 * NSEC_PER_SEC));
    dispatch_semaphore_wait(semaphore, timeout);
    
    return retValue;
}


- (Byte)getMacByte:(Byte *)bs {
    
        return bs[1];
        
}

#pragma mark 获取蓝牙的mac地址做验证
- (NSString *)getBLEMacAddressAndDoVerify:(LGCharacteristic *)sendChara reciveCharacteristic:(LGCharacteristic *)reciveChara peripheral:(LGPeripheral *)peripheral {
    Byte value1[] = {0xaa, 0x00, 0x00, 0x11};
    NSData *data1 = [self doJob:sendChara writeValue:value1 writelength:4 reciveCharacteristic:reciveChara];
    if (!data1) {
        NSLog(@"空数据1，跳出");
        return @"";
    }
    Byte *testByte1 = (Byte *)[data1 bytes];

    Byte b1 = [self getMacByte:testByte1];
    
    Byte value2[] = {0xaa, 0x01, 0x00, 0x11};
    NSData *data2 = [self doJob:sendChara writeValue:value2 writelength:4 reciveCharacteristic:reciveChara];
    if (!data2) {
        NSLog(@"空数据，跳出");
        return @"";
    }

    Byte *testByte2 = (Byte *)[data2 bytes];
    Byte b2 = [self getMacByte:testByte2];
    
    Byte value3[] = {0xaa, 0x02, 0x00, 0x11};
    NSData *data3 = [self doJob:sendChara writeValue:value3 writelength:4 reciveCharacteristic:reciveChara];
    if (!data3) {
        NSLog(@"空数据，跳出");
        return @"";
    }

    Byte *testByte3 = (Byte *)[data3 bytes];
    Byte b3 = [self getMacByte:testByte3];
    
    Byte value4[] = {0xaa, 0x03, 0x00, 0x11};
    NSData *data4 = [self doJob:sendChara writeValue:value4 writelength:4 reciveCharacteristic:reciveChara];
    if (!data4) {
        NSLog(@"空数据，跳出");
        return @"";
    }

    Byte *testByte4 = (Byte *)[data4 bytes];
    Byte b4 = [self getMacByte:testByte4];
    
    Byte value5[] = {0xaa, 0x04, 0x00, 0x11};
    NSData *data5 = [self doJob:sendChara writeValue:value5 writelength:4 reciveCharacteristic:reciveChara];
    if (!data5) {
        NSLog(@"空数据，跳出");
        return @"";
    }

    Byte *testByte5 = (Byte *)[data5 bytes];
    Byte b5 = [self getMacByte:testByte5];
    
    Byte value6[] = {0xaa, 0x05, 0x00, 0x11};
    NSData *data6 = [self doJob:sendChara writeValue:value6 writelength:4 reciveCharacteristic:reciveChara];
    if (!data6) {
        NSLog(@"空数据，跳出");
        return @"";
    }

    Byte *testByte6 = (Byte *)[data6 bytes];
    Byte b6 = [self getMacByte:testByte6];
    
    uint rawSum = b1+b2+b3+b4+b5+b6;
    uint vr = rawSum + 0x2016;
    uint highValue = vr >> 8;
    uint lowValue = vr & 0x00ff;
    
    
    Byte value7[] = {0xab, 0x08, 0x00, 0x12, lowValue, highValue};
    NSData *data7 = [self doJob:sendChara writeValue:value7 writelength:6 reciveCharacteristic:reciveChara];
    NSString *macText;
    if ([data7 isEqualToData:[self hexStringToData:@"ab"]]) {
        Byte macBytes[] = {b1, b2, b3, b4, b5, b6};
        NSString *macString = [self dataToHexString:[NSData dataWithBytes:macBytes length:6]];
        NSLog(@"%@: mac:%@",@"ok passed", macString);
        macText=macString;
//        [self saveDevice:macString peripheral:peripheral sendDataCharacteristic:sendChara reciveDataCharacteristic:reciveChara];
        [[NSNotificationCenter defaultCenter] postNotificationName:HeatingClothesBLEConected object:[self parseNetMACStringToMACString:macString]];
    }else if([data7 isEqualToData:[self hexStringToData:@"ac"]]){
        NSLog(@"验证未通过");
    }
    return macText;
}


#pragma mark - device cache manager
- (void)initCacheDictionary {
    self.peripheralsDictionary = [NSMutableDictionary new];
    self.sendDataCharacteristicDictionary = [NSMutableDictionary new];
    self.reciveDataCharacteristicDictionary = [NSMutableDictionary new];
}

#pragma mark 保存某设备
- (void)saveDevice:(NSString *)macAddress peripheral:(LGPeripheral *)peripheral sendDataCharacteristic:(LGCharacteristic *)sendCharacteristic reciveDataCharacteristic:(LGCharacteristic *)reciveCharacteristic {
    self.peripheralsDictionary[macAddress] = peripheral;
    self.sendDataCharacteristicDictionary[macAddress] = sendCharacteristic;
    self.reciveDataCharacteristicDictionary[macAddress] = reciveCharacteristic;
}

#pragma mark 获取是否已缓存某设备
- (BOOL)isDeviceCached:(NSString *)macAddress {
    LGPeripheral *p = [self getCachedPeripheral:macAddress];
    return p ? YES : NO;
}


#pragma mark 获取缓存设备
- (LGPeripheral *)getCachedPeripheral:(NSString *)macAddress {
    return self.peripheralsDictionary[macAddress];
}

#pragma mark 获取发送数据的特征
- (LGCharacteristic *)getSendDataCharacteristic:(NSString *)macAddress {
    return self.sendDataCharacteristicDictionary[macAddress];
}


#pragma  mark  获取特征
- (LGCharacteristic *)getReciveDataCharacteristic:(NSString *)macAddress {
    return self.reciveDataCharacteristicDictionary[macAddress];
}

#pragma mark 清除设备
- (void)cleanDevice:(NSString *)macAddress {
    [self.peripheralsDictionary removeObjectForKey:macAddress];
    [self.sendDataCharacteristicDictionary removeObjectForKey:macAddress];
    [self.reciveDataCharacteristicDictionary removeObjectForKey:macAddress];
}

#pragma mark 获取设备的mac地址
- (NSString *)findMacAddressOfPeripheral:(LGPeripheral *)thePeripheral {
    NSArray *peripheralsMACs = self.peripheralsDictionary.allKeys;
    NSString *foundMac = nil;
    for (NSString *theMAC in peripheralsMACs) {
        LGPeripheral *peri = self.peripheralsDictionary[theMAC];
        if ([thePeripheral.UUIDString isEqualToString:peri.UUIDString]) {
            foundMac = theMAC;
            break;
        }
    }
    
    return foundMac;
}
#pragma mark - 工具方法
- (NSString *)dataToHexString:(NSData *)dataBytes
{
    NSUInteger          len = [dataBytes length];
    char *              chars = (char *)[dataBytes bytes];
    NSMutableString *   hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ )
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
    
    return hexString;
}
- (NSData *)hexStringToData:(NSString *)str
{
    Byte bytes[str.length/2] ;
    int j = 0 ;
    for (int i = 0 ; i < str.length/2; i++) {
        int int_ch ;// 两位16进制转化后的10进制数
        
        unichar hex_char1  = [str characterAtIndex:2*i];
        int int_ch1 ;
        if (hex_char1 >= '0' && hex_char1 <= '9') {
            int_ch1 = (hex_char1 - 48)*16;// 0 的AscII － 48
            
            
        }else if(hex_char1 >= 'A'&& hex_char1 <='F')
        {
            int_ch1 = (hex_char1 - 65)*16 ;// A的ACSSII＝65
        }else{
            int_ch1 = (hex_char1 - 87)* 16 ;
        }
        unichar hex_char2 = [str characterAtIndex:2*i+1];
        int int_ch2 ;
        if (hex_char2 >= '0' && hex_char2<= '9') {
            int_ch2 = hex_char2 - 48 ;
        }else if(hex_char2 >= 'A'&&hex_char2 <='F'){
            int_ch2 = hex_char2 - 55 ;
        }else{
            int_ch2 = hex_char2 - 87 ;
        }
        int_ch = int_ch1 + int_ch2 ;
        bytes[j] = int_ch ;
        j++ ;
    }
    NSData *data = [NSData dataWithBytes:bytes length:str.length/2];
    return data ;
}
- (NSString *)parseNetMACStringToMACString:(NSString *) netMACString{
    NSArray *array =[netMACString componentsSeparatedByString:@":"];
    
    NSString *macString =[array componentsJoinedByString:@""];
    
    return [macString lowercaseString];
}
@end

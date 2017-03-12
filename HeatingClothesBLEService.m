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
    self.myViewController=[[Connecting_ViewController alloc]init];
    [self initCacheDictionary];
        //添加蓝牙连接断开监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBLEDisconnected:) name:kLGPeripheralDidDisconnect object:nil];
}
//开始心跳
-(void)startTheHeart{
    if (self.timer==nil) {
        //2秒一个心跳包
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(KeepTheHeart) userInfo:nil repeats:YES];
        self.myQueue  = dispatch_queue_create("luke", DISPATCH_QUEUE_SERIAL);
        NSLog(@"心跳机制已开启");
    }
}
-(void)stopTheHeart{
    if (_timer != nil) {
        //销毁定时器
        [_timer invalidate];
        _timer=nil;
        NSLog(@"心跳机制已停止");
    }
}
//心跳  --串行异步
-(void)KeepTheHeart{
    dispatch_async(self.myQueue , ^{
        NSLog(@"够酷的唱歌：%@",[NSThread currentThread]) ;
        
        NSLog(@"心跳..............................................");
        NSArray<LGPeripheral *> *deviceArr=[self.peripheralsDictionary allValues];
        if (deviceArr.count<1) {
            //假数据 发心跳
            
            NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"HeartBeatRefresh_nil" object:nil];
            NSLog(@"假心跳信息");
            
            return;
        }
        for (LGPeripheral *peripheral in deviceArr){
            NSArray *array1 = [peripheral.name componentsSeparatedByString:@"#0x"];
            NSString *deviceMac=array1[1]?array1[1]:@"";
            NSLog(@"心跳 收到mac：%@",deviceMac);
            NSLog(@"%@",[self.sendDataCharacteristicDictionary objectForKey:deviceMac]);
            NSLog(@"%@",[self.reciveDataCharacteristicDictionary objectForKey:deviceMac]);
            //心跳
            LGCharacteristic *sendChara  =[self.sendDataCharacteristicDictionary objectForKey:deviceMac];
            LGCharacteristic *reciveChara=[self.reciveDataCharacteristicDictionary objectForKey:deviceMac];
            if (sendChara==nil||reciveChara==nil) {
                NSLog(@"设备%@ ,心跳异常,特征有空值，停止心跳",deviceMac);
                return;
            }
            //获取剩余时间
            WarmShowInfoModel *model=[[HeatingClothesBLEService sharedInstance] ReadInfoFromBluetoothWith:deviceMac];
            float time = model.remainingTime;
            if (time==-1000){
                NSLog(@"设备%@ ,心跳异常",deviceMac);
                NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
                [nc postNotificationName:kLGPeripheralDidDisconnect object:peripheral];
                
            }
            NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"HeartBeatRefresh" object:model];
            NSLog(@",心跳信息model:%@ ",model);
        }

});
}
//连接断开后的处理
- (void)handleBLEDisconnected:(NSNotification *)n {
    LGPeripheral *nperipheral = n.object;
    NSString *macString = [self findMacAddressOfPeripheral:nperipheral];
    if (macString != nil) {
        [self cleanDevice:macString];//清除已经断开连接设备
    }
    NSLog(@"mac为%@的设备，连接已断开",macString);
    [[NSNotificationCenter defaultCenter] postNotificationName:HeatingClothesBLEDisconnect object:macString];
}
#pragma mark - public methods
#pragma mark  获取已绑定设备（数据库查询）
- (NSArray *)getHaveBindingDevice{
    NSArray *clothesInDataBase=[[LKDataBaseTool sharedInstance]showAllDataFromTable:nil];
    NSMutableArray *clothesMacArr=[[NSMutableArray alloc]init];
    for (ClothesModel *model in clothesInDataBase) {
        [clothesMacArr addObject:model.clothesMac];
    }
    return clothesMacArr;
}
#pragma mark  开始扫描
//开始扫描外围的设备
- (void)StartScanningDeviceWithMac:(NSString *)mac{
    //调用
     if (_delegate && [_delegate respondsToSelector:@selector(changeState:)]) {
             [_delegate changeState:@"正在搜索设备..."];
     }

  HeatingClothesBLEService *myBLEService=[HeatingClothesBLEService sharedInstance];
    // 扫描外围设备6秒 鲁柯
    [[LGCentralManager sharedInstance] scanForPeripheralsByInterval:6
                                                         completion:^(NSArray *peripherals)
     {
         NSLog(@"单例界面--发现设备 %d个，要找的是%@",peripherals.count,mac);
         for (LGPeripheral *p in peripherals) {
             NSLog(@"%@",p.name);
         }
         BOOL isFound=NO;
         for (LGPeripheral *peripheral in peripherals){
             //mac地址是否合法判断
             NSArray *array1 = [peripheral.name componentsSeparatedByString:@"#0x"];
             NSString *peripheralMac=array1[array1.count-1];
             if (mac==nil) {
                 //检验设备是否已绑定
                 NSArray<NSString *> *HaveBindingDevices=[[HeatingClothesBLEService sharedInstance] getHaveBindingDevice];
                 if ([LKTool DoesItIncludeTheElement:peripheralMac InTheArray:HaveBindingDevices]) {
                     isFound=YES;
                     [myBLEService testPeripheral:peripheral WithMac:nil];
                 }
             }
             else {
                 if ([peripheralMac isEqualToString:mac]) {
                     isFound=YES;
                     [myBLEService testPeripheral:peripheral WithMac:mac];
                 }
                 
             }
          }
         if (isFound==NO){
             [MBProgressHUD hideHUD];
             //扫描都失败
             NSString *postMac;
             if (mac == nil) {
                 postMac = @"";
             }else{
                 postMac = mac;
             }
             NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                 NSNotification *notify   = [[NSNotification alloc]initWithName:@"ConnectionFails" object:postMac userInfo:nil];
                 [nc postNotification:notify];
         }
     }];
}

- (void)testPeripheral:(LGPeripheral *)peripheral WithMac:(NSString *)macAddress
{
    //调用
     if (_delegate && [_delegate respondsToSelector:@selector(changeState:)]) {
        [_delegate changeState:@"发现设备，连接中..."];
     }
    
    //mac地址是否合法判断
    NSArray *array1 = [peripheral.name componentsSeparatedByString:@"#0x"];
    if (array1.count!=2) {
        return;
    }
    NSString *peripheralMac=array1[1]?array1[1]:@"";
    if (peripheralMac.length!=12) {
        NSLog(@"mac不合法");
        return;
    }
    
    //首先连接到外围
    [peripheral connectWithCompletion:^(NSError *error) {
        // 发现外设的服务
        [peripheral discoverServicesWithCompletion:^(NSArray *services, NSError *error) {
            for (LGService *service in services) {
                NSLog(@"服务的UUID:%@",service.UUIDString);
                // 找出我们的服务（我们关心的服务）
                if ([service.UUIDString isEqualToString:@"1000"]) {
                    //发现我们服务的特征
                    [service discoverCharacteristicsWithCompletion:^(NSArray *characteristics, NSError *error) {
                        for (LGCharacteristic *charact in characteristics) {
                            NSLog(@"特征名称(charact.UUIDString) ：%@",charact.UUIDString);
                            if ([charact.UUIDString isEqualToString:@"1001"]) {
                                NSLog(@"成功写入写特性 mac：%@",peripheralMac);
                                [self.sendDataCharacteristicDictionary setObject:charact forKey:peripheralMac];                                
                            }
                            else if([charact.UUIDString isEqualToString:@"1002"]){
                                [self.reciveDataCharacteristicDictionary setObject:charact forKey:peripheralMac];
                                NSLog(@"成功写入读特性 mac：%@",peripheralMac);
                            }
                        }
                        //验证mac地址
                        LGCharacteristic *writeCharact=[self.sendDataCharacteristicDictionary objectForKey:peripheralMac];
                        LGCharacteristic *readCharact=[self.reciveDataCharacteristicDictionary objectForKey:peripheralMac];
                        NSString *mac=[[HeatingClothesBLEService sharedInstance] getBLEMacAddressAndDoVerify:writeCharact reciveCharacteristic:readCharact peripheral:peripheral];
                        if (mac.length>10) {
                           NSLog(@"成功写入设备 mac：%@",peripheralMac);
                           [self.peripheralsDictionary setObject:peripheral forKey:peripheralMac];
                            if (macAddress!=nil&&self.isBound==YES) {//这就是绑定设备的情景
                                NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                                NSNotification *notify = [[NSNotification alloc]initWithName:@"ConnectionSuccessful" object:peripheralMac userInfo:nil];
                                [nc postNotification:notify];
                            }else{
                                NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                                NSNotification *notify = [[NSNotification alloc]initWithName:@"ConnectionSuccessful_warm" object:peripheralMac userInfo:nil];
                                [nc postNotification:notify];

                            }
                        }else{
                            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                            NSNotification *notify = [[NSNotification alloc]initWithName:@"ValidationMacfails" object:peripheralMac userInfo:nil];
                            [nc postNotification:notify];

                        }
                       
                    }];
                }
            }
        }];
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
    NSLog(@"诊断%@,%@,%@",macAddress,sendChara,reciveChara);
    Byte value[] = {0xaa, 0x0a, 0x00, 0x02};
    LGCharacteristic *this_sendChara = sendChara;
    LGCharacteristic *this_reciveChara = reciveChara;
    if (!this_sendChara) {
        return -1000;
    }
    if (!this_reciveChara) {
        return -1000;
    }
    NSData *temperatureData= [self doJob:this_sendChara writeValue:value writelength:4 reciveCharacteristic:this_reciveChara];
    if (!temperatureData) {
        return -1000;
    }
    
    Byte *tempByteLittle = (Byte *)[temperatureData bytes];
    Byte tempByte[] = {tempByteLittle[2], tempByteLittle[1]};
    short s = (short) (((tempByte[0] & 0xff) << 8) | (tempByte[1] & 0xff));
    float f = s;
    float temperature = f / 10.0f;
    return temperature;
}

#pragma mark 获取最大设置温度
- (float)getMaxSetedTemp:(NSString *)macAddress andandsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara{
    Byte value[] = {0xaa, 0x1e, 0x00, 0x02};
    NSData *temperatureData = [self doJob:sendChara writeValue:value writelength:4 reciveCharacteristic:reciveChara];
    if (!temperatureData) {
        return -1000;
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
        return -1000;
    }
    Byte *countDownTimeLittle = (Byte *)[countDownTime bytes];
    
    Byte tempByte[] = {countDownTimeLittle[2], countDownTimeLittle[1]};
    
    NSData *tempData = [NSData dataWithBytes:tempByte length:2];
    
    NSString *hexString = [self dataToHexString:tempData];
    
    unsigned result = -1000;
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
- (BOOL)writeHeatTimeCount:(NSString *)macAddress value:(uint)valueToWrite andandsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara{
    uint highValue = valueToWrite >> 8;
    uint lowValue  = valueToWrite & 0x00ff;
    BOOL isSucces=NO;
    //数据小端
    Byte value[] = {0xab, 0x20, 0x00, 0x12, lowValue, highValue};
    NSData *data =  [self doJob:sendChara writeValue:value writelength:6 reciveCharacteristic:reciveChara];
    if (!data){
        return isSucces;
    }
    if([data isEqualToData:[self hexStringToData:@"ab"]]) {
        NSLog(@"写入倒计时时间成功!");
        isSucces=YES;
    }
    return isSucces;
}

#pragma mark 写入预设温度
- (BOOL)writeSettedTemperature:(NSString *)macAddress value:(uint)valueToWrite andandsendChara:(LGCharacteristic *)sendChara andreciveChara:(LGCharacteristic *)reciveChara{
    uint tempValueMax = (valueToWrite + 2) * 10;
    uint highTempValueMax = tempValueMax >> 8;
    uint lowTempValueMax  = tempValueMax & 0x00ff;
    
    //最高温度
    Byte valueMax[] = {0xab, 0x1e, 0x00, 0x02, lowTempValueMax, highTempValueMax};
    NSData *dataMaxReturn =  [self doJob:sendChara writeValue:valueMax writelength:6 reciveCharacteristic:reciveChara];
    uint tempValueMin = (valueToWrite - 2) * 10;
    uint highTempValueMin = tempValueMin >> 8;
    uint lowTempValueMin = tempValueMin & 0x00ff;
    
    //最低温度
    Byte valueMin[] = {0xab, 0x1c, 0x00, 0x02, lowTempValueMin, highTempValueMin};
    NSData *dataMinReturn =  [self doJob:sendChara writeValue:valueMin writelength:6 reciveCharacteristic:reciveChara];
    BOOL maxSuccesFlag = [dataMaxReturn isEqualToData:[self hexStringToData:@"ab"]];
    BOOL minSuccesFlag = [dataMinReturn isEqualToData:[self hexStringToData:@"ab"]];
    BOOL isSucces=NO;
    if (maxSuccesFlag && minSuccesFlag) {//写入最高最低温度成功！！
        isSucces=YES;
        NSMutableDictionary *dic = [LKPopupWindowManager sharedInstance].setTempDictionary;
        int wenDu = valueToWrite;
        [dic setObject:@(wenDu) forKey:macAddress];
    }
    return isSucces;
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
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
    dispatch_semaphore_wait(semaphore, timeout);
    return retValue;
}


- (Byte)getMacByte:(Byte *)bs {
    
        return bs[1];
        
}

#pragma mark 获取蓝牙的mac地址做验证
- (NSString *)getBLEMacAddressAndDoVerify:(LGCharacteristic *)sendChara reciveCharacteristic:(LGCharacteristic *)reciveChara peripheral:(LGPeripheral *)peripheral {

    Byte value1[] = {0xaa, 0x00, 0x00, 0x11};//0000
    NSData *data1 = [self doJob:sendChara writeValue:value1 writelength:4 reciveCharacteristic:reciveChara];
    if (!data1) {
        NSLog(@"空数据1，跳出");
        return @"";
    }
    Byte *testByte1 = (Byte *)[data1 bytes];

    Byte b1 = [self getMacByte:testByte1];
    
    Byte value2[] = {0xaa, 0x01, 0x00, 0x11};//0001
    NSData *data2 = [self doJob:sendChara writeValue:value2 writelength:4 reciveCharacteristic:reciveChara];
    if (!data2) {
        NSLog(@"空数据，跳出");
        return @"";
    }

    Byte *testByte2 = (Byte *)[data2 bytes];
    Byte b2 = [self getMacByte:testByte2];
    
    Byte value3[] = {0xaa, 0x02, 0x00, 0x11};//0002
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
        //[self saveDevice:macString peripheral:peripheral sendDataCharacteristic:sendChara reciveDataCharacteristic:reciveChara];
        NSLog(@"mac验证通过");
        [[NSNotificationCenter defaultCenter] postNotificationName:HeatingClothesBLEConected object:[self parseNetMACStringToMACString:macString]];
    }else if([data7 isEqualToData:[self hexStringToData:@"ac"]]){
        NSLog(@"验证未通过");
    }
    NSString *macUp=[macText uppercaseString];//大写
    return macUp;
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
    return [macString uppercaseString];
}

#pragma mark - 读取展板信息
-(WarmShowInfoModel *)ReadInfoFromBluetoothWith:(NSString *)macAddress{
    if (![self queryIsBLEConnected:macAddress]) {
        return nil;
    }
    LGCharacteristic *read=[self getReciveDataCharacteristic:macAddress];
    LGCharacteristic *Send=[self getSendDataCharacteristic :macAddress];
    
    //剩余倒计时时间
    int HeatingCountDownTime = [self getHeatingCountDownTime:macAddress andandsendChara:Send andreciveChara:read];
    float MaxSetedTemp       = [self getMaxSetedTemp:macAddress andandsendChara:Send andreciveChara:read];
    float CurrentTemperature = [self getDeviceCurrentTemperature:macAddress andsendChara:Send andreciveChara:read];
    int   restPower          = [self getPowerLeft:macAddress andandsendChara:Send andreciveChara:read];
    
    WarmShowInfoModel *model = [[WarmShowInfoModel alloc]init];
    model.remainingTime =(float)HeatingCountDownTime;
    model.presetTemperature  = MaxSetedTemp;
    model.currentTemperature = CurrentTemperature;
    model.mac = macAddress;
    model.restPower =restPower;
    return model;
}

-(int)getDaoJiShi_Mac:(NSString *)macAddress{
    if (![self queryIsBLEConnected:macAddress]) {
        return -999;
    }
    LGCharacteristic *read=[self getReciveDataCharacteristic:macAddress];
    LGCharacteristic *Send=[self getSendDataCharacteristic :macAddress];
    int HeatingCountDownTime = [self getHeatingCountDownTime:macAddress andandsendChara:Send andreciveChara:read];
    return HeatingCountDownTime;
}

-(float)getDangQianWenDu_Mac:(NSString *)macAddress{
    if (![self queryIsBLEConnected:macAddress]) {
        return -999;
    }
    LGCharacteristic *read=[self getReciveDataCharacteristic:macAddress];
    LGCharacteristic *Send=[self getSendDataCharacteristic :macAddress];
    float CurrentTemperature = [self getDeviceCurrentTemperature:macAddress andsendChara:Send andreciveChara:read];
    return CurrentTemperature;
}
-(void)dealloc
{
   if (_timer != nil) {
                //销毁定时器
                [_timer invalidate];
    }
}

@end

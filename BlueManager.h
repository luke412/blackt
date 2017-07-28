//
//  BlueManager.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/7.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "DOSingleton.h"







@interface BlueManager : DOSingleton
/** 扫码字符串转Mac*/
-(NSString *)getMacFromQRcode:(NSString *)qrStr;

#pragma mark - 蓝牙操作
/** 断开蓝牙连接 */
-(void)disconnectWithMac:(NSString *)mac
                  Sucess:(void(^)(NSString * mac))sucess
                 Failure:(void(^)(NSString *mac))failure;

/**蓝牙设备重连 */
-(void)reconnectionWithMac:(NSString *)mac
                    Sucess:(void(^)(NSString * mac))sucess
                   Failure:(void(^)(NSString *mac))failur
          andIsRunDelegate:(BOOL)isRunDelegate;

/**蓝牙智能连接  有udid走协议栈重连,没有的话扫描连接*/
-(void)smartctionWithMac:(NSString *)mac
                  Sucess:(void(^)(NSString * mac))sucess
                 Failure:(void(^)(NSString *mac))failure
        andIsRunDelegate:(BOOL)isRunDelegate;

/**设置目标温度 */
-(BOOL)setWenDuWithMac:(NSString *)mac
              andWenDu:(int)wenDu;

/**读取目标温度*/
-(NSInteger)readCurrMuBiao_Mac:(NSString *)mac;

/**读取当前温度*/
-(NSInteger)readCurrTemp_Mac:(NSString *)mac;


/**设置加热时间  （分钟） */
-(BOOL)setShiJianWithMac:(NSString *)mac
              andShiJian:(int)ShiJianMin;

/**读取加热时间*/


@end

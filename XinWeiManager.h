//
//  XinWeiManager.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/17.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XinWeiManager : NSObject
/**
 *  行为入库
 *
 *  @param userId                用户ID
 *  @param deviceId              设备号
 *  @param geographicCoordinates 地理位置  “ 100.23,89.77 ”
 *  @param bluetoothMac          蓝牙mac
 *  @param phoneModel            苹果6S
 *  @param phoneSystem           手机系统
 *  @param behaviorTime          2017-04-29 18:19:30
 *  @param behaviorEndTime       2017-04-29 18:19:40
 *  @param behaviorType          C12
 *  @param heatTargetTemperature 58
 *  @param heatTemperature       55
 *  @param schemeId              1
 *  @param isComplete            是否正常完成

 */
-(void)user_XingWeiUpLoad_userId:(NSString *)userId
                        deviceId:(NSString *)deviceId
           geographicCoordinates:(NSString *)geographicCoordinates
                    bluetoothMac:(NSString *)bluetoothMac
                      phoneModel:(NSString *)phoneModel
                     phoneSystem:(NSString *)phoneSystem
                    behaviorTime:(NSString *)behaviorTime
                 behaviorEndTime:(NSString *)behaviorEndTime
                    behaviorType:(NSString *)behaviorType
           heatTargetTemperature:(NSString *)heatTargetTemperature
                 heatTemperature:(NSString *)heatTemperature
                        schemeId:(NSString *)schemeId
                      isComplete:(BOOL)isComplete;
@end

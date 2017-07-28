//
//  CowManager.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/10.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "DOSingleton.h"

@interface CowManager : DOSingleton

/**
 *  点击小牛，获取设备信息
 *
 *  @param currDevice    当前设备
 *  @param userHeatState 当前模式
 *  @param successBlobk  成功
 *  @param failureBlock  失败
 */
-(void)cowClick_device:(DeviceModel *)currDevice
             heatState:(UserHeatState)userHeatState
               Success:(void(^)(NSInteger currTemp,NSInteger currMuBiaoTemp))successBlobk
               failure:(void(^)())failureBlock;
@end

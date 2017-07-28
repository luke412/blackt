//
//  CowManager.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/10.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "CowManager.h"
#import "BlueManager.h"

@implementation CowManager
-(void)cowClick_device:(DeviceModel *)currDevice
             heatState:(UserHeatState)userHeatState
               Success:(void(^)(NSInteger currTemp,NSInteger currMuBiaoTemp))successBlobk
               failure:(void(^)())failureBlock
{
    __block  NSInteger currTemp;
    __block  NSInteger currMuBiaoTemp;

    LKShow(@"正在读取...");
    NSString *mac = currDevice.clothesMac;
    if (!mac) {
        LKRemove;
        [MBProgressHUD  showError:@"设备未连接"];
        return;
    }
    
    [Blue_Manager smartctionWithMac:mac Sucess:^(NSString *mac) {
        LKLog(@"小牛获取当前温度，温度变化趋势成功");
         LKRemove;
        //获取温度
          currTemp =  [Blue_Manager readCurrTemp_Mac:mac];
          currMuBiaoTemp = [Blue_Manager readCurrMuBiao_Mac:mac];
            if (successBlobk) {
                successBlobk(currTemp,currMuBiaoTemp);
            }
    
    } Failure:^(NSString *mac) {
        LKLog(@"小牛获取当前温度，温度变化趋势失败");
        [[LKProgressHUD sharedInstance] removeLKMengBan];
    } andIsRunDelegate:NO];
}
@end

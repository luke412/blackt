//
//  Main_Handler.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/8.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  首页业务逻辑  (高层业务)

#import "Main_Handler.h"
#import "BlueManager.h"
#import "ZiZhuManager.h"

@implementation Main_Handler
-(void)userDingShi_timeStr:(NSString *)timerStr complete:(void(^)(int minInt))completeBlock{
    
    int minInt;
    if ([timerStr isEqualToString:@"不限时"]) {
        minInt = MAX_UPSCALE;
    }else{
        NSArray *numberArr = [timerStr componentsSeparatedByString:@"min"];
        NSString *minStr   = numberArr[0];
        minInt  = [minStr intValue];
    }
    
    //设定定时
    DeviceModel *deivce = App_Manager.currDevice;
    [Blue_Manager smartctionWithMac:deivce.clothesMac Sucess:^(NSString *mac) {
        if ([Blue_Manager setShiJianWithMac:deivce.clothesMac andShiJian:minInt]) {
            [MBProgressHUD showSuccess:@"设置成功"];
        }else{
            [MBProgressHUD showError:@"设置失败"];
        }
    } Failure:^(NSString *mac) {
        [MBProgressHUD showError:@"设置失败"];
    } andIsRunDelegate:NO];
    
    
    if (completeBlock) {
        completeBlock(minInt);
    }
}



#pragma mark - 首次连接 50度 不限时
-(void)FirstConnect_mac:(NSString *)mac
                 Sucess:(void(^)(NSString * mac))sucess
                Failure:(void(^)(NSString *mac))failur
       andIsRunDelegate:(BOOL)isRunDelegate{
    
    [Blue_Manager smartctionWithMac:mac Sucess:^(NSString *mac) {
        if ([Blue_Manager setShiJianWithMac:mac andShiJian:MAX_UPSCALE]) {
            if ([Blue_Manager setWenDuWithMac:mac andWenDu:50]) {
                if (sucess) {
                    sucess(mac);
                }
            }else{
                if (failur) {
                    failur(mac);
                }
            }
        }else{
            if (failur) {
                failur(mac);
            }
        }
    } Failure:^(NSString *mac) {
        if (failur) {
            failur(mac);
        }
    } andIsRunDelegate:isRunDelegate];

}
@end

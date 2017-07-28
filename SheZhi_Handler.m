//
//  SheZhi_Handler.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/11.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  设置界面逻辑

#import "SheZhi_Handler.h"
#import "NetWorkManager.h"
#import "ZiZhuManager.h"
#import "DataBaseManager.h"
#import "AppDelegate.h"

@implementation SheZhi_Handler
-(void)logOut{
        NSString *userId    = [App_Manager getUserId];
        NSString *userToken = [App_Manager getUserToken];
        NSString *deviceId  = [App_Manager getDeviceId];
        LKShow(@"正在退出...");
        [NetWork_Manager LogOut_userId:userId userToken:userToken deviceId:deviceId Success:^(id responseObject) {
            LKRemove;
            [App_Manager saveUserId_Id:@""];
            [App_Manager saveUserToken_Token:@""];
            [MBProgressHUD showSuccess:@"已退出登录"];
             [UserDefaultsUtils saveValue:@"NO" forKey:@"islogin"];
   
            //结束理疗
             if (App_Manager.heatState == Zizhu_heat){
                 [ZiZhu_Manager end];
             }
            
            //清理信息
            [DataBase_Manager clearTheTableWithName:@"MyNewMessage"];
            [UserDefaultsUtils saveImage:nil withKey:@"TOUX_IANG"];
            UIApplication * application = [UIApplication sharedApplication];
            AppDelegate   * appDelegate = (AppDelegate *) application.delegate;
            [appDelegate goToLogViewController];
        } Abnormal:^(id responseObject) {
             LKRemove;
            [MBProgressHUD showError:responseObject[@"retMsg"]];
        } Failure:^(NSError *error) {
             LKRemove;
            [MBProgressHUD showError:@"网络开小差~\(≧▽≦)/"];
        }];
}
@end

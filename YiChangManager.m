//
//  YiChangManager.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/20.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  异常处理者  连接异常处理

#import "YiChangManager.h"
#import "LianJieJianCe_ViewController.h"
#import "LanYa_ViewController.h"
#import "KaiJi_ViewController.h"
#import "YiChang4_ViewController.h"
#import "JC_Connecting_ViewController.h"

@implementation YiChangManager
-(void)showViewControllers_vc:(Base_ViewController *)vc{

    LianJieJianCe_ViewController *vc1 = [[LianJieJianCe_ViewController alloc]init];
    __weak typeof (vc1)weakvc1 = vc1;
    vc1.myClickBlick = ^{
        LanYa_ViewController *vc2 = [[LanYa_ViewController alloc]init];
        __weak typeof (vc2)weakvc2 = vc2;
        vc2.myClickBlick = ^{
            KaiJi_ViewController *vc3 = [[KaiJi_ViewController alloc]init];
            __weak typeof (vc3)weakvc3 = vc3;
            vc3.myClickBlick = ^{
                YiChang4_ViewController *vc4 = [[YiChang4_ViewController alloc]init];
                 __weak typeof (vc4)weakvc4 = vc4;
                vc4.myClickBlick = ^{
                    JC_Connecting_ViewController *vc5 = [[JC_Connecting_ViewController alloc]init];
                    __weak typeof (vc5)weakvc5 = vc5;
                    vc5.blueFailure = ^(NSString *mac) {
                        [weakvc5.navigationController popToViewController:weakvc1 animated:NO];
                    };
                    vc5.blueSuccess = ^(NSString *mac) {
                        [weakvc5.navigationController popToViewController:vc animated:NO];
                        if (_successBlock) {
                            _successBlock(mac);
                        }
                    };
                    
                    [weakvc4.navigationController pushViewController:vc5 animated:NO];
                };
                [weakvc3.navigationController pushViewController:vc4 animated:NO];
            };
            [weakvc2.navigationController pushViewController:vc3 animated:NO];
        };
        [weakvc1.navigationController pushViewController:vc2 animated:NO];
    };
    [vc.navigationController pushViewController:vc1 animated:NO];
}
@end

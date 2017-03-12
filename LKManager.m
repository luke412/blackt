//
//  LKManager.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/1/6.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "LKManager.h"
#import "ZFScanViewController.h"
@implementation LKManager
-(NSString *)getMacFromQRCodeWithVC:(UINavigationController *)vc andTarget:(nullable UIViewController *)targetVC{
    __block NSString *returnMac;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    //    在一个操作结束后发信号，这会使得信号量+1
    ZFScanViewController *zfVC=[[ZFScanViewController alloc]init];
        __weak typeof (zfVC)weakvc = zfVC;
        weakvc.returnScanBarCodeValue = ^(NSString * barCodeString){
        NSLog(@"二维码：%@",barCodeString);
        if (barCodeString.length!=12) {
            //mac出错
            [weakvc.session startRunning];
            return;
        }
        else{
            returnMac=barCodeString;
            if (targetVC==nil) {
                [weakvc.navigationController popViewControllerAnimated:NO];
            }else{
                [weakvc.navigationController pushViewController:targetVC animated:NO];
            }

        }
            dispatch_semaphore_signal(sema);//block执行结束，方法返回
    };
        [vc.navigationController pushViewController:weakvc animated:YES];

    
    //一开始执行到这里信号量为0，线程被阻塞，直到上述操作完成使信号量+1,线程解除阻塞
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return returnMac;
}
@end

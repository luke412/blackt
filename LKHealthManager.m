
//
//  LKHealthManager.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/6/13.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  封装健康数据操作

#import "LKHealthManager.h"
#import <HealthKit/HealthKit.h>
#import "HealthKitManage.h"
#import "HealthModel.h"
@implementation LKHealthManager
/**获取某一天的*/
-(void)get1day_nowDate:(NSDate *)nowDate Success:(void(^)(NSArray<HealthModel *> *healthDataList))successBlock Failure:(void(^)())failureBlock{
    HealthKitManage *manage = [HealthKitManage shareInstance];
    NSMutableArray  *healthDataList = [[NSMutableArray alloc]init];
    [manage authorizeHealthKit:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"success");
            __block  HealthModel *model = [[HealthModel alloc]init];
            model.date = nowDate;
            dispatch_queue_t queue      = dispatch_get_global_queue(0, 0);
                //创建一个信号量（值为0）
             dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            dispatch_async(queue, ^{
                //步数
                [manage getStepCount_NSDate:nowDate completion:^(double value, NSError *error) {
                    NSLog(@"1count-->%.0f", value);
                    NSLog(@"1error-->%@", error.localizedDescription);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        LKLog(@"%@",[NSString stringWithFormat:@"步数：%.0f步", value]);
                    });
                    model.StepCount = value;
                    dispatch_semaphore_signal(semaphore);
                }];
                //距离
                [manage getDistance_NSDate:nowDate completion:^(double value, NSError *error) {
                    NSLog(@"2count-->%.2f", value);
                    NSLog(@"2error-->%@", error.localizedDescription);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        LKLog(@"%@",[NSString stringWithFormat:@"公里数：%.2f公里", value]);
                    });
                    model.Distance = value;
                    dispatch_semaphore_signal(semaphore);
                }];
                   
                 //信号量减1，如果>0，则向下执行，否则等待
                 dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                 dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                 [healthDataList addObject:model];
                if (successBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        successBlock(healthDataList);
                    });
                }
            });
        }
        else {
            [MBProgressHUD showError:@"获取权限失败"];
            NSLog(@"fail");
            if (failureBlock) {
                failureBlock();
            }
        }
    }];
}
/**读取最近7天的数据*/
-(void)getlatest7day_nowDate:(NSDate *)nowDate   Success:(void(^)(NSArray<HealthModel *> *healthDataList))successBlock Failure:(void(^)())failureBlock{


    
    
    
}

/**读取最近30天的数据*/
-(void)getlatest30day_nowSate:(NSDate *)nowDate  Success:(void(^)(NSArray <HealthModel *>*healthDataList))successBlock Failure:(void(^)())failureBlock{

}

/**读取最近360天的数据*/
-(void)getlatest360day_nowSate:(NSDate *)nowDate Success:(void(^)(NSArray<HealthModel *> *healthDataList))successBlock Failure:(void(^)())failureBlock{


}






@end

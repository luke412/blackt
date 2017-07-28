//
//  LKHealthManager.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/6/13.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  封装健康数据操作

#import <Foundation/Foundation.h>
@class HealthModel;
@interface LKHealthManager : NSObject
/**获取某一天的*/
-(void)get1day_nowDate:(NSDate *)nowDate Success:(void(^)(NSArray<HealthModel *> *healthDataList))successBlock Failure:(void(^)())failureBlock;
/**读取最近7天的数据*/
-(void)getlatest7day_nowDate:(NSDate *)nowDate   Success:(void(^)(NSArray <HealthModel *>*healthDataList))successBlock Failure:(void(^)())failureBlock;

/**读取最近30天的数据*/
-(void)getlatest30day_nowSate:(NSDate *)nowDate  Success:(void(^)(NSArray<HealthModel *> *healthDataList))successBlock Failure:(void(^)())failureBlock;

/**读取最近360天的数据*/
-(void)getlatest360day_nowSate:(NSDate *)nowDate Success:(void(^)(NSArray<HealthModel *> *healthDataList))successBlock Failure:(void(^)())failureBlock;
@end

//
//  HealthKitManage.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/6/13.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>
#import <UIKit/UIDevice.h>

#define HKVersion [[[UIDevice currentDevice] systemVersion] doubleValue]
#define CustomHealthErrorDomain @"com.sdqt.healthError"
@interface HealthKitManage : NSObject
@property (nonatomic, strong) HKHealthStore *healthStore;

+(id)shareInstance;

/**申请权限*/
- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion;

/**获得某日步数*/
- (void)getStepCount_NSDate:(NSDate *)date completion:(void(^)(double value, NSError *error))completion;

/**获得某日距离*/
- (void)getDistance_NSDate:(NSDate *)date   completion:(void(^)(double value, NSError *error))completion;

/**获得某周步数*/
/**获得某周距离*/



@end

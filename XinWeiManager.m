//
//  XinWeiManager.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/17.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "XinWeiManager.h"
#import "XingWeiModel.h"
#import "DataBaseManager.h"

@implementation XinWeiManager
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
                      isComplete:(BOOL)isComplete
{
    XingWeiModel *xingWeiModel         = [[XingWeiModel alloc]init];
    xingWeiModel.userId                = userId;
    xingWeiModel.deviceId              = deviceId;
    xingWeiModel.geographicCoordinates = geographicCoordinates;
    xingWeiModel.bluetoothMac          = bluetoothMac;
    xingWeiModel.phoneModel            = phoneModel;
    xingWeiModel.phoneSystem           = phoneSystem;
    xingWeiModel.behaviorTime          = behaviorTime;
    xingWeiModel.behaviorEndTime       = behaviorEndTime;
    xingWeiModel.behaviorType          = behaviorType;
    xingWeiModel.heatTargetTemperature = heatTargetTemperature;
    xingWeiModel.heatTemperature       = heatTemperature;
    xingWeiModel.schemeId              = schemeId;
    if (isComplete == YES) {
        xingWeiModel.isComplete = @"1";
    }else{
        xingWeiModel.isComplete = @"0";
    }
    
    
    
    //存入数据库
    [DataBase_Manager saveXinWei_UserBehaviorModel:xingWeiModel];
    
    //取出全部缓存
    NSArray <XingWeiModel *>*  xingWeiArr = [DataBase_Manager loadAllUserBehavior];
    
    //上传行为
    [NetWork_Manager XingWeiUpLoad_jsonArray:xingWeiArr
                                     Success:^(id responseObject) {
                                         [DataBase_Manager clearnXinWeiTable];
                                    } Abnormal:^(id responseObject) {
                                        
                                    } Failure:^(NSError *error) {
                                        
                                    }];
    
}
@end

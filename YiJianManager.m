//
//  YiJianManager.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/16.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "YiJianManager.h"
#import "YiJianPlanModel.h"
#import "HeatModel.h"
#import "XinWeiManager.h"
#import "WeiZhiManager.h"

@interface YiJianManager ()
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger seconds;
@property(nonatomic,assign)NSInteger sumSeconds;


@property(nonatomic,strong)NSDate *starDate;
@property(nonatomic,strong)NSDate *endDate;


@end

@implementation YiJianManager


-(void)planRun_Model:(YiJianPlanModel *)model{
     YiJian_Manager.currPlan = model;
    [self.timer setFireDate:[NSDate date]];
    self.starDate = [NSDate date];
    
    _seconds = 0;
    App_Manager.heatState = YiJian_heat;
    
    //总时间
    _sumSeconds = 0;
    for (HeatModel *model in _currPlan.treatmentTemperatureList) {
        _sumSeconds = _sumSeconds + model.temperatureDuration * 60;
    }
    
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(startRun:)]) {
        NSInteger restSeconds = _sumSeconds - _seconds;
        [_delegate startRun:restSeconds];
    }
}
-(void)finish{
    self.endDate = [NSDate date];
    [self.timer setFireDate:[NSDate distantFuture]];
    App_Manager.heatState = WuCaoZuo_heat;
     _seconds = 0 ;
    
    //上报行为
    XinWeiManager *xinWeiManager = [[XinWeiManager alloc]init];
    NSString *userId             = [App_Manager getUserId];
    NSString *deviceid           = [App_Manager getDeviceId];
    NSString *mac                = App_Manager.currDevice.clothesMac;
    //手机型号
    NSString *phoneModel         = [App_Manager iphoneType];
    //手机系统
    NSString *phoneSystem        = [[UIDevice currentDevice] systemVersion];
    //开始喝结束时间
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *startDateStr       = [dateFormat stringFromDate:self.starDate];
    NSString *endDateStr         = [dateFormat stringFromDate:self.endDate];
    //最高温 当前目标温度
    NSArray <HeatModel *>*  heatModelArr = self.currPlan.treatmentTemperatureList;
    NSInteger maxTemp = 0;
    NSInteger currTemp = 0;
    for (HeatModel *model in heatModelArr) {
        if (model.temperatureHigh > maxTemp) {
            maxTemp = model.temperatureHigh;
        }
        currTemp = model.temperatureHigh;
    }
    NSString *maxStr = [NSString stringWithFormat:@"%ld",maxTemp];
    NSString *tempStr = [NSString stringWithFormat:@"%ld",currTemp];
    
    NSString *weiZhiStr = [WeiZhi_Manager getLocationStr];
    
    [xinWeiManager user_XingWeiUpLoad_userId:userId
                                    deviceId:deviceid
                       geographicCoordinates:weiZhiStr
                                bluetoothMac:mac
                                  phoneModel:phoneModel
                                 phoneSystem:phoneSystem
                                behaviorTime:startDateStr
                             behaviorEndTime:endDateStr
                                behaviorType:@"C22"
                       heatTargetTemperature:tempStr
                             heatTemperature:maxStr
                                    schemeId:self.currPlan.schemeId
                                  isComplete:YES];
    
    

    
    if (_delegate && [_delegate respondsToSelector:@selector(finish)]) {
        [_delegate finish];
    }
    
    NSString *name = self.currPlan.schemeName;
    [Win_Manager showLiliaoEndWindow_planName:[NSString stringWithFormat:@"%@方案",name] queDing:^{
        
    }];
}
-(void)end{
    self.endDate = [NSDate date];
    [self.timer setFireDate:[NSDate distantFuture]];
    App_Manager.heatState = WuCaoZuo_heat;
    _seconds = 0 ;
    
    //上报行为
    XinWeiManager *xinWeiManager = [[XinWeiManager alloc]init];
    NSString *userId             = [App_Manager getUserId];
    NSString *deviceid           = [App_Manager getDeviceId];
    NSString *mac                = App_Manager.currDevice.clothesMac;
    //手机型号
    NSString *phoneModel         = [App_Manager iphoneType];
    //手机系统
    NSString *phoneSystem        = [[UIDevice currentDevice] systemVersion];
    //开始喝结束时间
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *startDateStr       = [dateFormat stringFromDate:self.starDate];
    NSString *endDateStr         = [dateFormat stringFromDate:self.endDate];
    //最高温 当前目标温度
    NSArray <HeatModel *>*  heatModelArr = self.currPlan.treatmentTemperatureList;
    NSInteger maxTemp                    = 0;
    NSInteger currTemp                   = 0;
    for (HeatModel *model in heatModelArr) {
        if (model.temperatureHigh > maxTemp) {
            maxTemp = model.temperatureHigh;
        }
        currTemp = model.temperatureHigh;
    }
    NSString *maxStr = [NSString stringWithFormat:@"%ld",maxTemp];
    NSString *tempStr = [NSString stringWithFormat:@"%ld",currTemp];
    
    NSString *weiZhiStr = [WeiZhi_Manager getLocationStr];
    
    [xinWeiManager user_XingWeiUpLoad_userId:userId
                                    deviceId:deviceid
                       geographicCoordinates:weiZhiStr
                                bluetoothMac:mac
                                  phoneModel:phoneModel
                                 phoneSystem:phoneSystem
                                behaviorTime:startDateStr
                             behaviorEndTime:endDateStr
                                behaviorType:@"C22"
                       heatTargetTemperature:tempStr
                             heatTemperature:maxStr
                                    schemeId:self.currPlan.schemeId
                                  isComplete:NO];
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(end)]) {
        [_delegate end];
    }
}

-(void)everyTime{
    _seconds += MIAO_SHU;
    _sumSeconds = 0;
    for (HeatModel *model in _currPlan.treatmentTemperatureList) {
        _sumSeconds = _sumSeconds + model.temperatureDuration * 60;
    }
    
    if (_sumSeconds <= _seconds) {
        [self finish];
        return;
    }

    
    if (_delegate && [_delegate respondsToSelector:@selector(refreshEveryTime:sumSecond:)]) {
        NSInteger restSeconds = _sumSeconds - _seconds;
        [_delegate refreshEveryTime:restSeconds sumSecond:_sumSeconds];
    }
}


#pragma mark - 懒加载
-(NSTimer *)timer{
    if (!_timer) {
        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(everyTime) userInfo:nil repeats:YES];
        //滚动条不受影响
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
@end

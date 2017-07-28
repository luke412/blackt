//
//  XingWeiModel.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/17.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "XingWeiModel.h"

@implementation XingWeiModel
-(instancetype)initWithGeographicCoordinates:(NSString *)geographicCoordinates
                                bluetoothMac:(NSString *)bluetoothMac
                                behaviorTime:(NSString *)behaviorTime
                             behaviorEndTime:(NSString *)behaviorEndTime
                                behaviorType:(NSString *)behaviorType
                       heatTargetTemperature:(NSString *)heatTargetTemperature
                             heatTemperature:(NSString *)heatTemperature
                                 diagnosisId:(NSString *)diagnosisId
                                    schemeId:(NSString *)schemeId
                               treatmentType:(NSString *)treatmentType
                                  isComplete:(NSString *)isComplete
{
    self = [super init];
    if (self) {
        //用户id
        self.userId                = [App_Manager getUserId];
        //手机设备id
        self.deviceId              = [App_Manager getDeviceId];
        //手机型号
        self.phoneModel            = [[UIDevice currentDevice] model];
        //手机系统
        self.phoneSystem           = [[UIDevice currentDevice] systemVersion];
        //地理位置
        self.geographicCoordinates = geographicCoordinates;
        //mac
        self.bluetoothMac          = bluetoothMac;
        //开始时间
        self.behaviorTime          = behaviorTime;
        //结束时间
        self.behaviorEndTime       = behaviorEndTime;
        //行为类型
        self.behaviorType          = behaviorType;
        //目标温度
        self.heatTargetTemperature = heatTargetTemperature;
        //最高温度
        self.heatTemperature       = heatTemperature;
        //诊断方案ID
        self.diagnosisId           = diagnosisId;
        //预制方案ID
        self.schemeId              = schemeId;
        //一键理疗类别
        self.treatmentType         = treatmentType;
        //是否正常完成
        self.isComplete            = isComplete;
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        //用户id
        self.userId      = [App_Manager getUserId];
        //手机设备id
        self.deviceId    = [App_Manager getDeviceId];
        //手机型号
        self.phoneModel  = [[UIDevice currentDevice] model];
        //手机系统
        self.phoneSystem = [[UIDevice currentDevice] systemVersion];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userId                        forKey:@"userId"];
    [aCoder encodeObject:self.deviceId                      forKey:@"deviceId"];
    [aCoder encodeObject:self.geographicCoordinates         forKey:@"geographicCoordinates"];
    [aCoder encodeObject:self.bluetoothMac                  forKey:@"bluetoothMac"];
    [aCoder encodeObject:self.phoneModel                    forKey:@"phoneModel"];
    [aCoder encodeObject:self.diagnosisId                   forKey:@"diagnosisId"];
    [aCoder encodeObject:self.phoneSystem                   forKey:@"phoneSystem"];
    [aCoder encodeObject:self.behaviorTime                  forKey:@"behaviorTime"];
    [aCoder encodeObject:self.behaviorEndTime               forKey:@"behaviorEndTime"];
    [aCoder encodeObject:self.behaviorType                  forKey:@"behaviorType"];
    [aCoder encodeObject:self.heatTargetTemperature         forKey:@"heatTargetTemperature"];
    [aCoder encodeObject:self.heatTemperature               forKey:@"heatTemperature"];
    [aCoder encodeObject:self.schemeId                      forKey:@"schemeId"];
    [aCoder encodeObject:self.treatmentType                 forKey:@"treatmentType"];
    [aCoder encodeObject:self.isComplete                    forKey:@"isComplete"];

}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.userId                = [aDecoder decodeObjectForKey:@"userId"];
        self.deviceId              = [aDecoder decodeObjectForKey:@"deviceId"];
        self.geographicCoordinates = [aDecoder decodeObjectForKey:@"geographicCoordinates"];
        self.bluetoothMac          = [aDecoder decodeObjectForKey:@"bluetoothMac"];
        self.phoneModel            = [aDecoder decodeObjectForKey:@"phoneModel"];
        self.diagnosisId           = [aDecoder decodeObjectForKey:@"diagnosisId"];
        self.phoneSystem           = [aDecoder decodeObjectForKey:@"phoneSystem"];
        self.behaviorTime          = [aDecoder decodeObjectForKey:@"behaviorTime"];
        self.behaviorEndTime       = [aDecoder decodeObjectForKey:@"behaviorEndTime"];
        self.behaviorType          = [aDecoder decodeObjectForKey:@"behaviorType"];
        self.heatTargetTemperature = [aDecoder decodeObjectForKey:@"heatTargetTemperature"];
        self.heatTemperature       = [aDecoder decodeObjectForKey:@"heatTemperature"];
        self.schemeId              = [aDecoder decodeObjectForKey:@"schemeId"];
        self.treatmentType         = [aDecoder decodeObjectForKey:@"treatmentType"];
        self.isComplete         = [aDecoder decodeObjectForKey:@"isComplete"];

    }
    return self;
}


@end

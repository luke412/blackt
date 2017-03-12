//
//  WarmShowInfoModel.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/2/26.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  每个设备的展示信息model

#import <Foundation/Foundation.h>

@interface WarmShowInfoModel : NSObject
@property(nonatomic,assign)float presetTemperature;
@property(nonatomic,assign)float currentTemperature;
@property(nonatomic,assign)float presetTime;   //预设时间
@property(nonatomic,assign)float remainingTime;//剩余时间
@property(nonatomic,assign) int  restPower;    //剩余电量
@property(nonatomic,copy)NSString *mac;
@end

//
//  WarmShowInfoModel.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/2/26.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "WarmShowInfoModel.h"

@implementation WarmShowInfoModel
-(NSString *)description{
    /*
     @property(nonatomic,assign)float presetTemperature;
     @property(nonatomic,assign)float currentTemperature;
     @property(nonatomic,assign)float presetTime;   //预设时间
     @property(nonatomic,assign)float remainingTime;//剩余时间
     @property(nonatomic,assign) int  restPower;    //剩余电量
     @property(nonatomic,copy)NSString *mac;
     
     */
    NSString *string = [NSString stringWithFormat:@"\n mac:%@ 剩余时间:%.1f  ", self.mac,self.remainingTime];
    return string;
}
@end

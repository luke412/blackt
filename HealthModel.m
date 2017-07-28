//
//  HealthModel.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/6/13.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  

#import "HealthModel.h"

@implementation HealthModel
-(NSString *)description{
    NSString *str = [NSString stringWithFormat:@"日期：%@,跑动距离:%.0f 步数:%.0f",_date,_Distance,_StepCount];
    return str;
}
-(NSString *)getRiStr{
    NSDate *date  = self.date;
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"dd"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *currentDateStr = [dateFormat stringFromDate:date];
    return currentDateStr;

}
@end

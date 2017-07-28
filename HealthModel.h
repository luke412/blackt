//
//  HealthModel.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/6/13.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  健康数据 某一天的数据

#import <Foundation/Foundation.h>

@interface HealthModel : NSObject
/**这天的日期*/
@property(nonatomic,strong)NSDate *date;
/**步数*/
@property(nonatomic,assign)double  StepCount;
/**跑动距离*/
@property(nonatomic,assign)double  Distance;

/**获取这天的日  字符串*/
-(NSString *)getRiStr;
@end

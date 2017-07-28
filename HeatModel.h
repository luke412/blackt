//
//  HeatModel.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/13.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeatModel : NSObject
#pragma mark - 追加参数
/**第几阶段*/
@property(nonatomic,assign)NSInteger index;


/**温度变化ID*/
@property(nonatomic,copy)NSString *temperatureId;
/**最高温度*/
@property(nonatomic,assign)NSInteger temperatureHigh;
/**最低温度*/
@property(nonatomic,assign)NSInteger temperatureLow;
/**持续时间（分钟）*/
@property(nonatomic,assign)NSInteger temperatureDuration;

@end

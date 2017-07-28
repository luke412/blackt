//
//  YiJianPlanModel.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/13.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  一键理疗详细模型

#import <Foundation/Foundation.h>
@class HeatModel;

@interface YiJianPlanModel : NSObject
/** 预制方案ID Long类型 */
@property(nonatomic,copy)NSString *schemeId;
/** 方案名称 */
@property(nonatomic,copy)NSString *schemeName;
/** 药包名称 */
@property(nonatomic,copy)NSString *drugbagName;
/** 药包提示信息 */
@property(nonatomic,copy)NSString *drugbagInfo;
/** 方案背景图 */
@property(nonatomic,copy)NSString *drugbagLocationPic;

/** 佩戴设备步骤图 */
@property(nonatomic,copy)NSString *adornStepPic;
/** 适用人群 */
@property(nonatomic,copy)NSString *remark;

/** 总共使用次数 */
@property(nonatomic,copy)NSString *sumCount;

/** 本月使用次数 */
@property(nonatomic,copy)NSString *monthCount;

/**  本周使用次数 */
@property(nonatomic,copy)NSString *weekCount;

/** 温度阶段列表 */
@property(nonatomic,strong)NSArray <HeatModel *>* treatmentTemperatureList;

/**适宜人群*/
@property(nonatomic,copy)NSString *suitCrowd;
@end

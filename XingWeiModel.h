//
//  XingWeiModel.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/17.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XingWeiModel : NSObject <NSCoding>
/**用户ID*/
@property (nonatomic,copy)NSString *userId;
/**手机设备ID 非空*/
@property(nonatomic,copy)NSString *deviceId;
/**地理坐标 100.23,89.77*/
@property(nonatomic,copy)NSString *geographicCoordinates;
/**设备蓝牙MAC*/
@property(nonatomic,copy)NSString *bluetoothMac;
/**手机型号*/
@property(nonatomic,copy)NSString *phoneModel;
/**手机系统*/
@property(nonatomic,copy)NSString *phoneSystem;
/**行为开始时间 yyyy-MM-dd HH:mm:ss格式 非空*/
@property(nonatomic,copy)NSString *behaviorTime;

/**行为结束时间 yyyy-MM-dd HH:mm:ss格式*/
@property(nonatomic,copy)NSString *behaviorEndTime;
/**行为类型 非空*/
@property(nonatomic,copy)NSString *behaviorType;
/**目标温度*/
@property(nonatomic,copy)NSString *heatTargetTemperature;
/**调温成功最高温度*/
@property(nonatomic,copy)NSString *heatTemperature;
/**诊断方案ID*/
@property(nonatomic,copy)NSString *diagnosisId;
/**预制方案ID*/
@property(nonatomic,copy)NSString *schemeId;
/**一键理疗类别*/
@property(nonatomic,copy)NSString *treatmentType;
/** 是否正常完成 0没用完 1用完了 */
@property(nonatomic,copy)NSString *isComplete;
@end

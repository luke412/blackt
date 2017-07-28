//
//  DeviceModel.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/6.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceModel : NSObject
/** mac*/
@property (nonatomic,copy) NSString *clothesMac;
/** 衣物名称*/
@property (nonatomic,copy) NSString *clothesName;
/** 衣物类型*/
@property (nonatomic,copy) NSString *clothesStyle;
/** 模组类型  KC01  KC02*/
@property (nonatomic,copy) NSString *deviceType;
@end

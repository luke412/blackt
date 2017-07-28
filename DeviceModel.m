//
//  DeviceModel.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/6.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "DeviceModel.h"

@implementation DeviceModel
-(NSString *)description{
    NSString *string = [NSString stringWithFormat:@"设备名:%@ 衣物mac:%@  衣物类型:%@  设备类型:%@", self.clothesName,self.clothesMac,self.clothesStyle,self.deviceType];
    return string;
}
@end

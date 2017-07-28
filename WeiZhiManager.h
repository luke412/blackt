//
//  WeiZhiManager.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/17.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiZhiManager : DOSingleton
-(void)chuShiHuan;
-(NSString *)getLocationStr;
-(CLLocationCoordinate2D)zuoBiaoZhuanHuan_jingDu:(double)jingDu andWeiDu:(double)weiDu;
@end

//
//  WeiZhiManager.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/17.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "WeiZhiManager.h"

@interface WeiZhiManager () <CLLocationManagerDelegate>
//定位相关
@property(strong,nonatomic)CLLocationManager *locationManager;
@property (nonatomic,assign)double  jingDu;
@property(nonatomic,assign) double  weiDu;
@end


@implementation WeiZhiManager
-(void)chuShiHuan{
    self.locationManager                 = [[CLLocationManager alloc] init];
    self.locationManager.delegate        = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter  = 1000.0f;
    
    if([CLLocationManager   locationServicesEnabled]) {
        
        // 启动位置更新
        
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        
        [self.locationManager  startUpdatingLocation];
    }
    else{
        
        NSLog(@"请开启定位功能！");
    }
}
-(NSString *)getLocationStr{
    return [NSString stringWithFormat:@"%f,%f",_jingDu,_weiDu];
}

#pragma mark - 坐标转换
-(CLLocationCoordinate2D)zuoBiaoZhuanHuan_jingDu:(double)jingDu andWeiDu:(double)weiDu{
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(weiDu, jingDu);//原始坐标
    
    //转换国测局坐标（google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标）至百度坐标
    NSDictionary* testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_COMMON);
    
    //转换WGS84坐标至百度坐标(加密后的坐标)
    testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_GPS);
    
    NSLog(@"x=%@,y=%@",[testdic objectForKey:@"x"],[testdic objectForKey:@"y"]);
    //解密加密后的坐标字典
    CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(testdic);//转换后的百度坐标
    return baiduCoor;
}

#pragma mark - 定位代理
#pragma mark - CLLocationManagerDelegate
//地理位置发生改变时触发
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation

{
    //获取经纬度
    NSLog(@"纬度:%f",newLocation.coordinate.latitude);
    NSLog(@"经度:%f",newLocation.coordinate.longitude);
    _jingDu = newLocation.coordinate.longitude;
    _weiDu  = newLocation.coordinate.latitude;
    
}


//定位失误时触发
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error

{
    NSLog(@"error:%@",error);
    
}

@end

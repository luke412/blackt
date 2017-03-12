//
//  Location_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/27.
//  Copyright © 2016年 鲁柯. All rights reserved.
//  位置界面

#import "Location_ViewController.h"
@interface Location_ViewController ()<CLLocationManagerDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    BMKMapView* mapView;
    BMKLocationService *locService;
}
@end

@implementation Location_ViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"位 置";
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.navigationItem.titleView = title;
    
    [self panDuanWangLuo];
}

-(void)createMap{
    mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, WIDTH_lk, HEIGHT_lk-64-48)];
     mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [self.view addSubview:mapView];
    mapView.showsUserLocation = YES;//显示定位图层 显示当前设备的位置
    //百度定位
    locService = [[BMKLocationService alloc]init];//初始化BMKLocationService
    locService.delegate = self;
    //启动LocationService
    [locService startUserLocationService];

}
-(void)panDuanWangLuo{
        //获取通知中心
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
        [manger startMonitoring];
        //2.监听改变
        [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        
        if (status == AFNetworkReachabilityStatusUnknown) {//未知
            
        }else if(status == AFNetworkReachabilityStatusNotReachable){//没有网络
            dispatch_async(dispatch_get_main_queue(), ^{
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络未连接" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
                                [alertView show];

            });
            
            
        }else if(status == AFNetworkReachabilityStatusReachableViaWWAN){//3G|4G
            
        }else if(status == AFNetworkReachabilityStatusReachableViaWiFi){//wifi
            
        }
        
        
        
    }];
    
    
}

#pragma mark 相关代理方法
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [mapView updateLocationData:userLocation];
    NSLog(@"didUpdateUserLocation 维度: %f,经度 %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    //显示区域
    CLLocationCoordinate2D coor;
    coor.latitude = userLocation.location.coordinate.latitude;
    coor.longitude = userLocation.location.coordinate.longitude;
    BMKCoordinateRegion region = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(0.01f, 0.01f));
    [mapView setRegion:region animated:YES];
    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [mapView updateLocationData:userLocation];
    
}





-(void)viewWillAppear:(BOOL)animated
{
    [mapView viewWillAppear];
    //创建地图
    [self createMap];
   
}
-(void)viewWillDisappear:(BOOL)animated
{
    [mapView viewWillDisappear];
    mapView.delegate = nil; // 不用时，置nil
    [locService stopUserLocationService];
    locService.delegate=nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  AppDelegate.m
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/22.
//  Copyright © 2016年 鲁柯. All rights reserved.
//

#import "AppDelegate.h"
#import "Warm_ViewController.h"    //温暖
#import "Discover_ViewController.h"//发现
#import "My_ViewController.h"      //我的
#import "Location_ViewController.h"//位置

#import "AFHTTPSessionManager.h"


//测试
#import "MyClothes_ViewController.h"
#import "Bound_ViewController.h"

#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()<CLLocationManagerDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
    UITabBarController *tab;
    CLLocationManager * locationManager;
    NSUserDefaults *luke;
    UIImageView *imageV;
}

@end
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //同步数据
    [self Synchrodata];
    
    
    //创建tabar
    [self createTaber];
    
    //判断状态
    [self myJudge];

    
    //百度地图
    [self BaiDuMap];
    
    //蓝牙预处理
    [self BluetoothPretreatment];
    
    //创建配置本地数据库
    [self createDataBase];
    
    //添加监听
    [self addAppObserver];
    
    //开启定位服务，app推到后台后启动
    [self startLocation];
    return YES;
}
-(void)Synchrodata{
   //同步设备名称字典
   [[LKPopupWindowManager sharedInstance] synchronousNameDictionary];
}
-(void)startLocation{
    //定位功能可用，开始定位
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
     [locationManager startUpdatingLocation];
    NSLog(@"授权状态是%d",[CLLocationManager authorizationStatus]);
       if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
                 NSLog(@"是iOS8");
                 // 主动要求用户对我们的程序授权，授权状态改变就会通知代理
                 [locationManager startUpdatingLocation];
                 [locationManager requestAlwaysAuthorization];
             }     
    if ([[luke objectForKey:@"isFirst"]isEqualToString:@"NO"]&&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted
      ||[CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
        ){//拒绝授权或者未被授权
       //定位不可用
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"App需要您的同意,获取定位权限，以便分析当地气候，给出加温方案，保持蓝牙连接" preferredStyle:UIAlertControllerStyleAlert];
               UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"暂时不开" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                        NSLog(@"点击了取消按钮");
                    }];
                UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"去打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
                [alertVc addAction:cancle];
                [alertVc addAction:confirm];
                [self.window.rootViewController presentViewController:alertVc animated:NO completion:^{
            }];
    }
}


-(void)BaiDuMap{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BaiDuMapKey  generalDelegate:nil];
    if (!ret) {
        NSLog(@"百度地图启动失败!");
    }
}
//在此进行一些判断
-(void)myJudge{
    //获取版本号 https://itunes.apple.com/cn/app/blackt/id1169381417?mt=8
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"https://itunes.apple.com/lookup?id=1169381417" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *array = responseObject[@"results"];
        NSDictionary *dict = [array lastObject];
        NSString *versionStr=dict[@"version"];
//        [LKTool LKdictionaryToJson:dict];
        NSLog(@"当前版本为：%@", versionStr);
        NSArray *arr=[versionStr componentsSeparatedByString:@"."];
        versionStr=[arr componentsJoinedByString:@""];
        NSLog(@"当前版本为：%@", versionStr);
        int appStoreVersion = [versionStr intValue];
        if (appStoreVersion > VERSION_NUMBER) {
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                 
                                                          message:@"发现新版本，是否升级"
                                 
                                                         delegate:self
                                 
                                                cancelButtonTitle:@"取消"
                                 
                                                otherButtonTitles:@"升级",nil];
            
            [alert show];

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取版本号失败");
    }];
    
    
    UIApplication *myApplication = [UIApplication sharedApplication];
    // 不隐藏
    [myApplication setStatusBarHidden:NO];
    // 设置为白色
    [myApplication setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    

    luke=[NSUserDefaults standardUserDefaults];
    if (![luke objectForKey:@"isFirst"]) {
        //第一次进入app  通知
        [luke setObject:@"YES" forKey:@"isFirst"];
        [luke synchronize];
        
        //显示引导页
        [self showFirstView];
    }else{
        [luke setObject:@"NO"  forKey:@"isFirst"];
        [luke synchronize];
    }
}
-(void)showFirstView{
    imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_lk, HEIGHT_lk)];
    imageV.userInteractionEnabled = YES;
    imageV.image = [UIImage imageNamed:@"第一次进入"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFirstImageV)];
    tap.delegate = self;
    [imageV addGestureRecognizer:tap];
    [self.window addSubview:imageV];
}
-(void)tapFirstImageV{
    [imageV removeFromSuperview];
}
-(void)createTaber{
    Warm_ViewController      *warm       =[[Warm_ViewController alloc]init];
    Discover_ViewController  *discover   =[[Discover_ViewController alloc]init];
    My_ViewController        *my         =[[My_ViewController alloc]init];
    
    UINavigationController   *nav1=[[UINavigationController alloc]initWithRootViewController:warm];
    UINavigationController   *nav2=[[UINavigationController alloc]initWithRootViewController:discover];
    UINavigationController   *nav4=[[UINavigationController alloc]initWithRootViewController:my];
    warm.title      =@"温暖";
    discover.title  =@"发现";
    my.title        =@"我的";
    tab=[[UITabBarController alloc]init];
    tab.viewControllers=@[nav1,nav2,nav4];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[LKTool from_16To_Color:@"666666"]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[LKTool from_16To_Color:NAV_COLOR]} forState:UIControlStateSelected];
    
     [[UITabBar appearance] setTintColor:[UIColor blueColor]];
    
    //设置tabar图片
    UITabBar *tabar=tab.tabBar;
    UITabBarItem *item1=tabar.items[0];
    UITabBarItem *item2=tabar.items[1];
    UITabBarItem *item4=tabar.items[2];
    
    item1.image=[UIImage imageNamed:@"温暖"];
    item2.image=[UIImage imageNamed:@"发现"];
    item4.image=[UIImage imageNamed:@"我的"];

    item1.selectedImage=[UIImage imageNamed:@"温暖选中2"];
    item2.selectedImage=[UIImage imageNamed:@"发现选中2"];
    item4.selectedImage=[UIImage imageNamed:@"我的选中2"];
    
    //设置图片渲染模式
    for (UITabBarItem *item in tabar.items) {
        item.image         =[item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage =[item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    
    self.window.rootViewController=tab;
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

-(void)BluetoothPretreatment{
    [[HeatingClothesBLEService sharedInstance] setupService];
    [[HeatingClothesBLEService sharedInstance] initCacheDictionary];
    [[LGCentralManager sharedInstance] scanForPeripheralsByInterval:1
                                                         completion:^(NSArray *peripherals)
     {
         // 如果我们发现外围设备，就去测试
         NSLog(@"AppDelegate:发现设备 %d个",peripherals.count);
         NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
         BOOL isFound=NO;
         for (LGPeripheral *peripheral in peripherals) {
             NSArray *array1 = [peripheral.name componentsSeparatedByString:@"#0x"];
             NSString *mac=array1[1]?array1[1]:@"";
             NSLog(@"AppDelegate 收到mac：%@",mac);
             
         }
    }];
}


#pragma mark - 弹窗代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    if (buttonIndex==0) {
        //取消
    }else if (buttonIndex==1){
        //升级
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/shan-shan-pen-di-fu-nu-jian/id1169381417?mt=8"]];
    }
    
}
-(void)addAppObserver{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(BluetoothPowerOff) name:@"BluetoothOff" object:nil];
}
/*  场景：手机蓝牙关闭
 *  行为：1.清除缓存的所有设备信息和特性，恢复到连接之前的状态
 *       2.弹窗提醒用户
 */
-(void)BluetoothPowerOff{
    HeatingClothesBLEService *BLEService=[HeatingClothesBLEService sharedInstance];
    [BLEService.peripheralsDictionary              removeAllObjects];
    [BLEService.sendDataCharacteristicDictionary   removeAllObjects];
    [BLEService.reciveDataCharacteristicDictionary removeAllObjects];

}
-(void)createDataBase{
    //判断是否为第一次进入
    NSString *isFrist=[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirst"];
    if ([isFrist isEqualToString:@"YES"]) {
        NSLog(@"您是第一次登陆");
    }else{
        NSLog(@"您不是第一次登陆");
    }
    

    [[LKDataBaseTool sharedInstance] createDataBaseAndCreateTable];
}
//程序将要主动进入后台
-(void)applicationWillResignActive:(UIApplication *)application{


    //停止心跳
    [[HeatingClothesBLEService sharedInstance] stopTheHeart];
}
#pragma mark-CLLocationManager代理方法
//定位失败时调用的方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(nonnull NSError *)error{
    NSLog(@"后台定位失败%@",error);
    //断开连接 ，清除设备
    [[HeatingClothesBLEService sharedInstance].peripheralsDictionary removeAllObjects];
    [[HeatingClothesBLEService sharedInstance].sendDataCharacteristicDictionary   removeAllObjects];
    [[HeatingClothesBLEService sharedInstance].reciveDataCharacteristicDictionary removeAllObjects];
    //停止心跳
    [[HeatingClothesBLEService sharedInstance] stopTheHeart];
}
//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"后台定位成功! 定时器%@",[HeatingClothesBLEService sharedInstance].timer);
    //开启后台计时器
    if ([HeatingClothesBLEService sharedInstance].timer==nil) {
       NSLog(@"后台定位成功，启动心跳");
       [[HeatingClothesBLEService sharedInstance] startTheHeart];
    }
}
//程序已经切入后台
-(void)applicationDidEnterBackground:(UIApplication *)application{
   [locationManager startUpdatingLocation];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted
        ||[CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        
        return;//如果没有定位权限就跳过
    }

    
    
    
    HeatingClothesBLEService *myService= [HeatingClothesBLEService sharedInstance];
    NSTimer *timerTemp=myService.timer;
    if (timerTemp == nil) {
        [[HeatingClothesBLEService sharedInstance]startTheHeart];//启动心跳
        NSLog(@"程序切入后台时，计时器已创建，后台心跳机制开启");
    }
    
    
    
}
//应用程序将切入后台
-(void)applicationWillEnterForeground:(UIApplication *)application{
     NSLog(@"1");

}
//应用程序已活跃
-(void)applicationDidBecomeActive:(UIApplication *)application{
//    [locationManager stopUpdatingHeading];
    NSLog(@"停止定位");
    HeatingClothesBLEService *myService= [HeatingClothesBLEService sharedInstance];
    NSTimer *timerTemp=myService.timer;
            if (timerTemp == nil) {
            [[HeatingClothesBLEService sharedInstance]startTheHeart];//启动心跳
            NSLog(@"计时器已创建，前端心跳机制开启");
    }
}

//应用程序将终止
- (void)applicationWillTerminate:(UIApplication *)application{
     NSLog(@"5");
}
@end

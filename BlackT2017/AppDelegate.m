//
//  AppDelegate.m
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/22.
//  Copyright © 2016年 鲁柯. All rights reserved.
//
#import <Bugly/Bugly.h>    //crash上报

#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"
#import <CoreLocation/CoreLocation.h>
#import "AvoidCrash.h"
#import "NSArray+AvoidCrash.h"
#import "DataBaseManager.h"
#import "WeiZhiManager.h"
#import "QiDongYeModel.h"


//界面
#import "Main_ViewController.h"
#import "FaXian_ViewController.h"
#import "WoDe_ViewController.h"
#import "Log_ViewController.h"
#import "test_ViewController.h"
#import "BaiduTraceSDK/BaiduTraceSDK.h"


//测试界面
#import "BoundSetName_ViewController.h"
#import "LianJieJianCe_ViewController.h"

@interface AppDelegate ()<CLLocationManagerDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
    UITabBarController *tab;
    CLLocationManager  *locationManager;
    NSUserDefaults     *luke;
    UIImageView        *imageV;
    
    Main_ViewController *main;
    WoDe_ViewController *wode;
    FaXian_ViewController *faxian;
}
@property(nonatomic,copy)NSString *tongZhiCaheStr;

@end
@implementation AppDelegate
- (void)dealwithCrashMessage:(NSNotification *)note {
    //不论在哪个线程中导致的crash，这里都是在主线程
    //注意:所有的信息都在userInfo中
    //你可以在这里收集相应的崩溃信息进行相应的处理(比如传到自己服务器)
    NSLog(@"\n\n在AppDelegate中 方法:dealwithCrashMessage打印\n\n\n\n\n%@\n\n\n\n",note.userInfo);
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    NSString *state = [UserDefaultsUtils getObjectWithKey:isFirst];
    if (state == nil ) {
         [UserDefaultsUtils saveValue:@"YES" forKey:isFirst];
    }else{
         [UserDefaultsUtils saveValue:@"NO" forKey:isFirst];
    }
    
    
    //启动防止崩溃功能
    [AvoidCrash becomeEffective];

    //监听通知:AvoidCrashNotification, 获取AvoidCrash捕获的崩溃日志的详细信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];

    //初始化腾讯bugly (生产环境启用)
    if (isdeBug == LKproduction) {
       [Bugly startWithAppId:BUGLY_KEY];
    }

    
    //友盟推送
    [self setYouMengWith:launchOptions];

    
    //创建tabar
    UIApplication *myApplication = [UIApplication sharedApplication];
    // 不隐藏
    [myApplication setStatusBarHidden:NO];
    // 设置为黑色 状态栏
    [myApplication setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

    //创建数据库表
    [DataBase_Manager createDataBaseAndCreateTable];
    
    
    //拉取伪启动页
    [self loadQiDongYe];

   
    
   
    
    //蓝牙预处理
    [self BluetoothPretreatment];
    
    //百度地图
    [self BaiDuMap];
    
    //使用SDK的任何功能前，都需要先调用initInfo:方法设置基础信息。
    BTKServiceOption *sop = [[BTKServiceOption alloc] initWithAK:BaiDuMapKey
                                                           mcode:@"cn.aikalife.AIKAHeatingClothes.blacktZJB"
                                                       serviceID:BaiDuYingYanSeverID
                                                       keepAlive:false];
    [[BTKAction sharedInstance] initInfo:sop];
    
    
    
    //初始化
    [self chuShiHua];
    return YES;
}
-(void)chuShiHua{
    [App_Manager Initialization];
    [WeiZhi_Manager chuShiHuan];
}

#pragma mark - 定位相关
-(void)weiZhiWindow{
    
    //位置不可用
    if (([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied||
         [ CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted
         ||[CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
        ){
        LKLog(@"拒绝授权或者未被授权");
        [Win_Manager showWeiZhiWindow_weiZhiYes:^{
                                        //是不是第一次使用
                                        if ([[UserDefaultsUtils getObjectWithKey:@"isFirst"]isEqualToString:@"NO"]) {
                                            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                                [[UIApplication sharedApplication] openURL:url];
                                            }
                                        }
                                         [self startLocation];
                                    } weiZhiNo:^{
                                         [self startLocation];
                                    }];
        
    }
    //位置可用
    else{
        [self startLocation];
    }
}

-(void)startLocation{
    
    
    //定位功能可用，开始定位
    locationManager                 = [[CLLocationManager alloc] init];
    locationManager.delegate        = self;
    locationManager.distanceFilter  = kCLDistanceFilterNone;//实时更新定位位置
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;//定位精确度
    if([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
        [locationManager requestAlwaysAuthorization];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
        locationManager.allowsBackgroundLocationUpdates = YES;
    }
    
    //该模式是抵抗程序在后台被杀，申明不能够被暂停
    locationManager.pausesLocationUpdatesAutomatically = NO;
    
    //3.设置代理
    locationManager.delegate = self;
    //4.开始定位
    [locationManager startUpdatingLocation];
    //5.获取朝向
    [locationManager startUpdatingHeading];
    
    if ([[luke objectForKey:@"isFirst"]isEqualToString:@"NO"]&&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied||
         [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted
         ||[CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
        ){//拒绝授权或者未被授权
        LKLog(@"拒绝授权或者未被授权");
        
    }
}


#pragma mark - CLLocationManager代理方法
//程序将要主动进入后台
-(void)applicationWillResignActive:(UIApplication *)application{
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [locationManager startUpdatingLocation];
}
//定位失败时调用的方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(nonnull NSError *)error{
    LKLog(@"后台定位失败%@",error);
    //断开连接 ，清除设备
    [[HeatingClothesBLEService sharedInstance].peripheralsDictionary              lk_removeAllObjects];
    [[HeatingClothesBLEService sharedInstance].sendDataCharacteristicDictionary   lk_removeAllObjects];
    [[HeatingClothesBLEService sharedInstance].reciveDataCharacteristicDictionary lk_removeAllObjects];
    
}
//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    LKLog(@"定位成功11222");
    
}

#pragma mark - 友盟的一些设置
-(void)setYouMengWith:(NSDictionary *)launchOptions{
    [UMessage startWithAppkey:YouMengKeY launchOptions:launchOptions httpsEnable:YES];
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    //打开日志，方便调试
    //初始化腾讯bugly (生产环境启用)
    if (isdeBug == LKdebug) {
        [UMessage setLogEnabled:YES];
    }
    NSString *userId = [App_Manager getUserId];
    
    //别名
    [UMessage addAlias:userId
                  type:kUMessageAliasTypeQQ
              response:^(id responseObject, NSError *error) {
        NSDictionary *dic = responseObject;
        LKLog(@"友盟别名错误:%@   别名为:%@  字典：%@",error ,userId,dic);
    }];
    [UMessage openDebugMode:YES];
    
}



#pragma mark - 通知相关
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    [UMessage registerDeviceToken:deviceToken];
    NSLog(@"hahaha :%@",deviceToken);
    [UMessage setAutoAlert:NO];
}
//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [UMessage didReceiveRemoteNotification:userInfo];
    [UMessage setAutoAlert:NO];
    
    //接收推送并处理
    [self doJobNotificationWith:userInfo];
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        //接收并处理通知
        [self doJobNotificationWith:userInfo];
    }else{
        //应用处于前台时的本地推送接受
        [self doJobNotificationWith:userInfo];
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage setAutoAlert:NO];
        [UMessage didReceiveRemoteNotification:userInfo];
        [self doJobNotificationWith:userInfo];
    }else{
        //应用处于后台时的本地推送接受
        [self doJobNotificationWith:userInfo];
    }
}
#pragma mark - 消息推送处理
-(void)doJobNotificationWith:(NSDictionary *)userInfo{
    //接受处理通知信息
    NSDictionary *apsDic  = [userInfo objectForKey:@"aps"];
    NSDictionary *bodyDic = [apsDic objectForKey:@"alert"];
    [LKTool logDic:userInfo];
    NSLog(@"推送消息的主体是:%@",bodyDic);
    NSString *body;
     if ([bodyDic isKindOfClass:[NSMutableDictionary class]] || [bodyDic isKindOfClass:[NSDictionary class]]) {
              body = bodyDic[@"body"];
    }
    if ([bodyDic isKindOfClass:[NSString class]] || [bodyDic isKindOfClass:[NSMutableString class]]) {
        body =[apsDic objectForKey:@"alert"];
    }
    
    
    //发送通知进入消息页
    NSString *titleStr          = body;
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy年MM月dd日 HH时mm分$ss秒"];
    NSString *currentDateStr    = [dateFormat stringFromDate:[NSDate date]];
    NSArray *arr2               = [currentDateStr componentsSeparatedByString:@"$"];
    NSString *timeStr           = [arr2 firstObject];
    
    
    MessageModel *model         = [[MessageModel alloc]init];
    model.title                 = titleStr;
    model.text                  = body;
    model.timeStr               = timeStr;
    model.idStr                 = currentDateStr;
    model.isRead                = @"NO";
    
    
    @try {
        model.activeUserIdKey = [userInfo objectForKey:@"activeUserIdKey"];
        model.createTimeKey   = [userInfo objectForKey:@"createTimeKey"];
        model.descriptionKey  = [userInfo objectForKey:@"descriptionKey"];
        model.headlineKey     = [userInfo objectForKey:@"headlineKey"];
        model.introPicKey     = [userInfo objectForKey:@"introPicKey"];
        
        model.customKey       = [userInfo objectForKey:@"customKey"];
        model.customUrlKey    = [userInfo objectForKey:@"customUrlKey"];
        model.diagnosisId     = [userInfo objectForKey:@"diagnosisId"];
    } @catch (NSException *exception) {
        LKLog(@"异常%@",exception.name);
    } @finally {
        
    }
    //存储到数据库
    [DataBase_Manager lk_saveMessageToDataBase:model];
    
    //程序在前台运行，并且通知没重复
    //if([UIApplication sharedApplication].applicationState == UIApplicationStateActive && ![_tongZhiCaheStr isEqualToString:body])
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        _tongZhiCaheStr = body;
        if (model.customKey && [model.customKey isEqualToString:@"C11"]) {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            NSNotification *notify   = [[NSNotification alloc]initWithName:TongZhi_tongZhi object:model userInfo:nil];
            [nc postNotification:notify];
            return;
        }
        
        if (model.customKey && [model.customKey isEqualToString:@"C12"]) {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            NSNotification *notify   = [[NSNotification alloc]initWithName:TongZhi_tongZhi object:model userInfo:nil];
            [nc postNotification:notify];
            return;
        }
        
        LKAlertController *alertVc = [LKAlertController alertControllerWithTitle:LK(@"通知")
                                                                         message:LK(@"通知")
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        alertVc.text = body;
                UIAlertAction *cancle = [UIAlertAction actionWithTitle:LK(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){  }];
                [alertVc addAction:cancle];
                UIAlertAction *queDing = [UIAlertAction actionWithTitle:LK(@"查看") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                        NSNotification *notify   = [[NSNotification alloc]initWithName:TongZhi_tongZhi object:model userInfo:nil];
                        [nc postNotification:notify];
                    }];
            [alertVc addAction:queDing];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVc animated:YES completion:^{ }];
    }
    //后台进入
    if([UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
    {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        NSNotification *notify   = [[NSNotification alloc]initWithName:TongZhi_tongZhi object:model userInfo:nil];
        [nc postNotification:notify];
    }
}


#pragma mark - 去首页
-(void)goToMainViewController{
    
    main   = [[Main_ViewController alloc]init];
    faxian = [[FaXian_ViewController alloc]init];
    wode   = [[WoDe_ViewController alloc]init];
    
    //测试界面
    test_ViewController *vc = [[test_ViewController alloc]init];
    LianJieJianCe_ViewController *test = [[LianJieJianCe_ViewController alloc]init];

    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:main];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:faxian];
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:wode];

    tab                          = [[UITabBarController alloc]init];
    tab.viewControllers          = @[nav1,nav2,nav3];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[LKTool from_16To_Color:@"666666"]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[LKTool from_16To_Color:NAV_COLOR]} forState:UIControlStateSelected];
    [[UITabBar appearance] setTintColor:[UIColor blueColor]];
        //设置tabar图片
          UITabBar *tabar     = tab.tabBar;
          UITabBarItem *item0 = tabar.items[0];
          UITabBarItem *item1 = tabar.items[1];
          UITabBarItem *item2 = tabar.items[2];

        item0.image=[UIImage imageNamed:@"tab自助调温"];
        item1.image=[UIImage imageNamed:@"tab发现"];
        item2.image=[UIImage imageNamed:@"tab我的"];

        item0.selectedImage=[UIImage imageNamed:@"tab自助调温_选中"];
        item1.selectedImage=[UIImage imageNamed:@"tab发现_选中"];
        item2.selectedImage=[UIImage imageNamed:@"tab我的_选中"];
        
        //设置图片渲染模式
        for (UITabBarItem *item in tabar.items) {
            item.image         =[item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            item.selectedImage =[item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
         }
    self.window.rootViewController = tab;
    self.window.backgroundColor    = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    //开启蓝牙
    if ([[LGCentralManager sharedInstance].stateMessage isEqualToString:@"蓝牙关闭状态"]) {
        [Win_Manager showBlueWindow_blueYes:^{
            //跳到蓝牙设置界面
            NSURL *url = [NSURL URLWithString:@"prefs:root=Bluetooth"];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
            //开启定位
            [self weiZhiWindow];
        }blueNo:^{
            //开启定位
            [self weiZhiWindow];
        }];
    }else{
        //开启定位
        [self weiZhiWindow];
    }

    
}


#pragma mark - 去登录页
-(void)goToLogViewController{
    Log_ViewController *vc         = [[Log_ViewController alloc]init];
    self.window.rootViewController = vc;
    self.window.backgroundColor    = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //开启蓝牙
    if ([[LGCentralManager sharedInstance].stateMessage isEqualToString:@"蓝牙关闭状态"]) {
        [Win_Manager showBlueWindow_blueYes:^{
            //跳到蓝牙设置界面
            NSURL *url = [NSURL URLWithString:@"prefs:root=Bluetooth"];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
            //开启定位
            [self weiZhiWindow];
        }blueNo:^{
            //开启定位
            [self weiZhiWindow];
        }];
    }else{
        //开启定位
        [self weiZhiWindow];
    }

}

#pragma mark - 蓝牙初始化
-(void)BluetoothPretreatment{
    [[HeatingClothesBLEService sharedInstance] setupService];
    [[LGCentralManager sharedInstance] scanForPeripheralsByInterval:1
                                                         completion:^(NSArray *peripherals)
     {
         
     }];
}
#pragma mark - 伪启动页
-(void)loadQiDongYe{
    NSString *userid    = [App_Manager getUserId];
    NSString *userToken = [App_Manager getUserToken];
    NSString *deviceid  = [App_Manager getDeviceId];
    if (!userid || !userToken  || !deviceid  ||userid.length<1  ||userToken.length<1 ) {
        [self  goToLogViewController];
        return;
    }
    
    //拉取启动页信息
    [NetWork_Manager weiQiDongYe_userId:userid
                              userToken:userToken
                               deviceId:deviceid
                                Success:^(QiDongYeModel *model) {
                                    [UserDefaultsUtils saveQiDongYe_Model:model];
                                    //首页
                                    if (model) {
                                        //显示启动页
                                        [Win_Manager showQiDongYe_imagePath:model.adPicture
                                                                   duration:model.showSeconds
                                                               TiaoGuoBlock:^{//跳过
                                                                   LKLog(@"跳过");
                                                                   [self goToMainViewController];
                                                               } WanChengBlock:^{//完成
                                                                   LKLog(@"完成");
                                                                   [self goToMainViewController];
                                                               } TimeOutBlock:^{//超时
                                                                   LKLog(@"超时");
                                                                   [self goToMainViewController];
                                                               }];
                                    }else{
                                        [self goToMainViewController];
                                    }
                                } Abnormal:^(id responseObject) {
                                     [self goToMainViewController];
                                } Failure:^(NSError *error) {
                                     [self goToMainViewController];
                                }];
}



#pragma mark - 百度地图
-(void)BaiDuMap{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret    = [_mapManager start:BaiDuMapKey  generalDelegate:nil];
    if (!ret) {
        LKLog(@"百度地图启动失败!");
    }

}

//程序将要主动进入后台
#pragma mark-CLLocationManager代理方法
//程序已经切入后台
-(void)applicationDidEnterBackground:(UIApplication *)application{

    
}
//应用程序将切入后台
-(void)applicationWillEnterForeground:(UIApplication *)application{

}
//应用程序已活跃
-(void)applicationDidBecomeActive:(UIApplication *)application{
    
}

//应用程序将终止
- (void)applicationWillTerminate:(UIApplication *)application{
}
@end

//
//  Main_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/4.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  首页  温暖界面

#import "Main_ViewController.h"
//界面
#import "SheBeiGuanLi_ViewController.h"
#import "TianJia_ViewController.h"
#import "YiJianPlanXiangQing_ViewController.h"

//模型
#import "BlueManager.h"
#import "Main_Handler.h"
#import "ZiZhuManager.h"
#import "CowManager.h"
#import "DataBaseManager.h"
#import "YiJianManager.h"
#import "YiJianPlanModel.h"
#import "YiJianPlanListModel.h"

//控件
#import "LKView.h"
#import "LKNiuView.h"
#import "DingShiView.h"
#import "DingShiView.h"
#import "SwitchView.h"
#import "DingShiScrollow.h"

//异常
#import "YiChangManager.h"

@interface Main_ViewController () <LKViewDelegate,SwitchViewDelegate,DingShiViewDelegate,ZiZhuManagerDelegate,CLLocationManagerDelegate>
@property (nonatomic,strong ) LKView              *yuanView;//圆环
@property(nonatomic, strong ) DingShiView         *dingShiView;
@property (nonatomic,strong ) LKNiuView           *niuBtn;
@property (nonatomic,strong ) LKButton            *niuCovBtn;

@property (nonatomic,strong ) SwitchView          *switchView;
@property (nonatomic,strong ) DingShiScrollow     *yuanScrollView;

@property (nonatomic,strong) NSTimer              *timer;
@property (nonatomic,assign) NSInteger             seconds;

//执行者
@property(nonatomic,strong)Main_Handler *mainHandler;

//定位相关
@property (strong,nonatomic ) CLLocationManager *locationManager;
@property (nonatomic,assign ) double            jingDu;
@property (nonatomic,assign ) double            weiDu;

@property(nonatomic,strong)UIBarButtonItem *rightItem;
@property(nonatomic,strong)UIBarButtonItem *rightItem2;
@property(nonatomic,strong)UIBarButtonItem *fixedSpaceBarButtonItem;
@end

@implementation Main_ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self.locationManager  startUpdatingLocation];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    [self setTittleWithText:@"自助调温"];

    
    //kvo
    [App_Manager addObserver:self forKeyPath:@"heatState" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    _mainHandler = [[Main_Handler  alloc]init];
    [ZiZhuManager sharedInstance].delegate = self;
    self.navigationItem.rightBarButtonItems = @[self.rightItem,self.fixedSpaceBarButtonItem];

   

    //添加控件
    [self.view addSubview:self.yuanView];
    [self.view addSubview:self.niuBtn];
    [self.view addSubview:self.niuCovBtn];
    [self.view addSubview:self.dingShiView];
    [self.view addSubview:self.switchView];
    
    //监听
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(BindingSuccess) name:BindingSuccess_tongZhi object:nil];
    [nc addObserver:self selector:@selector(UMPushTongZhi:) name:TongZhi_tongZhi object:nil];
    
    //计时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(everyTime) userInfo:nil repeats:YES];
     [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    _seconds = 0;
    

    //用户位置获取
    self.locationManager                 = [[CLLocationManager alloc] init];
    self.locationManager.delegate        = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter  = 1000.0f;//
    
    
    if([CLLocationManager   locationServicesEnabled]) {
        // 启动位置更新
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        [self.locationManager  startUpdatingLocation];
    }
    
    else{
        NSLog(@"请开启定位功能！");
    }
    
    //加载我的信息
    [self loadMyInfo];

}
-(void)loadMyInfo{
    NSString *userid = [App_Manager getUserId];
    NSString *usertoken = [App_Manager getUserToken];
    NSString *deviceid  = [App_Manager getDeviceId];
    
    [NetWork_Manager getMyUserInfo_userId:userid
                                userToken:usertoken
                                 deviceId:deviceid
                                  Success:^(UserInfoModel *infoModel) {
                                      App_Manager.currUserInfo = infoModel;
                                       [UserDefaultsUtils saveUserInfo_UserModel:infoModel];
                                  } Abnormal:^(id responseObject) {
                                      
                                  } Failure:^(NSError *error) {
                                      
                                  }];
    
}

#pragma mark - 定位相关代理
//地理位置发生改变时触发
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation

{
    //获取经纬度
    NSLog(@"纬度:%f",newLocation.coordinate.latitude);
    NSLog(@"经度:%f",newLocation.coordinate.longitude);
    _jingDu = newLocation.coordinate.longitude;
    _weiDu  = newLocation.coordinate.latitude;
    
    
    //每日联网上报
    NSString *userId                = [App_Manager getUserId];
    NSString *userToken             = [App_Manager getUserToken];
    NSString *deviceId              = [App_Manager getDeviceId];
    NSString *geographicCoordinates = [NSString stringWithFormat:@"%f,%f",_jingDu,_weiDu];
    //手机型号
    NSString *phoneModel            = [App_Manager iphoneType];//[[UIDevice currentDevice] model];
    //手机系统版本
    NSString* phoneVersion          = [[UIDevice currentDevice] systemVersion];
    [NetWork_Manager meiRiShangBo_userId:userId
                               userToken:userToken
                                deviceId:deviceId
                   geographicCoordinates:geographicCoordinates
                              phoneModel:phoneModel
                             phoneSystem:phoneVersion
                                 Success:^(id responseObject) {
                                     LKLog(@"%@",responseObject);
                                 } Abnormal:^(id responseObject) {
                                     LKLog(@"%@",responseObject);
                                 } Failure:^(NSError *error) {
                                     
                                 }];

    
    
    //停止位置更新
    [manager   stopUpdatingLocation];
}

//定位失误时触发
-(void)locationManager:(CLLocationManager
                        *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
    
}




#pragma mark- 计时器
-(void)everyTime{
    _seconds +=1;
    LKLog(@"首页计时器:%ld",_seconds);
    if (_seconds == 20) {
        NSInteger currTemp =  [Blue_Manager readCurrTemp_Mac:App_Manager.currDevice.clothesMac];
        [self.niuBtn showTempText:[NSString stringWithFormat:@"%ld℃",currTemp] userState:App_Manager.heatState];
    }
    
    else if (_seconds >=25) {
        _seconds = 0;
    }
    
    else if(_seconds>0 && _seconds <20){
        [self.niuBtn showStateText:App_Manager.heatState];
    }
}
#pragma mark - 用户事件
-(void)huoMiaoClick{
    YiJianPlanModel *model             = YiJian_Manager.currPlan;
    YiJianPlanXiangQing_ViewController *vc = [[YiJianPlanXiangQing_ViewController alloc]init];
    vc.schemeId                            = model.schemeId;
    vc.titleText                           = model.schemeName;
    vc.imagePath                           = model.drugbagLocationPic;
    [self.navigationController pushViewController:vc animated:NO];
}
-(void)rightButtonClick{
    SheBeiGuanLi_ViewController *vc = [[SheBeiGuanLi_ViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}

//点击小牛
-(void)cowClick{
    if (App_Manager.heatState == WuCaoZuo_heat) {
        DeviceModel *device = App_Manager.currDevice;
        LKShow(@"正在连接...");
        [_mainHandler FirstConnect_mac:device.clothesMac
                                Sucess:^(NSString *mac) {
                                    LKRemove;
                                    [ZiZhu_Manager run_dingShiSeconds:MAX_UPSCALE];
                                    [Cow_Manager     cowClick_device:App_Manager.currDevice
                                                           heatState:App_Manager.heatState
                                                             Success:^(NSInteger currTemp, NSInteger currMuBiaoTemp) {
                                                                [self.niuBtn showInfo_currTemp:currTemp
                                                                                  MuBiaoTemp:currMuBiaoTemp
                                                                                  HeatState:App_Manager.heatState];
                                                            }failure:^{
                                                            
                                                            }];
                                } Failure:^(NSString *mac) {
                                      LKRemove;
                                    [self showStopFace];
                                    [MBProgressHUD showError:@"连接失败"];
                                } andIsRunDelegate:NO];
        
        return;
    }
    [Cow_Manager cowClick_device:App_Manager.currDevice
                       heatState:App_Manager.heatState
                        Success:^(NSInteger currTemp, NSInteger currMuBiaoTemp) {
                                [self.niuBtn showInfo_currTemp:currTemp
                                                    MuBiaoTemp:currMuBiaoTemp
                                                     HeatState:App_Manager.heatState];
                        } failure:^{
                            
                        }];
}
#pragma mark - 通知
-(void)BindingSuccess{
    //连接当前设备
    DeviceModel *device = App_Manager.currDevice;
    [_mainHandler FirstConnect_mac:device.clothesMac
                            Sucess:^(NSString *mac) {
                                [ZiZhu_Manager run_dingShiSeconds:MAX_UPSCALE];
                            } Failure:^(NSString *mac) {
                                
                            } andIsRunDelegate:YES];
}
-(void)UMPushTongZhi:(NSNotification *)notify{
    MessageModel *message = notify.object;
    if ([message.customKey isEqualToString:@"C11"]) {
        NSString *text = message.text;
        [Win_Manager showFriendRequestWindow_text:text
                                           TongYi:^{
                                               [self addFriendRequest_isOK:YES andMessage:message];
                                           } ZaiXiang:^{
                                               [self addFriendRequest_isOK:NO andMessage:message];
                                           }];
    }
    //响应添加好友
    else if ([message.customKey isEqualToString:@"C12"]) {
        NSString *text = message.text;
        [Win_Manager friendTongYiWindow_text:text lookBlock:^{
            
        }];
    }
}
#pragma mark - 添加好友响应，网络请求
-(void)addFriendRequest_isOK:(BOOL)isOk andMessage:(MessageModel *)model{
    NSString *userid = [App_Manager getUserId];
    NSString *userToken = [App_Manager getUserToken];
    NSString *deviceid  = [App_Manager getDeviceId];
    NSInteger activeUserId = [model.activeUserIdKey integerValue];
    NSInteger decision;
    if (isOk) {
        decision = 0;
    }else{
        decision = 1;
    }
    LKShow(@"正在处理...");
    [NetWork_Manager addFriendResponse_userId:userid
                                    userToken:userToken
                                     deviceId:deviceid
                                 activeUserId:activeUserId
                                     decision:decision
                                      Success:^(id responseObject) {
                                           LKRemove;
                                          if (decision == 0) {
                                              [MBProgressHUD showSuccess:@"添加成功"];
                                          }else{
                                          [MBProgressHUD showSuccess:@"操作成功"];
                                          }
                                          
                                      } Abnormal:^(id responseObject) {
                                           LKRemove;
                                          [MBProgressHUD showError:responseObject[@"retMsg"]];
                                      } Failure:^(NSError *error) {
                                          LKRemove;
                                          [MBProgressHUD showError:@"网络开小差~\(≧▽≦)/"];
                                      }];
}


#pragma mark - 代理
-(void)dingClick{
    self.tabBarController.tabBar.hidden = YES;
    LKButton *mengBan       = [[LKButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH_lk, HEIGHT_lk)];
    mengBan.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:mengBan];
    __weak typeof (self)weakself = self;
    [mengBan lk_addActionforControlEvents:UIControlEventTouchUpInside ActionBlock:^{
        [mengBan removeFromSuperview];
        weakself.tabBarController.tabBar.hidden = NO;
        [_yuanScrollView removeFromSuperview];
    }];
    self.yuanScrollView                               = [[DingShiScrollow alloc]initWithFrame:CGRectMake(0, HEIGHT_lk, WIDTH_lk, 200)];
    _yuanScrollView.backgroundColor                   = [UIColor whiteColor];
    _yuanScrollView.userInteractionEnabled            = YES;
    __weak typeof (_yuanScrollView)weakYuanScrollView = _yuanScrollView;
    __weak typeof (_mainHandler)weakmainHandler       = _mainHandler;
    _yuanScrollView.myQueDingBlock = ^(NSString *timeStr){
        if (App_Manager.heatState != Zizhu_heat) {
            [MBProgressHUD showError:@"设置失败"];
            return;
        }
        
        [weakmainHandler userDingShi_timeStr:timeStr
                                    complete:^(int minInt) {
                                        if (minInt != MAX_UPSCALE) {
                                            [[ZiZhuManager sharedInstance] run_dingShiSeconds:minInt*60];
                                        }else if (minInt == MAX_UPSCALE){
                                            [[ZiZhuManager sharedInstance] run_dingShiSeconds:MAX_UPSCALE];
                                        }
                                    }];
        [mengBan removeFromSuperview];
        weakself.tabBarController.tabBar.hidden = NO;
        [weakYuanScrollView removeFromSuperview];
    };
    [mengBan addSubview:_yuanScrollView];
    [UIView animateWithDuration:0.3 animations:^{
        _yuanScrollView.frame = CGRectMake(0, HEIGHT_lk-200, WIDTH_lk, 200);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)switchClick:(LKButton *)kaiGuanBtn{
    if (kaiGuanBtn.isOn == YES) {
        //连接蓝牙
        [self showConnectingFace];
        DeviceModel *device = App_Manager.currDevice;
        [_mainHandler FirstConnect_mac:device.clothesMac
                                Sucess:^(NSString *mac) {
                                    [[ZiZhuManager sharedInstance] run_dingShiSeconds:MAX_UPSCALE];
                                } Failure:^(NSString *mac) {
                                    [self showStopFace];
                                    [MBProgressHUD showError:@"连接失败"];
                                } andIsRunDelegate:YES];
    }else{
        [ZiZhu_Manager end];
        [Win_Manager stopHeat_Stop:^{
             [self showStopFace];
             kaiGuanBtn.isOn = NO;
        } JiXu:^{
             kaiGuanBtn.isOn = YES;
        }];
    }
   
}


//点击连接
-(void)ConnectClick{
    NSArray *devices = [DataBase_Manager getAllBoundDevice];
    if (devices.count < 1) {
        [MBProgressHUD showError:@"请先绑定设备"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            TianJia_ViewController *vc = [[TianJia_ViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        });
    }else{
        //连接蓝牙
        [self showConnectingFace];
        DeviceModel *device = App_Manager.currDevice;
        [_mainHandler FirstConnect_mac:device.clothesMac
                                Sucess:^(NSString *mac) {
                                    [ZiZhu_Manager run_dingShiSeconds:MAX_UPSCALE];
                                    
                                } Failure:^(NSString *mac) {
                                    [self showStopFace];
                                    YiChangManager *yichangManger = [[YiChangManager alloc]init];
                                    yichangManger.successBlock = ^(NSString *mac) {
                                        [ZiZhu_Manager run_dingShiSeconds:MAX_UPSCALE];
                                        [self showHeatingFace_targetTemp:50 andRestSeconds:MAX_UPSCALE];
                                    };
                                    [yichangManger showViewControllers_vc:self];
                                    [MBProgressHUD showError:@"连接失败"];
                                } andIsRunDelegate:YES];
    }
}

//非自助调温状态LKView接受到事件
-(void)disconnectStateEvent{
        YiJianPlanModel *currModel = YiJian_Manager.currPlan;
        NSString *name             = currModel.schemeName;
    
        [Win_Manager showTuiChuWindiw_name:name
                                   queDing:^{
                                       [YiJian_Manager end];
                                       App_Manager.heatState = WuCaoZuo_heat;
                                       NSArray *devices = [DataBase_Manager getAllBoundDevice];
                                       if (devices.count < 1) {
                                           [MBProgressHUD showError:@"请先绑定设备"];
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                               TianJia_ViewController *vc = [[TianJia_ViewController alloc]init];
                                               [self.navigationController pushViewController:vc animated:NO];
                                           });
                                       }else{
                                           //连接蓝牙
                                           [self showConnectingFace];
                                           DeviceModel *device = App_Manager.currDevice;
                                           [_mainHandler FirstConnect_mac:device.clothesMac
                                                                   Sucess:^(NSString *mac) {
                                                                       [ZiZhu_Manager run_dingShiSeconds:MAX_UPSCALE];
                                                                       
                                                                   } Failure:^(NSString *mac) {
                                                                       [self showStopFace];
                                                                       YiChangManager *yichangManger = [[YiChangManager alloc]init];
                                                                       yichangManger.successBlock = ^(NSString *mac) {
                                                                           [ZiZhu_Manager run_dingShiSeconds:MAX_UPSCALE];
                                                                           [self showHeatingFace_targetTemp:50 andRestSeconds:MAX_UPSCALE];
                                                                       };
                                                                       [yichangManger showViewControllers_vc:self];
                                                                       [MBProgressHUD showError:@"连接失败"];
                                                                   } andIsRunDelegate:YES];
                                       }
                                   } quXiao:^{
                                       
                                   }];
}
//自助调温心跳刷新
-(void)ZhiZhuHeartRefresh:(NSInteger)seconds{
    [self.dingShiView showRestTime_seconds:seconds];
}
//自助调温完成
-(void)ZhiZhuFinish{
    [self.dingShiView showRestTime_seconds:0];
    [self showStopFace];
}
//自助调温终止
-(void)ZhiZhuEnd{
     [self.dingShiView showRestTime_seconds:0];
}
//自助调温开始
-(void)ZhiZhuStart_wenDu:(NSInteger)wenDu
              andSeconds:(NSInteger)seconds{
     [self showHeatingFace_targetTemp:50 andRestSeconds:MAX_UPSCALE];
}


//设置温度
-(void)userGesture_wenDu:(NSInteger)wenDu{
    //设置温度
    DeviceModel *currDevice = App_Manager.currDevice;
    [Blue_Manager smartctionWithMac:currDevice.clothesMac
                             Sucess:^(NSString *mac) {
                                if ([Blue_Manager setWenDuWithMac:currDevice.clothesMac andWenDu:(int)wenDu]) {
                                    [MBProgressHUD showSuccess:@"设置成功"];
                                }
                            } Failure:^(NSString *mac) {
                                
                            } andIsRunDelegate:NO];
}


#pragma mark - 显示相关界面
/** 示正在加热的界面 */
-(void)showHeatingFace_targetTemp:(NSInteger)targetTemp andRestSeconds:(NSInteger)Seconds{
    [self.yuanView    showHeatingFace_targetTemp:targetTemp];
    [self.switchView  showKaiGuanOpen];
    [self.dingShiView showRestTime_seconds:Seconds];
}

/** 显示正在连接界面 */
-(void)showConnectingFace{
    [self.yuanView showConnectingFace];
}

/**  显示停止加热的界面 */
-(void)showStopFace{
    [self.yuanView showStopFace];
    [self.switchView showKaiGuanClose];
    [self.dingShiView showRestTime_seconds:0];
}


#pragma mark - 懒加载
-(DingShiView *)dingShiView{
    if (!_dingShiView) {
        _dingShiView       = [[DingShiView alloc]initWithFrame:CGRectMake(0, [LKTool getBottomY:_niuBtn], WIDTH_lk, 82)];
        _dingShiView.frame = CGRectMake(0,[LKTool getBottomY:_niuBtn],WIDTH_lk,82);
        _dingShiView.userInteractionEnabled = YES;
        _dingShiView.delegate = self;
        LKLog(@"%f",_dingShiView.frame.size.width);
    }
    return _dingShiView;
}

-(LKView *)yuanView{
    if (!_yuanView) {
        _yuanView               = [[LKView alloc]initWithFrame:CGRectMake(WIDTH_lk/2-110, 84, 220, 220)];
        _yuanView.superVC       = self;
        _yuanView.delegate = self;
    }
    return _yuanView;
}
-(LKNiuView *)niuBtn{
    if (!_niuBtn){
        if ([LKTool iPhoneStyle] == iPhone6p) {
            _niuBtn       =[[[NSBundle mainBundle]loadNibNamed:@"LKNiuView" owner:nil options:nil]firstObject];
            _niuBtn.frame = CGRectMake(WIDTH_lk- _niuBtn.frame.size.width, [LKTool getBottomY:_yuanView], _niuBtn.frame.size.width, _niuBtn.frame.size.height);
        }else if([LKTool iPhoneStyle] == iPhone6){
            _niuBtn       =[[[NSBundle mainBundle]loadNibNamed:@"LKNiuView" owner:nil options:nil]firstObject];
            _niuBtn.frame = CGRectMake(WIDTH_lk- _niuBtn.frame.size.width, [LKTool getBottomY:_yuanView], _niuBtn.frame.size.width, _niuBtn.frame.size.height);
        }else {
            _niuBtn       =[[[NSBundle mainBundle]loadNibNamed:@"LKNiuView" owner:nil options:nil]firstObject];
            _niuBtn.frame = CGRectMake(WIDTH_lk- _niuBtn.frame.size.width, [LKTool getBottomY:_yuanView], _niuBtn.frame.size.width, _niuBtn.frame.size.height);
        }
        _niuBtn.superVC                = self;
        _niuBtn.userInteractionEnabled = YES;
        _niuBtn.backgroundColor        = [UIColor clearColor];
    }
    return _niuBtn;
}
-(LKButton *)niuCovBtn{
    if (!_niuCovBtn) {
         _niuCovBtn = [[LKButton alloc]initWithFrame:self.niuBtn.frame];
        [_niuCovBtn addTarget:self action:@selector(cowClick) forControlEvents:UIControlEventTouchUpInside];
        _niuCovBtn.backgroundColor = [UIColor clearColor];
    }
    return _niuCovBtn;
}
-(SwitchView *)switchView{
    if (!_switchView) {
        _switchView                               = [[SwitchView alloc]initWithFrame:CGRectMake(0, [LKTool getBottomY:_dingShiView], WIDTH_lk, 82)];
        _switchView.frame                         = CGRectMake(0,[LKTool getBottomY:_dingShiView],WIDTH_lk,82);
        _switchView.userInteractionEnabled        = YES;
        _switchView.delegate                      = self;
        LKLog(@"%f",_switchView.frame.size.width);
    }
    return _switchView;
}

-(UIBarButtonItem *)rightItem2{
    if (!_rightItem2) {
        UIButton *rightButton_huo               = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
            [rightButton_huo setImage:[UIImage imageNamed:@"太阳"]forState:UIControlStateNormal];
            [rightButton_huo addTarget:self action:@selector(huoMiaoClick)forControlEvents:UIControlEventTouchUpInside];
        _rightItem2             = [[UIBarButtonItem alloc]initWithCustomView:rightButton_huo];
    }
    return _rightItem2;
}

-(UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        UIButton *rightButton    = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
            [rightButton setImage:[UIImage imageNamed:@"右侧菜单"]forState:UIControlStateNormal];
            [rightButton addTarget:self action:@selector(rightButtonClick)forControlEvents:UIControlEventTouchUpInside];
        _rightItem               = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    }
    return _rightItem;
}


-(UIBarButtonItem *)fixedSpaceBarButtonItem{
    if (!_fixedSpaceBarButtonItem) {
        _fixedSpaceBarButtonItem= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        _fixedSpaceBarButtonItem.width            = 22;
    }
    return _fixedSpaceBarButtonItem;
}


#pragma MARK - kVO相关
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"heatState"]) {
        UserHeatState state = [change[@"new"] intValue];
        if (state == YiJian_heat) {
            self.navigationItem.rightBarButtonItems = @[self.rightItem,self.fixedSpaceBarButtonItem,self.rightItem2];
            [self showStopFace];
        }else{
            self.navigationItem.rightBarButtonItems = @[self.rightItem,self.fixedSpaceBarButtonItem];
        }
    
    }
}

-(void)dealloc{
    @try {
         [App_Manager removeObserver:self forKeyPath:@"heatState" context:nil];
    } @catch (NSException *exception) {
        LKLog(@"移除heatState KVO crash");
    } @finally {
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

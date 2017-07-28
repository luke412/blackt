//
//  Location_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/27.
//  Copyright © 2016年 鲁柯. All rights reserved.
//  位置界面

#import "Location_ViewController.h"
#import "FriendView.h"
#import "LocationModel.h"
#import "AnnotationManager.h"
#import "YingYanManager.h"
#import "FriendInfoModel.h"
#import "UIImageView+WebCache.h"
#import "UserInfoModel.h"
#import "ImageManager.h"
#import "LKDaTouZhen.h"
#import "LKDaTouZhen_f.h"

//坐标转化
#import "WeiZhiManager.h"



@interface Location_ViewController ()<CLLocationManagerDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate> //鹰眼代理
{
    //逻辑
    NSTimer * _timer;
    NSMutableArray      *myFriendInFoArr;
    BMKLocationService  *locService;
    LocationModel       *myLocation;
    AnnotationManager   *annotationManager;
    BMKUserLocation     * myUserLocation;
    //我的可见好友信息
    NSMutableDictionary * friendImageDic;  //key 是userid    value是图片地址
    
    //视图
    NSMutableArray     <LKKPointAnnotation *>* myFriendAnnotationArr;
    BMKMapView         * mapView;
    LKButton           * friendBtn;
    LKButton           * showMyLocationBtn;
    FriendView         * friendView;
    ImageManager       *imageManager;
}
@property(nonatomic,strong)LKKPointAnnotation *myDaTouZhen;  //为的大头针

@end

@implementation Location_ViewController
-(void)viewWillAppear:(BOOL)animated{
    [mapView viewWillAppear];
    //创建地图
    [self createMap];
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTittleWithText:LK(@"位 置")];
    annotationManager = [[AnnotationManager alloc]init];
    myFriendAnnotationArr = [[NSMutableArray alloc]init];
    myFriendInFoArr       = [[NSMutableArray  alloc]init];
    
    //判断网络状态
    [self panDuanWangLuo];
    

    //获取我是否隐身
    [self loadMyInfo];

    
    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(everyTime) userInfo:nil repeats:YES];
    
    //滚动条不受影响
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];

    imageManager = [[ImageManager alloc]init];
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
                                      
                                      NSInteger locationShare = App_Manager.currUserInfo.locationShare;
                                      if (locationShare == 0) {
                                          friendView.kaiGuanBtn.isOn = YES;
                                          [friendView showCurrFace_btn:friendView.kaiGuanBtn];
                                      }else{
                                          friendView.kaiGuanBtn.isOn = NO;
                                          [friendView showCurrFace_btn:friendView.kaiGuanBtn];
                                      }
                                      //加载所有可见好友
                                      [self loadAllFriend];
                                  } Abnormal:^(id responseObject) {
                                      
                                  } Failure:^(NSError *error) {
                                      
                                  }];
    
}

#pragma mark - 代理
-(void)onChangeGatherAndPackIntervals:(BTKChangeIntervalErrorCode)error{
    LKLog(@"改采集和打包上传周期的结果错误 %ld",error);
}

-(void)onStartService:(BTKServiceErrorCode)error {
    NSLog(@"start service response: %lu", (unsigned long)error);//0成功
}


-(void)createMap{
    mapView                   = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, WIDTH_lk, HEIGHT_lk-64)];
    mapView.delegate          = self;// 此处记得不用的时候需要置nil，否则影响内存的释放
    [self.view addSubview:mapView];
    mapView.showsUserLocation = NO;//显示定位图层 显示当前设备的位置
    //百度定位
    locService                = [[BMKLocationService alloc]init];//初始化BMKLocationService
    locService.delegate       = self;
    //启动LocationService
    [locService startUserLocationService];
    
    
    //好友互看Btn
    friendBtn = [[LKButton alloc]initWithFrame:CGRectMake(WIDTH_lk - lkptBiLi(40) - lkptBiLi(10),lkptBiLi(28) ,lkptBiLi(50), lkptBiLi(50))];
    friendBtn.backgroundColor = [UIColor clearColor];
    [friendBtn setImage:[UIImage imageNamed:@"好友互看"] forState:UIControlStateNormal];
    [friendBtn addTarget:self action:@selector(showFriend) forControlEvents:UIControlEventTouchUpInside];
    [mapView addSubview:friendBtn];
    
    showMyLocationBtn = [[LKButton alloc]initWithFrame:CGRectMake(lkptBiLi(20) ,HEIGHT_lk- 64 - lkptBiLi(40) - 40,lkptBiLi(50), lkptBiLi(50))];
    showMyLocationBtn.backgroundColor = [UIColor clearColor];
    [showMyLocationBtn setImage:[UIImage imageNamed:@"显示我的位置"] forState:UIControlStateNormal];
    [showMyLocationBtn addTarget:self action:@selector(toShowMyLocationBtn) forControlEvents:UIControlEventTouchUpInside];
    [mapView addSubview:showMyLocationBtn];
    
    //右侧抽屉
    friendView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"FriendView" owner:self options:nil] lastObject];
    friendView.superVC = self;
        __weak typeof(self) weakSelf = self;
    friendView.mySwitchClick = ^(LKButton *switchBtn) {
                                [weakSelf friendViewSwitchChange:switchBtn];
                            };
    [friendView initialization_superVC:self];
    myLocation = [[LocationModel alloc]init];
}


#pragma mark -- BMKMapdelegate

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
   
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.backgroundColor = [UIColor yellowColor];
        LKLog(@"%f,%f",newAnnotationView.frame.size.width,newAnnotationView.frame.size.height);
        newAnnotationView.pinColor              = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop          = NO;// 设置该标注点动画显示
        newAnnotationView.image = [UIImage imageNamed:@"空白占位"];
        
        
          newAnnotationView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        //添加头像视图
        if ([annotation isKindOfClass:[LKKPointAnnotation class]]) {
             LKKPointAnnotation *tempAnnotation = (LKKPointAnnotation *)annotation;
            //获取头像
            NSString *userid            = tempAnnotation.userId;
            NSString *imagePath         = friendImageDic[userid];
            if (tempAnnotation.isMe == YES) {
                imagePath = App_Manager.currUserInfo.userImage;
                LKDaTouZhen *daTouZhenView = [[[NSBundle mainBundle]loadNibNamed:@"LKDaTouZhen" owner:nil options:nil]firstObject];
                daTouZhenView.frame        = CGRectMake(0, 0, daTouZhenView.frame.size.width, daTouZhenView.frame.size.height);
                [LKTool setView_CenterX:newAnnotationView.center.x andView:daTouZhenView];
                [daTouZhenView.touXiangImage sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"推文图片占位"]];
                daTouZhenView.touXiangImage.layer.cornerRadius  = daTouZhenView.touXiangImage.frame.size.width/2;
                daTouZhenView.touXiangImage.layer.masksToBounds = YES;
                daTouZhenView.userInteractionEnabled            = YES;
                [LKTool setView_CenterX:newAnnotationView.frame.size.width/2 andView:daTouZhenView];
                //点击
                [newAnnotationView addSubview:daTouZhenView];
                
            }else{
                LKDaTouZhen_f *daTouZhenView                    = [[[NSBundle mainBundle]loadNibNamed:@"LKDaTouZhen_f" owner:nil options:nil]firstObject];
                daTouZhenView.frame                             = CGRectMake(0, 0, daTouZhenView.frame.size.width, daTouZhenView.frame.size.height);
                [LKTool setView_CenterX:newAnnotationView.center.x andView:daTouZhenView];
                [daTouZhenView.touXiangImage sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"推文图片占位"]];
                daTouZhenView.touXiangImage.layer.cornerRadius  = daTouZhenView.touXiangImage.frame.size.width/2;
                daTouZhenView.touXiangImage.layer.masksToBounds = YES;
                [LKTool setView_CenterX:newAnnotationView.frame.size.width/2 andView:daTouZhenView];
                [newAnnotationView addSubview:daTouZhenView];
            }
        }
        return newAnnotationView;
    }
    return nil;
}

//覆盖物
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKGroundOverlay class]]){
        BMKGroundOverlayView* groundView = [[BMKGroundOverlayView alloc] initWithOverlay:overlay] ;
        return groundView;
    }
    return nil;
}


-(void)panDuanWangLuo{
        //获取通知中心
        AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
        [manger startMonitoring];
        //2.监听改变
        [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        
        if (status == AFNetworkReachabilityStatusUnknown) {//未知
            
        }else if(status == AFNetworkReachabilityStatusNotReachable){//没有网络
            dispatch_async(dispatch_get_main_queue(), ^{
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:LK(@"提示")message:LK(@"网络未连接") delegate:nil cancelButtonTitle:LK(@"知道了") otherButtonTitles:nil,nil];
                                [alertView show];
            });
        }else if(status == AFNetworkReachabilityStatusReachableViaWWAN){//3G|4G
            
        }else if(status == AFNetworkReachabilityStatusReachableViaWiFi){//wifi
            
        }
    }];
}
#pragma mark - 用户事件
//视野回到“我的位置”
-(void)toShowMyLocationBtn{
    if (myUserLocation == nil) {
        return;
    }
    [mapView setCenterCoordinate:myUserLocation.location.coordinate animated:YES];
    
}
-(void)friendViewSwitchChange:(LKButton *)btn{
    NSString *userid    = [App_Manager getUserId];
    NSString *userToken = [App_Manager getUserToken];
    NSString *deviceid  = [App_Manager getDeviceId];
    LKShow(@"正在处理...");
    if (btn.isOn == YES) {
        [NetWork_Manager yinShen_userId:userid
                              userToken:userToken
                               deviceId:deviceid
                          locationShare:0
                                Success:^(id responseObject) {
                                    LKRemove;
                                    [MBProgressHUD showSuccess:@"已开启"];
                                } Abnormal:^(id responseObject) {
                                   LKRemove;
                                    [MBProgressHUD showError:responseObject[@"retMsg"]];
                                } Failure:^(NSError *error) {
                                  LKRemove;
                                    [MBProgressHUD showError:@"网络开小差~\(≧▽≦)/"];
                                }];
    }else{
        [NetWork_Manager yinShen_userId:userid
                              userToken:userToken
                               deviceId:deviceid
                          locationShare:1
                                Success:^(id responseObject) {
                                    LKRemove;
                                    [MBProgressHUD showSuccess:@"已开启"];
                                } Abnormal:^(id responseObject) {
                                     LKRemove;
                                    [MBProgressHUD showError:responseObject[@"retMsg"]];
                                } Failure:^(NSError *error) {
                                    LKRemove;
                                    [MBProgressHUD showError:@"网络开小差~\(≧▽≦)/"];
                                }];
    }
}
-(void)showFriend{
    [friendView open];
}
-(void)mengBanClick{
    [friendView close];
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
    UserInfoModel *infoModel = [UserDefaultsUtils getCacheUserInfo];
    myLocation.latitude  = userLocation.location.coordinate.latitude;
    myLocation.longitude = userLocation.location.coordinate.longitude;
    if (infoModel) {
        myLocation.title = infoModel.userMobile;
    }
    

    if (myLocation.latitude >= 0 && myLocation.latitude <= 90) {
        if (!_myDaTouZhen) {
             _myDaTouZhen = (LKKPointAnnotation *)[annotationManager addAnnotation_LocationModel:myLocation
                                                                                         mapView:mapView
                                                                                            isMe:YES
                                                                                          userId:[App_Manager getUserId]];
            
        }
    }
    
    
    //显示区域
    CLLocationCoordinate2D coor;
    coor.latitude              = userLocation.location.coordinate.latitude;
    coor.longitude             = userLocation.location.coordinate.longitude;
    BMKCoordinateRegion region = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(0.01f, 0.01f));
    [mapView setRegion:region animated:YES];
    myUserLocation = userLocation;
    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [mapView updateLocationData:userLocation];
    LKLog(@"df");
}


#pragma mark - 获取所有可见好友
-(void)loadAllFriend{
    NSString *userId    = [App_Manager getUserId];
    NSString *userToken = [App_Manager getUserToken];
    NSString *deviceId  = [App_Manager getDeviceId];
    [NetWork_Manager loadAllCanSeeFriend_userId:userId
                                      userToken:userToken
                                       deviceId:deviceId
                                        Success:^(NSArray<FriendInfoModel *> *friendList) {
                                            //显示好友的位置
                                            [myFriendInFoArr removeAllObjects];
                                            [self showFriendLocation_friendArr:friendList];
                                            [myFriendInFoArr addObjectsFromArray:friendList];
                                            
                                        } Abnormal:^(id responseObject) {
                                            
                                        } Failure:^(NSError *error) {
                                            
                                        }];
    
    
}

/**显示好友位置*/
-(void)showFriendLocation_friendArr:(NSArray <FriendInfoModel *>*)arr{
    if (!friendImageDic) {
         friendImageDic = [[NSMutableDictionary alloc]init];
    }
    [friendImageDic removeAllObjects];
    [myFriendAnnotationArr removeAllObjects];
    for (FriendInfoModel *model in arr) {
        NSString *useridKey      = [NSString stringWithFormat:@"%ld",model.friendUserId];
        NSString *imagePathValue = model.userImage;
        [friendImageDic setObject:imagePathValue forKey:useridKey];
    }
    
    
    
    for (FriendInfoModel *model in arr) {
            NSInteger userid  = model.friendUserId;
            NSString *userStr = [NSString stringWithFormat:@"%ld",userid];
            YingYanManager *yingYanManager = [[YingYanManager alloc]init];
            [yingYanManager queryTrackLatestPoint_Keyword:userStr
                                                 complete:^(NSDictionary *responseDic, NSString *userid) {
                                                     if (nil == responseDic) {
                                                         NSLog(@"Entity Search查询格式转换出错");
                                                     }else{
                                                         LKLog(@"有无数据1:%@",responseDic);
                                                         NSDictionary *dic = responseDic[@"latest_point"];
                                                         
                                                         LocationModel *locationModel = [[LocationModel alloc]init];
                                                         locationModel.latitude   = [dic[@"latitude"]  floatValue];   //维度
                                                         locationModel.longitude  = [dic[@"longitude"] floatValue];   //经度
                                                         //userid做的tag
                                                         locationModel.title = model.userMobile;
                                                         //添加大头针
                                                         LKKPointAnnotation *daTouZhen = (LKKPointAnnotation *)[annotationManager addAnnotation_LocationModel:locationModel mapView:mapView isMe:NO userId:userid];
                                                         [myFriendAnnotationArr addObject:daTouZhen];
                                                         
                                                     }
                                                 }];
    }
}

#pragma mark - 计时器
-(void)everyTime{
    [self refreshDaTouZhen];
}
/** 刷新大头针 */
-(void)refreshDaTouZhen{
        
        [annotationManager refreshAnnotation_LocationModel:myLocation
                                        BMKPointAnnotation:_myDaTouZhen];

    
    for (FriendInfoModel *model in myFriendInFoArr){
        NSInteger userid  = model.friendUserId;
        NSString *userStr = [NSString stringWithFormat:@"%ld",userid];
        YingYanManager *yingYanManager = [[YingYanManager alloc]init];
        [yingYanManager queryTrackLatestPoint_Keyword:userStr
                                             complete:^(NSDictionary *responseDic, NSString *userid) {
                                                 if (nil == responseDic) {
                                                     NSLog(@"Entity Search查询格式转换出错");
                                                 }else{
                                                     LKLog(@"有无数据1:%@",responseDic);
                                                     NSDictionary *dic    = responseDic[@"latest_point"];
                                                     LocationModel *locationModel = [[LocationModel alloc]init];
                                                     locationModel.latitude       = [dic[@"latitude"]  floatValue];//维度
                                                     locationModel.longitude      = [dic[@"longitude"] floatValue];//经度
                                                     //userid做的tag
                                                     
                                                     locationModel.title          = model.userMobile;
                                                     
                                                     
                                                     //刷新大头针
                                                     for (LKKPointAnnotation *daTouZhen in myFriendAnnotationArr) {
                                                         if ([daTouZhen.userId isEqualToString:userid]) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                    [annotationManager refreshAnnotation_LocationModel:locationModel BMKPointAnnotation:daTouZhen];
                                                                   
                                                                 LKLog(@"更新成功 %@ %f",daTouZhen.userId ,locationModel.latitude);
                                                             });
                                                         }
                                                    }
                                                 }
                                             }];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [mapView viewWillDisappear];
    mapView.delegate = nil; // 不用时，置nil
    [locService stopUserLocationService];
    locService.delegate=nil;
    self.tabBarController.tabBar.hidden = NO;
    if (_timer != nil) {
                //销毁定时器
                [_timer invalidate];
    }

}


-(void)dealloc
{
    NSLog(@"Location_ViewController 死亡");
        if (_timer != nil) {
                //销毁定时器
                [_timer invalidate];
         }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

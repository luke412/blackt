//
//  Warm_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/22.
//  Copyright © 2016年 鲁柯. All rights reserved.
//  温暖界面

#import "Warm_ViewController.h"
#import "Bound_ViewController.h"         //绑定衣物界面
#import "BoundSetName_ViewController.h"  //绑定衣物，写入名字界面
#import "ZFScanViewController.h"         //二维码扫描
#import "Warm_TableViewCell.h"
#import "MJRefresh.h"                  //下拉刷新
#import "Connecting_ViewController.h"  //连接中
#import "MenuView.h"
#import "LKView.h"
#import "LKDrawingBoard.h"             //动态画图类
#import "DrawerScrollView.h"           //抽屉滑动视图
#import "DingShiBtn.h"
#import "LKSwitch.h"
#import "LKDingShiLabel.h"
#import "LKnameLabel.h"
#define Disconnec  1
#define Modify     2
@interface Warm_ViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
//UI
@property(nonatomic,strong) UIButton           *rightButton;
@property(nonatomic,strong) UIBarButtonItem    *rightItem;
@property(nonatomic,strong) LKDingShiLabel     *dingShiLabel;
@property(nonatomic,strong) DingShiBtn         *dingshiBtn;
@property(nonatomic,strong) NSUserDefaults     *luke;
@property(nonatomic,strong) UIPickerView       *timePicker;
@property(nonatomic,strong) DrawerScrollView   *drawerScrollView;     //抽屉
@property(nonatomic,strong) LKView             *baseView;                 //圆环
@property(nonatomic,strong) LKSwitch           *mySwitch;                 //加热开关
@property(nonatomic,strong) UIScrollView       *backGroundScrollow;
@property(nonatomic,strong) MenuView           *menView;
@property(nonatomic,strong) UIView             *timePickerToolbar;
@property(nonatomic,strong) LKnameLabel        *nameLabel;
//数据
@property(nonatomic,assign) int                originator;          //由解绑进入编辑界面为1，由修改名称进入界面为2
@property (nonatomic,strong)NSMutableArray     *minutesArray;       //存储分钟的数组

@end

@implementation Warm_ViewController
#pragma mark - 懒加载相关
-(UIButton *)rightButton{
    if (!_rightButton){
        _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    }
    return _rightButton;
}
-(UIBarButtonItem *)rightItem{
    if (!_rightItem){
        _rightItem  = [[UIBarButtonItem alloc]init];
    }
    return _rightItem;
}
-(LKDingShiLabel *)dingShiLabel{
    if (!_dingShiLabel){
        _dingShiLabel  = [[LKDingShiLabel alloc]initWithFrame:CGRectMake(WIDTH_lk/2-60, 390, 120, 40)];
    }
    return _dingShiLabel;
}
-(NSUserDefaults *)luke{
    if (!_luke) {
        _luke = [NSUserDefaults standardUserDefaults];
    }
    return _luke;
}

-(UIPickerView *)timePicker{
    if (!_timePicker) {
         _timePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0,HEIGHT_lk-210,WIDTH_lk , 220)];
    }
    return _timePicker;
}

-(DrawerScrollView *)drawerScrollView{
    if (!_drawerScrollView) {
        _drawerScrollView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"DrawerScrollView" owner:self options:nil] lastObject];
    }
    return _drawerScrollView;
}

-(LKView *)baseView{
    if (!_baseView) {
        _baseView  =[[LKView alloc]initWithFrame:CGRectMake(WIDTH_lk/2-110, 90, 220, 220)];
    }
    return _baseView;
}
-(LKSwitch *)mySwitch{
    if (!_mySwitch) {
        CGFloat margin = 20;
        _mySwitch=[[LKSwitch alloc]initWithFrame:CGRectMake(WIDTH_lk-margin-50, 58, 50, 15)];
        _mySwitch.on = NO;
       [self.backGroundScrollow addSubview:self.mySwitch];
    }
    return _mySwitch;
}
-(UIScrollView *)backGroundScrollow{
    if (!_backGroundScrollow) {
        _backGroundScrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WIDTH_lk, HEIGHT_lk-64-48)];
    }
    return _backGroundScrollow;
}
-(MenuView *)menView{
    if (!_menView) {
        _menView=[[[NSBundle bundleForClass:[self class]] loadNibNamed:@"MenuView" owner:self options:nil] lastObject];
    }
    return _menView;
}
-(UIView *)timePickerToolbar{
    if (!_timePickerToolbar) {
        _timePickerToolbar =[[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT_lk-210-35, WIDTH_lk, 35)];
    }
    return _timePickerToolbar;
}
-(DingShiBtn *)dingshiBtn{
    if (!_dingshiBtn) {
        _dingshiBtn =[[[NSBundle bundleForClass:[self class]] loadNibNamed:@"DingShiBtn" owner:self options:nil] lastObject];
    }
    return _dingshiBtn;
}
-(LKnameLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel =[[LKnameLabel alloc]initWithFrame:CGRectMake(WIDTH_lk-160, 5, 150, 30)];
        _nameLabel.textAlignment =NSTextAlignmentRight;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [UIColor blackColor];
        
    }
    return _nameLabel;
}
-(void)createUI{

    
    
    
    CGFloat margin = 20;
    //底层scrollow
    self.backGroundScrollow.scrollEnabled  =NO;
    [self.view addSubview:self.backGroundScrollow];
     self.backGroundScrollow.contentSize=CGSizeMake(WIDTH_lk, 800);
     self.backGroundScrollow.delegate=self;
    [self.mySwitch addTarget:self action:@selector(mySwitchClick:) forControlEvents:UIControlEventValueChanged];

    
    self.mySwitch.onTintColor= [LKTool from_16To_Color:UI_COLOR_pink];
    [self.backGroundScrollow addSubview:self.nameLabel];
    
    if (self.menView.isOpen == YES) {
        [self.view bringSubviewToFront:self.menView];
    }
    
    //圆形进度环
    [self.backGroundScrollow addSubview:self.baseView];
    self.baseView.isOnline = Disconnect;
    
    
    //定时按钮
    [self.dingshiBtn reloadUI];
    [self.dingshiBtn addTarget:self action:@selector(dingshiClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundScrollow addSubview:self.dingshiBtn];
    
    self.dingshiBtn.center = CGPointMake(WIDTH_lk/2, 380);
    self.dingshiBtn.isSeted = NO;
    
    //定时时间展示label
    [self.backGroundScrollow addSubview:self.dingShiLabel];
    
    
    
    //抽屉按钮
    [self.backGroundScrollow addSubview:self.drawerScrollView];
    
}

//右按钮切换
-(void)setRightButtonTittle:(NSString *)tittle andImage:(UIImage *)image{
    if ([tittle      isEqualToString:@"取消"]) {
        self.rightButton.frame=CGRectMake(self.rightButton.frame.origin.x,self.rightButton.frame.origin.y,40,20);
        [self.rightButton  setTitle:tittle forState:UIControlStateNormal];
        [self.rightButton setImage :nil forState:UIControlStateNormal];
        [self.rightButton addTarget:self action:@selector(cancelClick)forControlEvents:UIControlEventTouchUpInside];
        self.rightItem.customView = self.rightButton;
        self.navigationItem.rightBarButtonItem=self.rightItem;
        
    }else if([tittle  isEqualToString:@"解绑"]){
        self.rightButton.frame=CGRectMake(self.rightButton.frame.origin.x,self.rightButton.frame.origin.y,40,20);
        [self.rightButton  setTitle:tittle forState:UIControlStateNormal];
        [self.rightButton setImage :nil forState:UIControlStateNormal];
        [self.rightButton addTarget:self action:@selector(UnBundling:)forControlEvents:UIControlEventTouchUpInside];
        self.rightItem.customView = self.rightButton;
        self.navigationItem.rightBarButtonItem=self.rightItem;
    }else{  //普通状态
        self.rightButton.frame = CGRectMake(self.rightButton.frame.origin.x, self.rightButton.frame.origin.y, 20, 20);
        [self.rightButton setImage :[UIImage imageNamed:@"列表2"]forState:UIControlStateNormal];
        [self.rightButton setTitle:nil forState:UIControlStateNormal];
        [self.rightButton addTarget:self action:@selector(rightButtonClick:)forControlEvents:UIControlEventTouchUpInside];
         self.rightItem.customView = self.rightButton;
        self.navigationItem.rightBarButtonItem=self.rightItem;
    }

}

- (void)viewDidLoad{
    [super viewDidLoad];  
    [self.luke setObject:@"Normal" forKey:@"WarmViewControllerState"];
    [self.luke synchronize];
    

    self.minutesArray = [[NSMutableArray alloc]init];
    for (int i=14; i<150; i++) {
        NSString *timeStr=[NSString stringWithFormat:@"%.2d分钟",i];
        if (i ==14) {
            timeStr = @"不限时";
        }
        [self.minutesArray addObject:timeStr];
    }

    
    self.originator  =0;

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(ConnectionSuccessful:)       name:@"ConnectionSuccessful" object:nil];
    [nc addObserver:self selector:@selector(ConnectionFails:)            name:@"ConnectionFails" object:nil];
    [nc addObserver:self selector:@selector(ValidationMacfails:)         name:@"ValidationMacfails" object:nil];
    [nc addObserver:self selector:@selector(ConnectionisBroken:)         name:kLGPeripheralDidDisconnect object:nil];
    [nc addObserver:self selector:@selector(userSelectImageBtn_after)    name:@"userSelectImageBtn_after" object:nil];
    [nc addObserver:self selector:@selector(BindingSuccess:)             name:@"BindingSuccess" object:nil];
    [nc addObserver:self selector:@selector(ModifyNameSuccess:)          name:@"ModifyNameSuccess" object:nil];
    [nc addObserver:self selector:@selector(UnbundlingSuccess:)          name:@"UnbundlingSuccess" object:nil];
    [nc addObserver:self selector:@selector(ConnectionSuccessful_warm:)  name:@"ConnectionSuccessful_warm" object:nil];
    [nc addObserver:self selector:@selector(ToSaoMa:)                    name:@"ToSaoMa" object:nil];
    
    
    
    //监听从后台到前台
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground)name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"温 暖";
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.navigationItem.titleView = title;

    self.view.backgroundColor=[UIColor whiteColor];
    //设置左右两侧按钮
    UIButton *leftButton       = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    [leftButton setImage:[UIImage imageNamed:@"加号"]forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClick)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem =leftItem;
    
    [self setRightButtonTittle:nil andImage:[UIImage imageNamed:@"列表2"]];
   
    
    //如果还没有绑定设备就显示引导页
    NSArray *devices=[[LKDataBaseTool sharedInstance]showAllDataFromTable:nil];
    if (devices.count<1||devices==nil) {
        
    }else{
        //自动连接 第一个
        ClothesModel *model = devices[0];
        [LKDataBaseTool sharedInstance].showMac = model.clothesMac;
        
    }

        [self createUI];
    
    if (devices.count<1||devices==nil) {
    }else{
        [HeatingClothesBLEService sharedInstance].isBound=NO;
        NSString *showMac =  [LKDataBaseTool sharedInstance].showMac;
        [[HeatingClothesBLEService sharedInstance]StartScanningDeviceWithMac:showMac];
        self.baseView.isOnline = Connecting;
    }

}
-(void)ToSaoMa:(NSNotification *)notify{
    Bound_ViewController *vc = [[Bound_ViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];

}

-(void)leftButtonClick{
    //self.hidesBottomBarWhenPushed=YES;
    Bound_ViewController *bound=[[Bound_ViewController alloc]init];
    [self.navigationController pushViewController:bound animated:NO];
    self.hidesBottomBarWhenPushed=NO;
}
-(void)rightButtonClick:(UIButton *)btn{
    NSString *stateStr = [self.luke objectForKey:@"WarmViewControllerState"];
    if (![stateStr isEqualToString:@"Normal"]) {
        return;
    }
    NSArray *deviceArr=[[LKDataBaseTool sharedInstance]showAllDataFromTable:nil];
    if (deviceArr.count==0) {
        [MBProgressHUD showError:@"暂无绑定设备，不需使用此功能"];
        return;
    }
    
    if (self.menView==nil||self.menView.isOpen==NO) {
        self.menView.frame=CGRectMake(WIDTH_lk-120, 0, 110, 130);
        self.menView.isOpen=YES;
        [self.view addSubview:self.menView];
        //菜单点击 修改名称
        __weak typeof (self)weakSelf = self;
        __weak typeof (_luke)weakLuke = _luke;
        __weak typeof (self.rightButton)weakRightButton = self.rightButton;
        __weak typeof (_menView)weakMenView = _menView;
        __weak typeof (_drawerScrollView)weakDrawerScrollView = _drawerScrollView;
        [weakMenView appearAnimation];
        [weakMenView set_modifyClickBlock:^{
            weakSelf.originator=Modify;//发起者
            if (!weakDrawerScrollView){
                return ;
            }
            [weakLuke setObject:@"ModifyName" forKey:@"WarmViewControllerState"];
            [weakLuke synchronize];
            
            if (weakDrawerScrollView.isOpen==NO) {
                [weakDrawerScrollView appearAnimation];
            }
            [weakSelf setRightButtonTittle:@"取消" andImage:nil];
            [weakMenView disappearAnimation];
        }];
        //菜单点击 解绑
        [weakMenView set_disconnectClickBlock:^{
            weakSelf.originator=Disconnec;//发起者
            [weakLuke setObject:@"Unbundling" forKey:@"WarmViewControllerState"];
            [weakLuke synchronize];
            [weakSelf setRightButtonTittle:@"取消" andImage:nil];
            [weakMenView disappearAnimation];
            if (self.drawerScrollView.isOpen == NO) {
                [self.drawerScrollView appearAnimation];
            }
            
            //全部设为未选
            for (UIView *subView in self.drawerScrollView.chouTiScrollew.subviews) {
                 NSString *classStr=[NSString stringWithUTF8String:object_getClassName(subView)];
                if ([classStr isEqualToString:@"DrawerDeviceImage"]) {
                    DrawerDeviceImage *imageBtn = (DrawerDeviceImage *)subView;
                    imageBtn.isSelected = NO;
                }
            }

        }];
    }else{
        [_menView disappearAnimation];
    }
    
}

#pragma mark 用户操作---按钮点击，触摸
-(void)PickercancelBtnClick{
        //取消时间选择
    [self removePicker];
}
-(void)PickerdetermineBtnClick{
    //时间选择完成
    int row = [self.timePicker selectedRowInComponent:0];
    UILabel *label =   [self.timePicker viewForRow:row forComponent:0];
    NSLog(@"拿到时间%@",label.text);  //拿到时间18分钟
    NSString *timeStr       = label.text;  //18分钟

    if ([timeStr isEqualToString:@"不限时"]) {
        NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
        dispatch_queue_t myQueue = [HeatingClothesBLEService sharedInstance].myQueue;
        dispatch_async(myQueue, ^{
            LGCharacteristic *send = [[HeatingClothesBLEService sharedInstance]getSendDataCharacteristic :showMac];
            LGCharacteristic *read = [[HeatingClothesBLEService sharedInstance]getReciveDataCharacteristic:showMac];
            BOOL isOk= [[HeatingClothesBLEService sharedInstance]writeHeatTimeCount:showMac value:MAX_UPSCALE andandsendChara:send andreciveChara:read];
            if (isOk) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showSuccess:@"设置成功"];
                    self.dingshiBtn.isSeted = NO;
                });
            }

        });

        [self removePicker];
        return;
    }
    
    
    NSArray *arr =[timeStr componentsSeparatedByString:@"分钟"];
    NSString *timeNumStr = arr[0];
    //写入倒计时时间 writeHeatTimeCount
    
    dispatch_queue_t myQueue = [HeatingClothesBLEService sharedInstance].myQueue;
    dispatch_async(myQueue, ^{
        NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
        LGCharacteristic *send = [[HeatingClothesBLEService sharedInstance]getSendDataCharacteristic :showMac];
        LGCharacteristic *read = [[HeatingClothesBLEService sharedInstance]getReciveDataCharacteristic:showMac];
        int  timeInt = [timeStr intValue];
        int  miaoShuInt = timeInt *60;
        BOOL isOk= [[HeatingClothesBLEService sharedInstance]writeHeatTimeCount:showMac value:miaoShuInt andandsendChara:send andreciveChara:read];
        if (isOk) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD showSuccess:@"设置成功"];
                 self.dingshiBtn.isSeted = YES;
            });
           
        }
    });

        [self removePicker];
    
   
}
-(void)dingshiClick:(DingShiBtn *)btn{
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
    if (![[HeatingClothesBLEService sharedInstance] queryIsBLEConnected:showMac]) {
         [MBProgressHUD showError:@"请连接设备"];
    }
    
    else{
        //日期选择器出现
        self.tabBarController.tabBar.hidden = YES;
        
        self.timePicker.backgroundColor=[LKTool from_16To_Color:@"424242"];
        self.timePicker.dataSource = self;
        self.timePicker.delegate   = self;
                    //是否要显示选中的指示器(默认值是NO)
        self.timePicker.tintColor=[UIColor whiteColor];
        self.timePicker.showsSelectionIndicator = YES;
        [self.view addSubview: self.timePicker];
        //工具条
        self.timePickerToolbar.backgroundColor=[LKTool from_16To_Color:@"424242"];
        UIButton *cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
        [cancelBtn setImage:[UIImage imageNamed:@"时间选择取消"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(PickercancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.timePickerToolbar addSubview:cancelBtn];
        
        UIButton *determineBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH_lk-35, 5, 30, 30)];
        [determineBtn setImage:[UIImage imageNamed:@"时间选择完成"] forState:UIControlStateNormal];
        [determineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [determineBtn addTarget:self action:@selector(PickerdetermineBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.timePickerToolbar addSubview:determineBtn];
        [self.view    addSubview:self.timePickerToolbar];
    }
    
}

-(void)mySwitchClick:(LKSwitch *)switch1{
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac;

    if(![[HeatingClothesBLEService sharedInstance]queryIsBLEConnected:showMac]){
        [MBProgressHUD showError:@"请连接设备"];
        switch1.on = NO;
        return;
    }
    
    if (switch1.isOn==YES) {
        NSLog(@"开启");
        NSString *showMac = [LKDataBaseTool sharedInstance].showMac ;
        dispatch_queue_t myQueue = [HeatingClothesBLEService sharedInstance].myQueue;
        dispatch_async(myQueue, ^{
            LGCharacteristic *send = [[HeatingClothesBLEService sharedInstance]getSendDataCharacteristic:showMac];
            LGCharacteristic *read = [[HeatingClothesBLEService sharedInstance]getReciveDataCharacteristic:showMac];
            BOOL isOk= [[HeatingClothesBLEService sharedInstance]writeHeatTimeCount:showMac value:MAX_UPSCALE   andandsendChara:send andreciveChara:read];
            if (isOk){
                dispatch_async(dispatch_get_main_queue(),^{
                   [MBProgressHUD showSuccess:@"已开启"];
                });
            }

        });

        
    }else{
         NSString *showMac = [LKDataBaseTool sharedInstance].showMac ;
        //写入倒计时时间 writeHeatTimeCount
        dispatch_queue_t myQueue = [HeatingClothesBLEService sharedInstance].myQueue;
        dispatch_async(myQueue, ^{
            LGCharacteristic *send = [[HeatingClothesBLEService sharedInstance]getSendDataCharacteristic:showMac];
            LGCharacteristic *read = [[HeatingClothesBLEService sharedInstance]getReciveDataCharacteristic:showMac];
            BOOL isOk= [[HeatingClothesBLEService sharedInstance]writeHeatTimeCount:showMac value:0 andandsendChara:send andreciveChara:read];
            if (isOk) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showSuccess:@"已关闭"];
                });
                
            }
        });

  }
}

#define mark 刷新

//刷新主界面动态UI   （修改衣物名称，解绑）
-(void)refreshMainVC{
    [self.drawerScrollView dataBaseRefresh];
}


-(void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    //移除所有self监听的所有通知
    [nc removeObserver:self];
}

#pragma mark scrollView代理
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //下拉距离>100触发
}

#pragma mark 通知响应 UnbundlingSuccess
//解绑成功
-(void)UnbundlingSuccess:(NSNotification *)notify{
    NSArray <ClothesModel *>*devices = [[LKDataBaseTool sharedInstance]showAllDataFromTable:nil];
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
    if (devices.count == 0 || devices == nil) {
        [LKDataBaseTool sharedInstance].showMac = @"";
        [self createUI];
        self.baseView.isOnline = Disconnect;
    }else{
         ClothesModel *model = devices[0];
         [LKDataBaseTool sharedInstance].showMac = model.clothesMac;
         [self createUI];
        //设为最高档

                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *dic = [LKPopupWindowManager sharedInstance].setTempDictionary;
                    NSNumber *wenDuNum = [dic objectForKey:[LKDataBaseTool sharedInstance].showMac];
                    float wenDu = [wenDuNum floatValue];
                    [self.baseView refreshHandleWithWenDu:wenDu];
                });
            }
  
   
}

-(void)BindingSuccess:(NSNotification *)notify{
    NSString *mac = notify.object;
    [LKDataBaseTool sharedInstance].showMac = mac;
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac ;
    //设为最高档
    dispatch_queue_t myQueue = [HeatingClothesBLEService sharedInstance].myQueue;
    dispatch_async(myQueue, ^{
        LGCharacteristic *send = [[HeatingClothesBLEService sharedInstance]getSendDataCharacteristic:showMac];
        LGCharacteristic *read = [[HeatingClothesBLEService sharedInstance]getReciveDataCharacteristic:showMac];
        BOOL isOk= [[HeatingClothesBLEService sharedInstance]writeHeatTimeCount:showMac value:MAX_UPSCALE andandsendChara:send andreciveChara:read];
        if (isOk) {
            
        }
        
        BOOL  isOk2=[[HeatingClothesBLEService sharedInstance]writeSettedTemperature:showMac value:51 andandsendChara:send andreciveChara:read];
        if (isOk2) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *dic = [LKPopupWindowManager sharedInstance].setTempDictionary;
                NSNumber *wenDuNum = [dic objectForKey:[LKDataBaseTool sharedInstance].showMac];
                float wenDu = [wenDuNum floatValue];
                [self.baseView refreshHandleWithWenDu:wenDu];
            });
        }
    });

    
    [self createUI];
    self.baseView.isOnline = Connected;
    [self.drawerScrollView dataBaseRefresh];

    //读取数据库 查询名字
    NSArray <ClothesModel *> *devices = [[LKDataBaseTool sharedInstance]showAllDataFromTable:nil];
    NSString *name ;
    for (ClothesModel *model in devices) {
        NSString *deviceMac = model.clothesMac;
        if ([mac isEqualToString:deviceMac]) {
            name = model.clothesName;
        }
    }
    if (name!=nil) {
        self.nameLabel.text =name;
    }
   
}
-(void)ConnectionSuccessful_warm:(NSNotification *)notify{
    NSString *mac = notify.object;
    [LKDataBaseTool sharedInstance].showMac = mac;
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac ;
    //设为最高档
    dispatch_queue_t myQueue = [HeatingClothesBLEService sharedInstance].myQueue;
    dispatch_async(myQueue, ^{
        LGCharacteristic *send = [[HeatingClothesBLEService sharedInstance]getSendDataCharacteristic:showMac];
        LGCharacteristic *read = [[HeatingClothesBLEService sharedInstance]getReciveDataCharacteristic:showMac];
        BOOL isOk= [[HeatingClothesBLEService sharedInstance]writeHeatTimeCount:showMac value:MAX_UPSCALE andandsendChara:send andreciveChara:read];
        if (isOk){
            
        }
        BOOL isOk2= [[HeatingClothesBLEService sharedInstance]writeSettedTemperature:showMac value:51 andandsendChara:send andreciveChara:read];
        if (isOk2){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *dic = [LKPopupWindowManager sharedInstance].setTempDictionary;
                NSNumber *wenDuNum = [dic objectForKey:[LKDataBaseTool sharedInstance].showMac];
                float wenDu = [wenDuNum floatValue];
                [self.baseView refreshHandleWithWenDu:wenDu];

            });
        }

    });
    
}
//解绑
-(void)UnBundling:(UIButton *)btn{
    NSString *stateStr = [self.luke objectForKey:@"WarmViewControllerState"];
    if (![self.rightButton.titleLabel.text isEqualToString:@"解绑"]) {
        return;
    }
    if (![stateStr isEqualToString:@"Unbundling"]) {
        return;
    }
    if (self.drawerScrollView.frame.origin.x<-20) {
        [self.drawerScrollView appearAnimation];
    }
    
    NSMutableArray<NSString *> *unBundlingDevicesMacArray = [[NSMutableArray alloc]init];
    for (UIView *subView in self.drawerScrollView.chouTiScrollew.subviews) {
         NSString *classStr=[NSString stringWithUTF8String:object_getClassName(subView)];
        if ([classStr isEqualToString:@"DrawerDeviceImage"]) {
            DrawerDeviceImage *imageBtn = (DrawerDeviceImage *)subView;
            if (imageBtn.isSelected == YES) {
                [unBundlingDevicesMacArray addObject:imageBtn.deviceMac];
            }
        }
    
    }
    
    
    if (unBundlingDevicesMacArray.count<1) {
        [MBProgressHUD showSuccess:@"请选定解绑设备"];
        [self.luke setObject:@"Unbundling" forKey:@"WarmViewControllerState"];
        [self.luke synchronize];
        
        return;
    }
        //数据库删除
        BOOL isOK= [[LKDataBaseTool sharedInstance] DeletedMultipleFromTheTable:unBundlingDevicesMacArray];
        if (isOK) {
            [MBProgressHUD showSuccess:@"解绑成功"];
            [self.luke setObject:@"Normal" forKey:@"WarmViewControllerState"];
            [self.luke synchronize];
            [self setRightButtonTittle:nil andImage:[UIImage imageNamed:@"列表2"]];
            //与解绑成功设备断开连接 disconnectWithCompletion
            for (NSString *mac in unBundlingDevicesMacArray) {
               LGPeripheral *peripheral =  [[HeatingClothesBLEService sharedInstance]getCachedPeripheral:mac];
                if (peripheral) {
                    dispatch_queue_t myQueue = [HeatingClothesBLEService sharedInstance].myQueue;
                    dispatch_async(myQueue, ^{
                        [peripheral disconnectWithCompletion:^(NSError *error) {
                            NSLog(@"解绑断开连接，错误:%@",error);
                        }];

                    });

                    [[HeatingClothesBLEService sharedInstance]cleanDevice:mac];
                }
            }
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            NSNotification *notify = [[NSNotification alloc]initWithName:@"UnbundlingSuccess" object:unBundlingDevicesMacArray userInfo:nil];
            [nc postNotification:notify];
        }else{
            [self.luke setObject:@"Unbundling" forKey:@"WarmViewControllerState"];
            [self.luke synchronize];
        }
    [self.drawerScrollView dataBaseRefresh];
}
-(void)ConnectionFails:(NSNotification *)notify
{
    NSString *mac = notify.object;
    //查询mac对应 衣物名称
    NSDictionary *deviceDic = [LKPopupWindowManager sharedInstance].nameDictionary;
    NSString *name;
    for (NSString  *macStr in deviceDic.allKeys) {
        if ([macStr isEqualToString:mac]) {
            name = [deviceDic objectForKey:macStr];
        }
    }
    
    if (name !=nil) {
        NSString *str = [NSString stringWithFormat:@"“%@”,连接失败",name];
        [self createUI];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:str];
        self.baseView.isOnline = Disconnect;
        return;
    }
    
    [self createUI];
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:@"连接失败"];
    NSLog(@"县成名：%@",[NSThread currentThread]) ;
    self.baseView.isOnline = Disconnect;
    
}
-(void)ValidationMacfails:(NSNotification *)notify
{
    
    NSString *mac = notify.object;
    //查询mac对应 衣物名称
    NSDictionary *deviceDic = [LKPopupWindowManager sharedInstance].nameDictionary;
    NSString *name;
    for (NSString  *macStr in deviceDic.allKeys) {
        if ([macStr isEqualToString:mac]) {
            name = [deviceDic objectForKey:macStr];
        }
    }
    
    if (name !=nil) {
        NSString *str = [NSString stringWithFormat:@"“%@”,连接失败",name];
        [self createUI];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:str];
        self.baseView.isOnline = Disconnect;
        return;
    }


    [self createUI];
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:@"连接失败"];
    self.baseView.isOnline = Disconnect;
}


//修改衣物名称成功
-(void)ModifyNameSuccess:(NSNotification *)notify{
    NSString *mac = notify.object;
    [self.luke setObject:@"Normal" forKey:@"WarmViewControllerState"];
    [self.luke synchronize];

    [self.drawerScrollView dataBaseRefresh];
    self.rightButton.frame = CGRectMake(0, 0, 20, 20);
    [self setRightButtonTittle:nil andImage:[UIImage imageNamed:@"列表2"]];

    
    
}
-(void)ConnectionSuccessful:(NSNotification *)notify
{
    [MBProgressHUD hideHUD];
    
    //写入衣物名字界面
    BoundSetName_ViewController *boundSetNameVC=[[BoundSetName_ViewController alloc]init];
    boundSetNameVC.macAddress=notify.object;
    [self.navigationController pushViewController:boundSetNameVC animated:NO];
    self.hidesBottomBarWhenPushed=NO;
}
-(void)ConnectionisBroken:(NSNotification *)notify{
    LGPeripheral *peripheral=notify.object;
    NSString *perName = peripheral.name;
    NSArray *arr = [perName componentsSeparatedByString:@"#0x"];
    NSString *mac = arr[1];
    
    
}

-(void)userSelectImageBtn_after{
    //寻找选中imageBtn
    NSMutableArray<DrawerDeviceImage *> *allSectedDevices =[[NSMutableArray alloc]init];
    for (UIView *subView in self.drawerScrollView.chouTiScrollew.subviews) {
        NSString *classStr=[NSString stringWithUTF8String:object_getClassName(subView)];
        if ([classStr isEqualToString:@"DrawerDeviceImage"]) {
            DrawerDeviceImage *imageBtn = (DrawerDeviceImage *)subView;
            if (imageBtn.isSelected == YES) {
                [allSectedDevices addObject:imageBtn];
            }
        }
        
    }
    
    NSUserDefaults *luke = [NSUserDefaults standardUserDefaults];
    NSString *stateStr = [luke objectForKey:@"WarmViewControllerState"];
    if ([stateStr isEqualToString:@"ModifyName"]) {
        BoundSetName_ViewController *setName = [[BoundSetName_ViewController alloc]init];
        DrawerDeviceImage *imageBtn = [allSectedDevices lastObject];
        setName.macAddress =imageBtn.deviceMac;
        setName.isModify=YES;
        [self.navigationController pushViewController:setName animated:NO];
    }
    else if ([stateStr isEqualToString:@"Unbundling"]){//如果是解绑状态
        if (allSectedDevices.count==0){
            [self setRightButtonTittle:@"取消" andImage:nil];
        }else{
            [self setRightButtonTittle:@"解绑" andImage:nil];
        }
    }else if([stateStr isEqualToString:@"Normal"]){//选中
        
        DrawerDeviceImage *imageDevice =[allSectedDevices lastObject];
        if (imageDevice == nil) {
            return;
        }
        self.nameLabel.text = imageDevice.deviceName;
        if ([[HeatingClothesBLEService sharedInstance]queryIsBLEConnected:imageDevice.deviceMac]) { //已连接状态
            [LKDataBaseTool sharedInstance].showMac = imageDevice.deviceMac;
            [self createUI];
            self.baseView.isOnline = Connected;
            self.dingshiBtn.isSeted = NO;
            //刷新手柄小球
            NSDictionary *dic = [LKPopupWindowManager sharedInstance].setTempDictionary;
            NSNumber *wenDuNum = [dic objectForKey:[LKDataBaseTool sharedInstance].showMac];
            float wenDu = [wenDuNum floatValue];
            [self.baseView refreshHandleWithWenDu:wenDu];
        }else{//未连接状态去连接
            [LKDataBaseTool sharedInstance].showMac = imageDevice.deviceMac;
            [[LGCentralManager sharedInstance]stopScanForPeripherals];
            [HeatingClothesBLEService sharedInstance].isBound = NO;
            [[HeatingClothesBLEService sharedInstance]StartScanningDeviceWithMac:[LKDataBaseTool sharedInstance].showMac];
             self.baseView.isOnline = Connecting;
             self.dingshiBtn.isSeted = NO;
        }
    }
}
//取消绑定操作
-(void)cancelClick{
    NSString *stateStr = [self.luke objectForKey:@"WarmViewControllerState"];
    if (![self.rightButton.titleLabel.text isEqualToString:@"取消"]) {
        return;
    }if ([stateStr isEqualToString:@"Normal"]) {
        return;
    }
    
    [self.luke setObject:@"Normal" forKey:@"WarmViewControllerState"];
    [self.luke synchronize];
    
    [self setRightButtonTittle:nil andImage:[UIImage imageNamed:@"列表2"]];
    
    for (UIView *view1 in self.drawerScrollView.chouTiScrollew.subviews) {
         NSString *classStr=[NSString stringWithUTF8String:object_getClassName(view1)];
        if ([classStr isEqualToString:@"DrawerDeviceImage"]) {
            DrawerDeviceImage *imageBtn =(DrawerDeviceImage *) view1;
            if ([imageBtn.deviceMac isEqualToString:[LKDataBaseTool sharedInstance].showMac]) {
                imageBtn.isSelected = YES;
            }else{
                imageBtn.isSelected = NO;
            }
        }
    }
    
}

#pragma mark 日期选择器代理相关
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment=NSTextAlignmentCenter;
    label.text = self.minutesArray[row];
    label.textColor = [UIColor whiteColor];
    return label;
}
//返回列数（必须实现）
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//返回每列里边的行数（必须实现）
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    for (UIView *view in pickerView.subviews) {
        NSLog(@"~~~~%@", view);
        if (view.frame.size.height < 2) {
            view.backgroundColor=[UIColor whiteColor];  //选中行分割线颜色
        }
    }
        //返回表情数组的个数
        return self.minutesArray.count;
    
    
}

#pragma mark --- 与处理有关的代理方法
//设置组件的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
        return WIDTH_lk;
}
//设置组件中每行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
        return 30;
}
//设置组件中每行的标题row:行
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
        return self.minutesArray[row];
}
//选中行的事件处理
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [pickerView reloadAllComponents];
    UILabel *label =   [pickerView viewForRow:row forComponent:0];
    label.textColor = [LKTool from_16To_Color:@"f4527c"];
    NSLog(@"%@",self.minutesArray[row]);
    
}




-(void)removePicker{
    [self.timePicker removeFromSuperview];
    [self.timePickerToolbar removeFromSuperview];
    self.tabBarController.tabBar.hidden = NO;
}


#pragma mark
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

//
//  LKView.m
//  圆形进度条
//
//  Created by 鲁柯 on 2017/2/15.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "LKView.h"
#import "LKTool.h"

#define    shapeLayerBackGroundColor     [LKTool from_16To_Color:@"#eee6e6"]
//#define    shapeLayerBackGround
#define    shapeLayerProgressColor       [LKTool from_16To_Color:@"#ffffff"]
@interface LKView ()<UIGestureRecognizerDelegate>
{
    UIImageView  *BackGroundImageView;
    CAShapeLayer *shapeLayerProgress;
    UIImageView  *handleBallImageView;
    UIBezierPath *pathProgress;
    UIBezierPath *pathHandle;

    UILabel      *targetTemperature;          //目标温度
    UILabel      *currentTemperature;         //当前温度
    
    UIImageView  *temperatureChangeImageView; //温度变化箭头图
    UIButton     *lianJieBtn;                 //连接设备按钮
    UILabel      *ConnectionProgressLabel;    //连接进度
    UILabel      *isconnectingLabel;          //"连接中"
    NSTimer      *timer;                      //百分比倒计时
    
    float         connectProgress;
    float         oldWenDu;
    int           yiChangCount;         //温度异常次数
}

@property(nonatomic,strong) UIImageView  *currentPower ; //当前电量

@end
@implementation LKView
-(UIImageView *)currentPower{
    if (!_currentPower) {
        _currentPower = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        _currentPower.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2+40);
        [self addSubview:_currentPower];
    }
    return _currentPower;
}
-(void)setWenDu:(float)wenDu{
    currentTemperature.text = [NSString stringWithFormat:@"当前：%.0f℃",wenDu];
}
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
        self.lineWidth=17;
        self.radius   =91;
        self.progress =0.0;
        yiChangCount = 0;
        [self createUI];
        [self addObserver];
        [self addGesture];
    }
    return self;
}

-(void)addObserver{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(ConnectionSuccessful_warm:) name:@"ConnectionSuccessful_warm" object:nil];
        [nc addObserver:self selector:@selector(HeartBeatRefresh:)          name:@"HeartBeatRefresh" object:nil];
        [nc addObserver:self selector:@selector(BindingSuccess:)            name:@"BindingSuccess" object:nil];
        [nc addObserver:self selector:@selector(kLGPeripheralDidDisconnect:) name:kLGPeripheralDidDisconnect object:nil];
        [nc addObserver:self selector:@selector(BluetoothOff:)               name:@"BluetoothOff" object:nil];
        [nc addObserver:self selector:@selector(HeartBeatRefresh_nil)          name:@"HeartBeatRefresh_nil" object:nil];
}
#pragma mark 通知响应
-(void)kLGPeripheralDidDisconnect:(NSNotification *)notify{
    if (!notify.object) {
        return;
    }
    LGPeripheral *Peripheral = notify.object;
    NSString *macStr =    Peripheral.name;
    NSArray *arr     =[macStr componentsSeparatedByString:@"#0x"];
    NSString *mac    =arr[1];
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
    if ([mac isEqualToString:showMac]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isOnline = Disconnect ;
        });
        
    }
}

-(void)BindingSuccess:(NSNotification *)notify{
    NSString *mac = notify.object;
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
    if ([showMac isEqualToString:mac]) {
        self.isOnline = Connected;
    }
}
-(void)HeartBeatRefresh_nil{
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![[HeatingClothesBLEService sharedInstance]queryIsBLEConnected:showMac] && self.isOnline!=Connecting) {
            self.isOnline = Disconnect;
        }
    });

}
-(void)HeartBeatRefresh:(NSNotification *)notify{
    WarmShowInfoModel *model = notify.object;
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[HeatingClothesBLEService sharedInstance]queryIsBLEConnected:showMac]) {
            self.isOnline = Connected;
        }

        if (self.isOnline == Connecting) {
            return;
        }
        if (![[HeatingClothesBLEService sharedInstance]queryIsBLEConnected:showMac] && self.isOnline!=Disconnect) {
            self.isOnline = Connecting;
            return;
        }
        if (![model.mac isEqualToString:showMac]) {
            return;
        }
        if ([model.mac isEqualToString:showMac]) {
            int restTime = model.remainingTime;
            if (restTime == -1000) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"控制盒与BlackT接触不良，请确认是否连接" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
                [alertView show];
                
                LGPeripheral *peripheral =  [[HeatingClothesBLEService sharedInstance]getCachedPeripheral:showMac];
                if (peripheral) {
                    dispatch_queue_t myQueue = [HeatingClothesBLEService sharedInstance].myQueue;
                    dispatch_async(myQueue, ^{
                        [peripheral disconnectWithCompletion:^(NSError *error) {
                            NSLog(@"解绑断开连接，错误:%@",error);
                        }];
                    });
                    
                    [[HeatingClothesBLEService sharedInstance]cleanDevice:showMac];
                }
                return;

            }
            
            
            float wenDu = model.currentTemperature;    //更新当前温度
            if (wenDu == -1 ) {
                yiChangCount ++;
            }else{
                yiChangCount = 0;
            }
            if (yiChangCount ==3) {
                //断开
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"控制盒与BlackT接触不良，请确认是否连接" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
                [alertView show];
                

                LGPeripheral *peripheral =  [[HeatingClothesBLEService sharedInstance]getCachedPeripheral:showMac];
                if (peripheral) {
                    dispatch_queue_t myQueue = [HeatingClothesBLEService sharedInstance].myQueue;
                    dispatch_async(myQueue, ^{
                        [peripheral disconnectWithCompletion:^(NSError *error) {
                            NSLog(@"解绑断开连接，错误:%@",error);
                        }];
                    });
                    
                    [[HeatingClothesBLEService sharedInstance]cleanDevice:showMac];
                }
                return;
            }
            
            float muBiaoWenDU = model.presetTemperature;
            muBiaoWenDU-=2;  //修正
            if (muBiaoWenDU < 30 ||muBiaoWenDU >60) {
                targetTemperature.text =[NSString stringWithFormat:@"目标：--℃"];
             
            }else if (muBiaoWenDU < 30 && muBiaoWenDU >25)
            {
                muBiaoWenDU = 30;
                targetTemperature.text =[NSString stringWithFormat:@"目标：%.0f℃",muBiaoWenDU];
                NSMutableDictionary *dic = [LKPopupWindowManager sharedInstance].setTempDictionary;
                [dic setObject:@(muBiaoWenDU) forKey:showMac];
            }
            else{
                targetTemperature.text =[NSString stringWithFormat:@"目标：%.0f℃",muBiaoWenDU];
                NSMutableDictionary *dic = [LKPopupWindowManager sharedInstance].setTempDictionary;
                [dic setObject:@(muBiaoWenDU) forKey:showMac];
            }
            

            if (oldWenDu && wenDu && oldWenDu > wenDu) {
                temperatureChangeImageView.image = [UIImage imageNamed:@"温度下降"];
            }
            
            if (oldWenDu && wenDu && oldWenDu < wenDu) {
                temperatureChangeImageView.image = [UIImage imageNamed:@"温度上升"];
            }

            
            oldWenDu    = wenDu;
            if (wenDu == -1000) {
                
            }
            if (wenDu<30) {
                wenDu  = 30.0;
            }
            [self setWenDu:wenDu];
        }
        switch (model.restPower) {
            case -1:
                self.currentPower.image = [UIImage imageNamed:@"电池0"];
                break;
            case 0:
                self.currentPower.image = [UIImage imageNamed:@"电池0"];
                break;
            case 1:
                self.currentPower.image = [UIImage imageNamed:@"电池25"];
                break;
            case 2:
                self.currentPower.image = [UIImage imageNamed:@"电池50"];
                break;
            case 3:
                self.currentPower.image = [UIImage imageNamed:@"电池75"];
                break;
            case 4:
                self.currentPower.image = [UIImage imageNamed:@"电池100"];
                break;
                
            default:
                break;
        }
        

    });
    
    
}
-(void)ConnectionSuccessful_warm:(NSNotification *)notify{
    self.isOnline = Connected;
    NSString *mac = notify.object;
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
    if ([showMac isEqualToString:mac]) {
        float wenDu = [[HeatingClothesBLEService sharedInstance] getDangQianWenDu_Mac:showMac];
        [self setWenDu:wenDu];
    }
}
-(void)BluetoothOff:(NSNotification *)notify{
    self.isOnline = Disconnect;
}
-(void)createUI{
    //背景层
    //圆心
    self.circleCenterPosition  =CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    if (!BackGroundImageView) {
        BackGroundImageView        =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        [self addSubview:BackGroundImageView];

    }
    
    BackGroundImageView.image  =[UIImage imageNamed:@"进度条圆环背景"];
    BackGroundImageView.center =self.circleCenterPosition;
     self.currentPower.image = [UIImage imageNamed:@"电池100"];
    //进度层
    if (!pathProgress) {
        pathProgress = [[UIBezierPath alloc] init];
    }
    pathProgress =[UIBezierPath bezierPathWithArcCenter:self.circleCenterPosition radius:self.radius  startAngle:-M_PI/2  endAngle:-M_PI/2+(2*M_PI*self.progress) clockwise:YES];
    
    if(!shapeLayerProgress){
         shapeLayerProgress             = [CAShapeLayer layer];
        shapeLayerProgress.strokeColor = shapeLayerProgressColor.CGColor;
        shapeLayerProgress.fillColor   = [UIColor clearColor].CGColor;
        shapeLayerProgress.lineWidth   = self.lineWidth;
        shapeLayerProgress.lineJoin    = kCALineJoinRound;
        shapeLayerProgress.lineCap     = kCALineCapRound;
    }
    
    shapeLayerProgress.path        = pathProgress.CGPath;
    [self.layer addSublayer:shapeLayerProgress];
    
    //画手柄
    if(!handleBallImageView){
         handleBallImageView             =[[UIImageView alloc]initWithFrame:CGRectMake(self.circleCenterPosition.x, self.circleCenterPosition.y-self.radius, 27, 27)];
         [self addSubview:handleBallImageView];
    }
   
    handleBallImageView.center      =CGPointMake(self.circleCenterPosition.x, self.circleCenterPosition.y-self.radius);
    handleBallImageView.image       =[UIImage imageNamed:@"进度小球"];
   
    
    //阴影
    handleBallImageView.layer.shadowColor   = [UIColor blackColor].CGColor;//阴影颜色
    handleBallImageView.layer.shadowOffset  = CGSizeMake(0, 0);//偏移距离
    handleBallImageView.layer.shadowOpacity = 0.5;//不透明度
    handleBallImageView.layer.shadowRadius  = 5.0;//半径
    
    //目标温度label
    if (!targetTemperature) {
        targetTemperature=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 170, 50)];
         targetTemperature.textAlignment=NSTextAlignmentCenter;
          targetTemperature.text = @"目标：30℃";
        targetTemperature.font=[UIFont systemFontOfSize:20];
        targetTemperature.textColor=[UIColor whiteColor];
            [self addSubview:targetTemperature];
    }
        targetTemperature.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2-20);

    
    //当前温度
    if (!currentTemperature) {
        currentTemperature = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-50, [LKTool getBottomY:targetTemperature]-30, 100, 50)];
        currentTemperature.textAlignment=NSTextAlignmentCenter;
        currentTemperature.text=@"当前：30℃";
        currentTemperature.font=[UIFont systemFontOfSize:15];
        currentTemperature.textColor=[UIColor whiteColor];
        [self addSubview:currentTemperature];
    }
        currentTemperature.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2+10);
    

    //温度变化箭头视图
    if (!temperatureChangeImageView) {
        temperatureChangeImageView = [[UIImageView alloc]initWithFrame:CGRectMake([LKTool getRightX:currentTemperature]-20,[LKTool getBottomY:currentTemperature], 15*0.8, 20*0.8)];
        temperatureChangeImageView.image = [UIImage imageNamed:@"温度未开启"];
         [self addSubview:temperatureChangeImageView];
    }
    
    temperatureChangeImageView.center=CGPointMake(currentTemperature.center.x+50, currentTemperature.center.y);
    
    CGFloat x = currentTemperature.frame.origin.x;
    CGFloat y = currentTemperature.frame.origin.y;
    CGFloat width = currentTemperature.frame.size.width;
    CGFloat height = currentTemperature.frame.size.height;
    ConnectionProgressLabel= [[UILabel alloc]initWithFrame:CGRectMake(x, y-20, width, height)];
    ConnectionProgressLabel.text=@"23%";
    ConnectionProgressLabel.textAlignment = NSTextAlignmentCenter;
    ConnectionProgressLabel.textColor     = [UIColor whiteColor];
    [self addSubview:ConnectionProgressLabel];
}
#pragma mark 二级工具函数
-(void)addGesture{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTap:)];
    tap.delegate=self;
    [self addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(userPan:)];
    pan.delegate=self;
    [self addGestureRecognizer:pan];
}

-(void)userTap:(UITapGestureRecognizer *)myTap{
    CGPoint point = [myTap locationInView:self];
    NSLog(@"点击点的坐标 x:%f,y:%f",point.x,point.y);
    
    //计算进度
    [self calculateRrogress:point];
    //刷新位置
    [self refreshPosition:myTap];
    
    
}
#pragma mark set方法相关
-(void)setIsOnline:(ConnectionStatus)isOnline{
    
    _isOnline = isOnline;
    if (_isOnline == Connected){
        if (timer != nil) {
            //销毁定时器
            [timer invalidate];
        }
        self.currentPower.hidden = NO;
        currentTemperature.hidden = NO;
        //当前温度
        targetTemperature.hidden = NO;
        //温度变化箭头视图
        temperatureChangeImageView.hidden = NO;
        lianJieBtn.hidden        =YES;
        isconnectingLabel.hidden = YES;
        ConnectionProgressLabel.hidden =YES;

        if (self.progress<=0.33) {
            self.image=[UIImage imageNamed:@"绿背景"];
        }else if (self.progress<=0.66){
            self.image=[UIImage imageNamed:@"黄背景"];
        }
        else{
            self.image=[UIImage imageNamed:@"红背景"];
        }

    }else if(_isOnline == Connecting){
        if (timer != nil) {
            //销毁定时器
            [timer invalidate];
        }

        self.currentPower.hidden = YES;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(everyTime) userInfo:nil repeats:YES];
        connectProgress = 0;
        self.image=[UIImage imageNamed:@"灰背景"];
        currentTemperature.hidden = YES;
        targetTemperature.hidden = YES;
        //温度变化箭头视图
        temperatureChangeImageView.hidden = YES;
        lianJieBtn .hidden = YES;
        ConnectionProgressLabel.hidden = NO;
        
        if (!isconnectingLabel) {
            isconnectingLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-50, [LKTool getBottomY:ConnectionProgressLabel]-10, 100, 30)];
        }
        isconnectingLabel.hidden = NO;
        isconnectingLabel .text= @"正在连接中";
        isconnectingLabel .textColor = [UIColor whiteColor];
         isconnectingLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:isconnectingLabel];
        
    
    }else{//未连接
        self.currentPower.hidden = YES;
        if (timer != nil) {
            //销毁定时器
            [timer invalidate];
        }
        isconnectingLabel.hidden = YES;
        ConnectionProgressLabel .hidden =YES;

        self.image=[UIImage imageNamed:@"灰背景"];
        currentTemperature.hidden = YES;
        targetTemperature.hidden = YES;
        //温度变化箭头视图
        temperatureChangeImageView.hidden = YES;
        if (!lianJieBtn) {
            CGFloat x = currentTemperature.frame.origin.x;
            CGFloat y = currentTemperature.frame.origin.y;
            CGFloat width = currentTemperature.frame.size.width;
            CGFloat height = currentTemperature.frame.size.height;

            lianJieBtn  = [[UIButton alloc]initWithFrame:CGRectMake(x, y-20, width, height)];
        }
        lianJieBtn .hidden = NO;
        [lianJieBtn setTitle:@"连接" forState:UIControlStateNormal];
        [lianJieBtn addTarget:self action:@selector(ToConnect:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:lianJieBtn];
    }
}
#pragma mark 定时器
-(void)everyTime{
    connectProgress += 0.13;
    NSString *str = [NSString stringWithFormat:@"%.0f%%",connectProgress];
    ConnectionProgressLabel.text = str;
    if (connectProgress > 99) {
        if (timer != nil) {
            if (self.isOnline == Connecting) {
                self.isOnline = Disconnect;
            }
            //销毁定时器
            [timer invalidate];
        }

    }
}
#pragma mark 去连接
-(void)ToConnect:(UIButton *)btn{
    
    self.isOnline      = Connecting;
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
    if (showMac.length!=12  ||  showMac == nil) {
         [MBProgressHUD showError:@"请先绑定设备"];
         self.isOnline = Disconnect;
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            NSNotification *notify = [[NSNotification alloc]initWithName:@"ToSaoMa" object:nil userInfo:nil];
            [nc postNotification:notify];
        

    }else{
        [HeatingClothesBLEService sharedInstance].isBound=NO;
        [[HeatingClothesBLEService sharedInstance] StartScanningDeviceWithMac:showMac];
    }
    
}
/**/
-(void)userPan:(UIPanGestureRecognizer *)myPan{
    CGPoint point = [myPan locationInView:self];
    NSLog(@"拖拽点的坐标 x:%f,y:%f",point.x,point.y);
    
    //计算进度
    [self calculateRrogress:point];
    //刷新位置
    [self refreshPosition:myPan];
    if (myPan.state==UIGestureRecognizerStateEnded) {
        NSString *temperatureStr= targetTemperature.text;
        NSLog(@"拖拽结束,需要设定的温度是%@",temperatureStr);
    }
}

//刷新位置
-(void)refreshPosition:(UIGestureRecognizer *)gesture{
    pathProgress              =[UIBezierPath bezierPathWithArcCenter:self.circleCenterPosition radius:self.radius  startAngle:-M_PI/2  endAngle:-M_PI/2+(2*M_PI*self.progress) clockwise:YES] ;
    shapeLayerProgress.path   = pathProgress.CGPath  ;
    handleBallImageView.center=self.handlePosition ;
    NSLog(@"%f",self.progress);
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
    if ([[HeatingClothesBLEService sharedInstance]queryIsBLEConnected:showMac]) {
        if (self.progress<=0.33) {
            self.image=[UIImage imageNamed:@"绿背景"];
        }else if (self.progress<=0.66){
            self.image=[UIImage imageNamed:@"黄背景"];
        }
        else{
            self.image=[UIImage imageNamed:@"红背景"];
        }
       
    }
    
    //刷新温度
    //温度label刷新 30度-60度   加（0-30）
    int incremental = (int)30*self.progress;
    int setTemperature = 30+incremental;//目标：30℃
    targetTemperature.text=[NSString stringWithFormat:@"目标：%d℃",setTemperature];
    
    
    dispatch_queue_t myQueue = [HeatingClothesBLEService sharedInstance].myQueue;
    if (showMac && (gesture.state == UIGestureRecognizerStateEnded)) {
        dispatch_async(myQueue, ^{
            LGCharacteristic *read = [[HeatingClothesBLEService sharedInstance].reciveDataCharacteristicDictionary objectForKey:showMac];
            LGCharacteristic *send = [[HeatingClothesBLEService sharedInstance].sendDataCharacteristicDictionary objectForKey:showMac];
            BOOL isOK=[[HeatingClothesBLEService sharedInstance]writeSettedTemperature:showMac value:setTemperature andandsendChara:send andreciveChara:read];
            if (isOK) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showSuccess:@"设置成功"];
                });
            }
        });
 }
}


//根据用户点击点位置，计算应设的进度
-(void)calculateRrogress:(CGPoint)gesturesPosition{
    CGFloat centerDistance =sqrt(pow((gesturesPosition.x-self.circleCenterPosition.x),2) +
                                 pow((gesturesPosition.y-self.circleCenterPosition.y),2)  );
    
    //1
    if (gesturesPosition.x>=self.circleCenterPosition.x      && gesturesPosition.y<=self.circleCenterPosition.y) {
        if (gesturesPosition.x==self.circleCenterPosition.x) {
            self.progress       = 0.0;
            self.handlePosition = CGPointMake(self.circleCenterPosition.x, self.circleCenterPosition.y-self.radius);
            return;
        }
        if (gesturesPosition.y==self.circleCenterPosition.y) {
            self.progress   = 0.25;
            self.handlePosition = CGPointMake(self.circleCenterPosition.x+self.radius, self.circleCenterPosition.y);
            return;
        }
        
        CGFloat horizontalDistance = gesturesPosition.x-self.circleCenterPosition.x;
        CGFloat rotationAngle      = asin(horizontalDistance/centerDistance)/M_PI*180;
        self.progress              = rotationAngle/360;
        
        CGFloat x=self.circleCenterPosition.x+self.radius*(horizontalDistance/centerDistance);
        CGFloat y=self.circleCenterPosition.y-self.radius*cos(asin(horizontalDistance/centerDistance));
        self.handlePosition = CGPointMake(x,y);
    }
    //4
    else if (gesturesPosition.x>=self.circleCenterPosition.x && gesturesPosition.y>=self.circleCenterPosition.y){
        if (gesturesPosition.x==self.circleCenterPosition.x) {
            self.progress   = 0.5;
            self.handlePosition = CGPointMake(self.circleCenterPosition.x, self.circleCenterPosition.y+self.radius);
            return;
        }
        if (gesturesPosition.y==self.circleCenterPosition.y) {
            self.progress   = 0.25;
            self.handlePosition = CGPointMake(self.circleCenterPosition.x+self.radius, self.circleCenterPosition.y);
            return;
        }
        
        CGFloat verticalDistance = gesturesPosition.y-self.circleCenterPosition.y;
        CGFloat rotationAngle=asin(verticalDistance/centerDistance)/M_PI*180;
        self.progress   =rotationAngle/360+0.25;
        
        CGFloat x=self.circleCenterPosition.x+self.radius*cos(asin(verticalDistance/centerDistance));
        CGFloat y=self.circleCenterPosition.y+self.radius*sin(asin(verticalDistance/centerDistance));
        self.handlePosition = CGPointMake(x,y);
    }
    //3
    else if (gesturesPosition.x<=self.circleCenterPosition.x && gesturesPosition.y>=self.circleCenterPosition.y){
        if (gesturesPosition.x==self.circleCenterPosition.x) {
            self.progress   = 0.5;
            self.handlePosition = CGPointMake(self.circleCenterPosition.x, self.circleCenterPosition.y+self.radius);
            return;
        }
        if (gesturesPosition.y==self.circleCenterPosition.y) {
            self.progress   = 0.75;
            self.handlePosition = CGPointMake(self.circleCenterPosition.x-self.radius, self.circleCenterPosition.y);
            return;
        }
        
        CGFloat horizontalDistance = fabs(gesturesPosition.x-self.circleCenterPosition.x);
        CGFloat rotationAngle=asin(horizontalDistance/centerDistance)/M_PI*180;
        self.progress   =rotationAngle/360+0.5;
        
        CGFloat x=self.circleCenterPosition.x-self.radius*sin(asin(horizontalDistance/centerDistance));
        CGFloat y=self.circleCenterPosition.y+self.radius*cos(asin(horizontalDistance/centerDistance));
        self.handlePosition = CGPointMake(x,y);
    }
    //2
    else if (gesturesPosition.x<=self.circleCenterPosition.x && gesturesPosition.y<=self.circleCenterPosition.y){
        if (gesturesPosition.x==self.circleCenterPosition.x) {
            self.progress   = 0.0;
            return;
        }
        if (gesturesPosition.y==self.circleCenterPosition.y) {
            self.progress   = 0.75;
            return;
        }
        
        CGFloat verticalDistance = fabs(gesturesPosition.y-self.circleCenterPosition.y);
        CGFloat rotationAngle=asin(verticalDistance/centerDistance)/M_PI*180;
        self.progress   =rotationAngle/360+0.75;
        
        CGFloat x=self.circleCenterPosition.x-self.radius*cos(asin(verticalDistance/centerDistance));
        CGFloat y=self.circleCenterPosition.y-self.radius*sin(asin(verticalDistance/centerDistance));
        self.handlePosition = CGPointMake(x,y);

    }
}

//刷新设定温度手柄圆点
-(void)refreshHandleWithWenDu:(float)wenDu{
    CGFloat myProgress  = (wenDu - 30)/30;
    self.progress = myProgress;
    if (myProgress == 0) {
        handleBallImageView.center = CGPointMake(self.circleCenterPosition.x, self.circleCenterPosition.y-self.radius);
    }
    else if (myProgress == 0.25){
        handleBallImageView.center = CGPointMake(self.circleCenterPosition.x+self.radius, self.circleCenterPosition.y);
    }
    else if (myProgress == 0.5){
        handleBallImageView.center = CGPointMake(self.circleCenterPosition.x, self.circleCenterPosition.y+self.radius);
    }
    else if (myProgress == 0.75){
        handleBallImageView.center = CGPointMake(self.circleCenterPosition.x-self.radius, self.circleCenterPosition.y);
    }
    else if (myProgress == 1){
        myProgress = 0;
        handleBallImageView.center = CGPointMake(self.circleCenterPosition.x, self.circleCenterPosition.y-self.radius);
    }
    
    //一般情况
    else if (myProgress > 0 && myProgress<0.25){
        CGFloat xuanZhuanHuDu =   2*M_PI*myProgress;//旋转的弧度
        CGFloat x_Position = self.circleCenterPosition.x + self.radius*sin(xuanZhuanHuDu) ;
        CGFloat y_Position = self.circleCenterPosition.y - self.radius*cos(xuanZhuanHuDu) ;
        handleBallImageView.center = CGPointMake(x_Position, y_Position);
    }
    else if (myProgress > 0.25 && myProgress<0.5){
        CGFloat xuanZhuanHuDu =   2*M_PI*myProgress - M_PI_2;//旋转的弧度
        CGFloat x_Position = self.circleCenterPosition.x + self.radius*cos(xuanZhuanHuDu) ;
        CGFloat y_Position = self.circleCenterPosition.y + self.radius*sin(xuanZhuanHuDu) ;
        handleBallImageView.center = CGPointMake(x_Position, y_Position);
    }
    else if (myProgress > 0.5 && myProgress<0.75){
        CGFloat xuanZhuanHuDu =   2*M_PI*myProgress - M_PI;//旋转的弧度
        CGFloat x_Position = self.circleCenterPosition.x - self.radius*sin(xuanZhuanHuDu) ;
        CGFloat y_Position = self.circleCenterPosition.y + self.radius*cos(xuanZhuanHuDu) ;
        handleBallImageView.center = CGPointMake(x_Position, y_Position);
    }
    else if (myProgress > 0.75 && myProgress<1){
        CGFloat xuanZhuanHuDu =   2*M_PI*myProgress - M_PI - M_PI_2;//旋转的弧度
        CGFloat x_Position = self.circleCenterPosition.x - self.radius*cos(xuanZhuanHuDu) ;
        CGFloat y_Position = self.circleCenterPosition.y - self.radius*sin(xuanZhuanHuDu) ;
        handleBallImageView.center = CGPointMake(x_Position, y_Position);
    }
    
    
    //刷新进度层
    pathProgress              =[UIBezierPath bezierPathWithArcCenter:self.circleCenterPosition radius:self.radius  startAngle:-M_PI/2  endAngle:-M_PI/2+(2*M_PI*self.progress) clockwise:YES] ;
    shapeLayerProgress.path   = pathProgress.CGPath  ;
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
    if ([[HeatingClothesBLEService sharedInstance]queryIsBLEConnected:showMac]) {
        if (self.progress<=0.33) {
            self.image=[UIImage imageNamed:@"绿背景"];
        }else if (self.progress<=0.66){
            self.image=[UIImage imageNamed:@"黄背景"];
        }
        else{
            self.image=[UIImage imageNamed:@"红背景"];
        }
        
    }
}

-(void)dealloc
{
      if (timer != nil) {
           //销毁定时器
           [timer invalidate];
      }
      NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
      //移除所有self监听的所有通知
       [nc removeObserver:self];

}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

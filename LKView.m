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
    NSTimer      *timer;                       //百分比倒计时
    float         connectProgress;
    float         oldWenDu;
}



@end
@implementation LKView
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
        self.isOnline = Disconnect ;
    }
}

-(void)BindingSuccess:(NSNotification *)notify{
    NSString *mac = notify.object;
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
    if ([showMac isEqualToString:mac]) {
        self.isOnline = Connected;
    }
}

-(void)HeartBeatRefresh:(NSNotification *)notify{
    WarmShowInfoModel *model = notify.object;
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
    
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
        
        float wenDu = model.currentTemperature;    //更新当前温度
        if (oldWenDu && wenDu && oldWenDu > wenDu) {
            temperatureChangeImageView.image = [UIImage imageNamed:@"温度下降"];
        }
        
        if (oldWenDu && wenDu && oldWenDu < wenDu) {
            temperatureChangeImageView.image = [UIImage imageNamed:@"温度上升"];
        }
        
        
        
        
        oldWenDu    = wenDu;
        [self setWenDu:wenDu];
    }
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
    if (!currentTemperature) {
        currentTemperature=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 170, 50)];
         currentTemperature.textAlignment=NSTextAlignmentCenter;
        currentTemperature.text = @"当前：30℃";
        currentTemperature.font=[UIFont systemFontOfSize:20];
        currentTemperature.textColor=[UIColor whiteColor];
            [self addSubview:currentTemperature];
    }
        currentTemperature.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2-10);

    
    //当前温度
    if (!targetTemperature) {
        targetTemperature = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-50, [LKTool getBottomY:currentTemperature], 100, 50)];
        targetTemperature.textAlignment=NSTextAlignmentCenter;
        targetTemperature.text=@"目标：30℃";
        targetTemperature.font=[UIFont systemFontOfSize:15];
        targetTemperature.textColor=[UIColor whiteColor];
        [self addSubview:targetTemperature];
    }
        targetTemperature.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2+40);
    

    //温度变化箭头视图
    if (!temperatureChangeImageView) {
        temperatureChangeImageView = [[UIImageView alloc]initWithFrame:CGRectMake([LKTool getRightX:currentTemperature],[LKTool getBottomY:currentTemperature], 15, 20)];
        temperatureChangeImageView.image = [UIImage imageNamed:@"温度未开启"];
         [self addSubview:temperatureChangeImageView];
    }
    temperatureChangeImageView.center=CGPointMake(currentTemperature.center.x+60, currentTemperature.center.y);
   
    ConnectionProgressLabel= [[UILabel alloc]initWithFrame:currentTemperature.frame];
    ConnectionProgressLabel.text=@"23%";
    ConnectionProgressLabel.textAlignment = NSTextAlignmentCenter;
    ConnectionProgressLabel.textColor = [UIColor whiteColor];
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
            isconnectingLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-50, [LKTool getBottomY:ConnectionProgressLabel], 100, 30)];
        }
        isconnectingLabel.hidden = NO;
        isconnectingLabel .text= @"正在连接中";
        isconnectingLabel .textColor = [UIColor whiteColor];
         isconnectingLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:isconnectingLabel];
        
    
    }else{//未连接
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
            lianJieBtn  = [[UIButton alloc]initWithFrame:currentTemperature.frame];
        }
        lianJieBtn .hidden = NO;
        [lianJieBtn setTitle:@"连接" forState:UIControlStateNormal];
        [lianJieBtn addTarget:self action:@selector(ToConnect:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:lianJieBtn];
    }
}
#pragma mark 定时器
-(void)everyTime{
    connectProgress += 0.14;
    NSString *str = [NSString stringWithFormat:@"%.0f%%",connectProgress];
    ConnectionProgressLabel.text = str;
    if (connectProgress>98) {
        if (timer != nil) {
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
    if (showMac && (gesture.state==UIGestureRecognizerStateEnded)) {
        
        LGCharacteristic *read = [[HeatingClothesBLEService sharedInstance].reciveDataCharacteristicDictionary objectForKey:showMac];
        LGCharacteristic *send = [[HeatingClothesBLEService sharedInstance].sendDataCharacteristicDictionary objectForKey:showMac];
        BOOL isOK=[[HeatingClothesBLEService sharedInstance]writeSettedTemperature:showMac value:setTemperature andandsendChara:send andreciveChara:read];
        if (isOK) {
            [MBProgressHUD showSuccess:@"设置成功"];
        }
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

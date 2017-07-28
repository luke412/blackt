//
//  LKView.m
//  圆形进度条
//
//  Created by 鲁柯 on 2017/2/15.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "LKView.h"
#import "LKTool.h"
#import "YiJianManager.h"
#import "YiJianPlanModel.h"
#import "ZiZhuManager.h"

#define    shapeLayerBackGroundColor     [LKTool from_16To_Color:@"#eee6e6"]
#define    shapeLayerProgressColor       [LKTool from_16To_Color:@"#ffffff"]
@interface LKView ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)CAShapeLayer *shapeLayerProgress;
@property(nonatomic,strong)UIImageView  *handleBallImageView;
@property(nonatomic,strong)UIBezierPath *pathProgress;
@property(nonatomic,strong)UIBezierPath *pathHandle;
@property(nonatomic,strong)CAShapeLayer *shapeLayerProgress_Back;
@property(nonatomic,strong)UIBezierPath *pathProgress_Back;
@property(nonatomic,strong)UIBezierPath *pathHandle_Back;
@property(nonatomic,strong)UILabel      *targetTemperature;          //目标温度
@property(nonatomic,strong)UILabel      *targetTemperatureText;       //"℃"字样

@property(nonatomic,strong)UILabel      *muBiaoLabel;             //"目标"字样label
@property(nonatomic,strong)UIButton     *lianJieBtn;                 //连接设备按钮
@property(nonatomic,strong)UILabel      *ConnectionProgressLabel;    //连接进度
@property(nonatomic,strong)UILabel      *isconnectingLabel;          //"连接中"
@property(nonatomic,strong)NSTimer      *timer;                      //百分比倒计时
@property(nonatomic,assign)float         connectProgress;
@property(nonatomic,assign)CGFloat       imageWidth;                       //圆环宽度

@property(nonatomic,assign)CGFloat      shouBingRadius;    //手柄半径
@property(nonatomic,assign)int          abnormalCount;     //连接异常次数
@property(nonatomic,assign)int          myFount;           //连接按钮字号


//控件UI参数
@property(nonatomic,assign)CGFloat wenDuLabelidth;
@property(nonatomic,assign)CGFloat wenDuTextLabelWidth; //℃
@property(nonatomic,assign)CGFloat wenDuLabelFount;

@end
@implementation LKView
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        /**
         *  添加子控件
         */
        [self addSubview:self.lianJieBtn];
        [self addSubview:self.isconnectingLabel];
        [self addSubview:self.ConnectionProgressLabel];
        [self addSubview:self.targetTemperature];
        [self addSubview:self.targetTemperatureText];
        [self addSubview:self.muBiaoLabel];

        /**
         *  配置参数
         */
        self.userInteractionEnabled = YES;
        self.lineWidth      = 17;
        self.radius         = 91;
        CGFloat width       = WIDTH_lk * 0.67;
        self.imageWidth     = 200;
        self.shouBingRadius = 27;
        self.progress       = 0.0;
        self.abnormalCount  = 0;
        _myFount            = 18;
        if ([LKTool iPhoneStyle] == iPhone5){
            self.frame                   = CGRectMake(WIDTH_lk/2-width/2,
                                                      20+32.7+30,
                                                      width,
                                                      width);
            self.lianJieBtn.frame        = CGRectMake(0,
                                                      width/2-10,
                                                      width,
                                                      30);
            self.isconnectingLabel.frame = CGRectMake(width/2-50,
                                                      width/2-30,
                                                      100,
                                                      30);
            self.ConnectionProgressLabel.frame = CGRectMake(width/2-50,
                                                            width/2+10,
                                                            100,
                                                            30);
            self.targetTemperature.frame = CGRectMake(width/2-self.wenDuLabelidth/2-20, width/2-40, self.wenDuLabelidth, 50);
            self.targetTemperatureText.frame = CGRectMake([LKTool getRightX:self.targetTemperature], [LKTool getTopY: self.targetTemperature], self.wenDuTextLabelWidth, 50);
            
            self.muBiaoLabel      .frame = CGRectMake(width/2-20, width/2+15, 40, 20);

            self.radius         = 85;
            self.imageWidth     = 220;
            self.lineWidth      = 20;
            self.shouBingRadius = 30;
            self.myFount        = 17;
        }
        if ([LKTool iPhoneStyle] == iPhone6) {
            self.frame                   = CGRectMake(WIDTH_lk/2-width/2,
                                                      20+32.7+30,
                                                      width,
                                                      width);
            self.lianJieBtn.frame        = CGRectMake(0,
                                                      width/2-30,
                                                      width,
                                                      30);
            self.isconnectingLabel.frame = CGRectMake(width/2-50,
                                                      width/2-30,
                                                      100,
                                                      30);
            self.ConnectionProgressLabel.frame = CGRectMake(width/2-50,
                                                            width/2+10,
                                                            100,
                                                            30);
            self.targetTemperature.frame = CGRectMake(width/2-self.wenDuLabelidth/2-20, width/2-40, self.wenDuLabelidth, 50);
            self.targetTemperatureText.frame = CGRectMake([LKTool getRightX:self.targetTemperature], [LKTool getTopY: self.targetTemperature], self.wenDuTextLabelWidth, 50);

             self.muBiaoLabel      .frame = CGRectMake(width/2-20, width/2+15, 40, 20);
            self.radius         = 95;
            self.imageWidth     = 220;
            self.lineWidth      = 20;
            self.shouBingRadius = 33;
            self.myFount        = 18;
        }
        
        if([LKTool iPhoneStyle] == iPhone6p) {
            self.frame                   = CGRectMake(WIDTH_lk/2-(width-20)/2,
                                                      94,
                                                      width-20,
                                                      width-20);
            width = width -20;
            self.lianJieBtn.frame        = CGRectMake(0,
                                                      width/2-25,
                                                      width,
                                                      30);
            self.isconnectingLabel.frame = CGRectMake(width/2-50,
                                                      width/2-30,
                                                      100,
                                                      30);
            self.ConnectionProgressLabel.frame = CGRectMake(width/2-50,
                                                            width/2+10,
                                                            100,
                                                            30);
            self.targetTemperature.frame = CGRectMake(width/2-self.wenDuLabelidth/2-20, width/2-40, self.wenDuLabelidth, 50);
            self.targetTemperatureText.frame = CGRectMake([LKTool getRightX:self.targetTemperature], [LKTool getTopY: self.targetTemperature], self.wenDuTextLabelWidth, 50);

            self.muBiaoLabel      .frame = CGRectMake(width/2-20, width/2+15, 40, 20);
            self.radius         = 95;
            self.imageWidth     = 220;
            self.lineWidth      = 20;
            self.shouBingRadius = 35;
            self.myFount        = 20;
            
        }
        self.muBiaoLabel.font                = [UIFont systemFontOfSize:15];
        self.muBiaoLabel.textColor           = [UIColor whiteColor];
        self.muBiaoLabel.text                = @"目标";
        [self.muBiaoLabel.layer setBorderColor:[UIColor whiteColor].CGColor];
            [self.muBiaoLabel.layer setBorderWidth:1];
            [self.muBiaoLabel.layer setMasksToBounds:YES];
        self.muBiaoLabel.layer.masksToBounds = YES;
        self.muBiaoLabel.layer.cornerRadius  = 4;

        self.isconnectingLabel.font = [UIFont systemFontOfSize:_myFount];
        self.ConnectionProgressLabel.font = [UIFont systemFontOfSize:_myFount];
        [self.lianJieBtn setFont:[UIFont systemFontOfSize:_myFount]];
        [self.targetTemperature setFont:[UIFont systemFontOfSize:self.wenDuLabelFount]];
        [self.targetTemperatureText setFont:[UIFont systemFontOfSize:20]];
        [self createUI];
        [self addGesture];
        [self showStopFace];
    }
    return self;
}

-(void)createUI{
    //圆心
    self.circleCenterPosition = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.pathProgress_Back = [UIBezierPath bezierPathWithArcCenter:self.circleCenterPosition radius:self.radius  startAngle:-M_PI/2  endAngle:-M_PI/2+(2*M_PI) clockwise:YES];
    self.shapeLayerProgress_Back.path = self.pathProgress_Back.CGPath;
    [self.layer addSublayer:self.shapeLayerProgress_Back];

    
    //进度层
    self.pathProgress = [UIBezierPath bezierPathWithArcCenter:self.circleCenterPosition radius:self.radius  startAngle:-M_PI/2  endAngle:-M_PI/2+(2*M_PI*self.progress) clockwise:YES];
    self.shapeLayerProgress.path = self.pathProgress.CGPath;
    [self.layer addSublayer:self.shapeLayerProgress];
    
    //画手柄
    self.handleBallImageView.center = CGPointMake(self.circleCenterPosition.x,
                                                  self.circleCenterPosition.y-self.radius);
    self.handleBallImageView.image  = [UIImage imageNamed:@"进度小球"];
    
    //阴影
    self.handleBallImageView.layer.shadowColor   = [UIColor blackColor].CGColor;//阴影颜色
    self.handleBallImageView.layer.shadowOffset  = CGSizeMake(0, 0);//偏移距离
    self.handleBallImageView.layer.shadowOpacity = 0.5;//不透明度
    self.handleBallImageView.layer.shadowRadius  = 5.0;//半径
}
#pragma mark - 用户事件
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
    LKLog(@"点击点的坐标 x:%f,y:%f",point.x,point.y);
    //计算进度
    [self calculateRrogress:point];
    //刷新位置
    [self refreshPosition:myTap];
}
-(void)userPan:(UIPanGestureRecognizer *)myPan{
    
    CGPoint point = [myPan locationInView:self];
    NSLog(@"拖拽点的坐标 x:%f,y:%f",point.x,point.y);
    
    //计算进度
    [self calculateRrogress:point];
    //刷新位置
    [self refreshPosition:myPan];
}
#pragma mark - set方法相关
-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    if (self.viewState != Connected) {
        self.image=[UIImage imageNamed:@"自助调温_蓝色"];
        return;
    }
    if (self.progress<=0.33) {
        self.image=[UIImage imageNamed:@"自助调温_黄色"];
    }else if (self.progress<=0.66){
        self.image=[UIImage imageNamed:@"自助调温_橙色"];
    }
    else{
        self.image=[UIImage imageNamed:@"自助调温_红色"];
    }
}

/**
 *  展示正在加热的界面
 *
 *  @param targetTemp 目标温度
 *  @param restTime   定时剩余时间
 */
#pragma mark - 显示正在加热的界面
-(void)showHeatingFace_targetTemp:(NSInteger)targetTemp{
    if (self.timer != nil) {
        [self.timer invalidate];
    }
    _viewState = Connected;
    
    //当前温度
    self.targetTemperature.hidden          = NO;
    self.targetTemperatureText.hidden      = NO;
    self.muBiaoLabel.hidden                = NO;
    self.lianJieBtn.userInteractionEnabled = NO;
    self.lianJieBtn.hidden                 = YES;
    self.isconnectingLabel.hidden          = YES;
    self.ConnectionProgressLabel.hidden    = YES;
    
    //颜色
    if (self.progress<=0.33) {
        self.image=[UIImage imageNamed:@"自助调温_黄色"];
    }else if (self.progress<=0.66){
        self.image=[UIImage imageNamed:@"自助调温_橙色"];
    }
    else{
        self.image=[UIImage imageNamed:@"自助调温_红色"];
    }
    float targTemp = (float)targetTemp;
    [self refreshHandle_muBiaoTemp:targTemp];
    self.targetTemperature.text = [NSString stringWithFormat:@"%.0f",targTemp];
}

#pragma mark - 显示正在连接界面
-(void)showConnectingFace{
    if (self.timer != nil) {
        //销毁定时器
        [self.timer invalidate];
    }
    _viewState = Connecting;
    self.timer                             = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(everyTime) userInfo:nil repeats:YES];
    self.connectProgress                   = 0;
    self.image=[UIImage imageNamed:@"自助调温_蓝色"];
    self.targetTemperature.hidden          = YES;
    self.targetTemperatureText.hidden      = YES;
    self.muBiaoLabel.hidden                = YES;
    self.lianJieBtn.userInteractionEnabled = NO;
    self.lianJieBtn .hidden                = YES;
    self.ConnectionProgressLabel.hidden    = NO;
    self.isconnectingLabel.hidden          = NO;
    self.isconnectingLabel .text           = LK(@"正在连接中");
}

#pragma mark - 显示停止加热的界面
-(void)showStopFace{
    if (self.timer != nil) {
        //销毁定时器
        [self.timer invalidate];
    }
    _viewState = Disconnect;
    
    self.isconnectingLabel.hidden          = YES;
    self.ConnectionProgressLabel .hidden   = YES;
    self.targetTemperature.hidden          = YES;
    self.targetTemperatureText.hidden      = YES;
    self.muBiaoLabel.hidden                = YES;
    self.image=[UIImage imageNamed:@"自助调温_蓝色"];
    self.lianJieBtn .hidden                = NO;
    self.lianJieBtn.userInteractionEnabled = YES;
    [self.lianJieBtn setTitle:LK(@"连接") forState:UIControlStateNormal];
    [self.lianJieBtn addTarget:self action:@selector(lianJieBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 连接按钮点击
-(void)lianJieBtnClick:(UIButton *)btn{
    if (App_Manager.heatState == YiJian_heat) {
         if (_delegate && [_delegate respondsToSelector:@selector(disconnectStateEvent)]) {
                [_delegate disconnectStateEvent];
        }

    }else {
         if (_delegate && [_delegate respondsToSelector:@selector(ConnectClick)]) {
                [_delegate ConnectClick];
        }

    }
}
#pragma mark 定时器
-(void)everyTime{
    self.connectProgress += 0.13;
    NSString *str = [NSString stringWithFormat:@"%.0f%%",self.connectProgress];
    self.ConnectionProgressLabel.text = str;
    if (self.connectProgress > 99) {
        if (self.timer != nil) {
            [self.timer invalidate];
        }
        [self showStopFace];
    }
}


#pragma mark - 用户滑动
-(void)refreshPosition:(UIGestureRecognizer *)gesture{
    self.pathProgress              =[UIBezierPath bezierPathWithArcCenter:self.circleCenterPosition radius:self.radius  startAngle:-M_PI/2  endAngle:-M_PI/2+(2*M_PI*self.progress) clockwise:YES] ;
    self.shapeLayerProgress.path    = self.pathProgress.CGPath  ;
    self.handleBallImageView.center = self.handlePosition;
    
    //如果处于一键理疗
    if (App_Manager.heatState == YiJian_heat) {
        if (_delegate && [_delegate respondsToSelector:@selector(disconnectStateEvent)]) {
            [_delegate disconnectStateEvent];
        }
        return;
    }
    
    
    
    
    //如果处于未连接状态
    if (self.viewState != Connected) {
        return;
    }
    
    //刷新目标温度 -- 用户操作中取得
    int incremental                 = (int)30*self.progress;
    int setTemperature              = 30+incremental;
    self.targetTemperature.text     = [NSString stringWithFormat:@"%d",setTemperature];
    self.targetTemperatureText.text = @"℃";
    
    
    
    if (gesture.state == UIGestureRecognizerStateEnded){
            NSInteger wenDu = setTemperature;
             if (_delegate && [_delegate respondsToSelector:@selector(userGesture_wenDu:)]) {
                     [_delegate userGesture_wenDu:wenDu];
             }
    }
}



#pragma mark - 代码改变位置  依据温度
-(void)refreshHandle_muBiaoTemp:(float)Temp{
    dispatch_async(dispatch_get_main_queue(), ^{
        float wenDu = Temp;
    CGFloat myProgress  = (wenDu - 30)/30;
    self.progress = myProgress;
    //计算位置
    if (myProgress == 0) {
        self.handleBallImageView.center = CGPointMake(self.circleCenterPosition.x, self.circleCenterPosition.y-self.radius);
    }
    else if (myProgress == 0.25){
        self.handleBallImageView.center = CGPointMake(self.circleCenterPosition.x+self.radius, self.circleCenterPosition.y);
    }
    else if (myProgress == 0.5){
        self.handleBallImageView.center = CGPointMake(self.circleCenterPosition.x, self.circleCenterPosition.y+self.radius);
    }
    else if (myProgress == 0.75){
        self.handleBallImageView.center = CGPointMake(self.circleCenterPosition.x-self.radius, self.circleCenterPosition.y);
    }
    else if (myProgress == 1){
        myProgress = 0;
        self.handleBallImageView.center = CGPointMake(self.circleCenterPosition.x, self.circleCenterPosition.y-self.radius);
    }
    
    else if (myProgress > 0 && myProgress<0.25){
        CGFloat xuanZhuanHuDu =   2*M_PI*myProgress;//旋转的弧度
        CGFloat x_Position = self.circleCenterPosition.x + self.radius*sin(xuanZhuanHuDu) ;
        CGFloat y_Position = self.circleCenterPosition.y - self.radius*cos(xuanZhuanHuDu) ;
        self.handleBallImageView.center = CGPointMake(x_Position, y_Position);
    }
    else if (myProgress > 0.25 && myProgress<0.5){
        CGFloat xuanZhuanHuDu =   2*M_PI*myProgress - M_PI_2;//旋转的弧度
        CGFloat x_Position = self.circleCenterPosition.x + self.radius*cos(xuanZhuanHuDu) ;
        CGFloat y_Position = self.circleCenterPosition.y + self.radius*sin(xuanZhuanHuDu) ;
        self.handleBallImageView.center = CGPointMake(x_Position, y_Position);
    }
    else if (myProgress > 0.5 && myProgress<0.75){
        CGFloat xuanZhuanHuDu =   2*M_PI*myProgress - M_PI;//旋转的弧度
        CGFloat x_Position = self.circleCenterPosition.x - self.radius*sin(xuanZhuanHuDu) ;
        CGFloat y_Position = self.circleCenterPosition.y + self.radius*cos(xuanZhuanHuDu) ;
        self.handleBallImageView.center = CGPointMake(x_Position, y_Position);
    }
    else if (myProgress > 0.75 && myProgress<1){
        CGFloat xuanZhuanHuDu =   2*M_PI*myProgress - M_PI - M_PI_2;//旋转的弧度
        CGFloat x_Position = self.circleCenterPosition.x - self.radius*cos(xuanZhuanHuDu) ;
        CGFloat y_Position = self.circleCenterPosition.y - self.radius*sin(xuanZhuanHuDu) ;
        self.handleBallImageView.center = CGPointMake(x_Position, y_Position);
    }
    
    //刷新界面
    self.pathProgress              =[UIBezierPath bezierPathWithArcCenter:self.circleCenterPosition radius:self.radius  startAngle:-M_PI/2  endAngle:-M_PI/2+(2*M_PI*self.progress) clockwise:YES] ;
    self.shapeLayerProgress.path   = self.pathProgress.CGPath;
    
    int incremental = (int)30*self.progress;
    int setTemperature = 30+incremental;
    self.targetTemperature.text = [NSString stringWithFormat:@"%d",setTemperature];
        self.targetTemperatureText.text  = @"℃";
  });
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
      if (self.timer != nil) {
           //销毁定时器
           [self.timer invalidate];
      }
      NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
      //移除所有self监听的所有通知
      [nc removeObserver:self];
}

-(UIBezierPath *)pathProgress{
    if (!_pathProgress){
         _pathProgress = [[UIBezierPath alloc] init];
    }
    return _pathProgress;
}
-(CAShapeLayer *)shapeLayerProgress{
    if(!_shapeLayerProgress){
        _shapeLayerProgress             = [CAShapeLayer layer];
        _shapeLayerProgress.strokeColor = shapeLayerProgressColor.CGColor;
        _shapeLayerProgress.fillColor   = [UIColor clearColor].CGColor;
        _shapeLayerProgress.lineWidth   = self.lineWidth;
        _shapeLayerProgress.lineJoin    = kCALineJoinRound;
        _shapeLayerProgress.lineCap     = kCALineCapRound;
    }
    return _shapeLayerProgress;
}
-(UIBezierPath *)pathProgress_Back{
    if (!_pathProgress_Back){
         _pathProgress_Back = [[UIBezierPath alloc] init];
    }
    return _pathProgress_Back;
}
-(CAShapeLayer *)shapeLayerProgress_Back{
    if(!_shapeLayerProgress_Back){
        _shapeLayerProgress_Back             = [CAShapeLayer layer];
        _shapeLayerProgress_Back.strokeColor = [UIColor colorWithWhite:1 alpha:0.3] .CGColor;

        _shapeLayerProgress_Back.fillColor   = [UIColor clearColor].CGColor;
        _shapeLayerProgress_Back.lineWidth   = self.lineWidth;
        _shapeLayerProgress_Back.lineJoin    = kCALineJoinRound;
        _shapeLayerProgress_Back.lineCap     = kCALineCapRound;
    }
    return _shapeLayerProgress_Back;
}
-(UIImageView *)handleBallImageView{
    if (!_handleBallImageView) {
        _handleBallImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.circleCenterPosition.x, self.circleCenterPosition.y-self.radius, self.shouBingRadius, self.shouBingRadius)];
        [self addSubview:_handleBallImageView];
    }
    return _handleBallImageView;
}
-(UILabel *)muBiaoLabel{
    if (!_muBiaoLabel) {
        CGFloat width = self.frame.size.width;
        _muBiaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2-30, width/2+10, 60, 40)];
        _muBiaoLabel.textAlignment = NSTextAlignmentCenter;
        _muBiaoLabel.text =@"目标";
        _muBiaoLabel.font=[UIFont systemFontOfSize:20];
        _muBiaoLabel.textColor=[UIColor whiteColor];
    }
    return _muBiaoLabel;
}
-(UILabel *)targetTemperature{
    if (!_targetTemperature) {
        CGFloat width = self.frame.size.width;
            _targetTemperature = [[UILabel alloc]initWithFrame:CGRectMake(width/2-self.wenDuLabelidth/2-20, width/2-30, self.wenDuLabelidth, 40)];
            _targetTemperature.textAlignment = NSTextAlignmentRight;
       //   _targetTemperature.backgroundColor = [UIColor blueColor];
            _targetTemperature.text = [NSString stringWithFormat:@"--"];
            _targetTemperature.font=[UIFont systemFontOfSize:self.wenDuLabelFount];
            _targetTemperature.textColor=[UIColor whiteColor];
    }
    return _targetTemperature;
}
-(UILabel *)targetTemperatureText{
    if (!_targetTemperatureText) {
        CGFloat width = self.frame.size.width;
        _targetTemperatureText = [[UILabel alloc]initWithFrame:CGRectMake(width/2-self.wenDuTextLabelWidth/2, width/2-30, self.wenDuTextLabelWidth, 40)];
        _targetTemperatureText.textAlignment = NSTextAlignmentLeft;
     // _targetTemperatureText.backgroundColor = [UIColor yellowColor];
        _targetTemperatureText.text = [NSString stringWithFormat:@"℃"];
        _targetTemperatureText.font=[UIFont systemFontOfSize:20];
        _targetTemperatureText.textColor=[UIColor whiteColor];
    }
    return _targetTemperatureText;

}
-(UILabel *)ConnectionProgressLabel{
    if (!_ConnectionProgressLabel) {
        _ConnectionProgressLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, 90,self.frame.size.width, 30)];
        _ConnectionProgressLabel.text=@"23%";
        _ConnectionProgressLabel.textAlignment = NSTextAlignmentCenter;
        _ConnectionProgressLabel.textColor     = [UIColor whiteColor];
        _ConnectionProgressLabel.font          = [UIFont systemFontOfSize:_myFount];
    }
    return _ConnectionProgressLabel;
}
-(UIButton *)lianJieBtn{
    if (!_lianJieBtn) {
         _lianJieBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 90, self.frame.size.width, 30)];
    }
    return _lianJieBtn;
}
-(UILabel *)isconnectingLabel{
    if (!_isconnectingLabel) {
        _isconnectingLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-50, [LKTool getBottomY:self.ConnectionProgressLabel]-10, 100, 30)];
        
        _isconnectingLabel.textColor = [UIColor whiteColor];
        _isconnectingLabel.textAlignment = NSTextAlignmentCenter;
        _isconnectingLabel.font = [UIFont systemFontOfSize:_myFount];
    }
    return _isconnectingLabel;
}


#pragma mark - UI参数
//温度数字显示label宽度
-(CGFloat)wenDuLabelidth{
    return  50;
}

-(CGFloat)wenDuTextLabelWidth{
    return  30;
}

-(CGFloat)wenDuLabelFount{
    return 35;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

    @end

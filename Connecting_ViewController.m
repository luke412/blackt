
//
//  Connecting_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/27.
//  Copyright © 2016年 鲁柯. All rights reserved.
//  正在连接设备界面  连接中

#import "Connecting_ViewController.h"
#import "BoundSetName_ViewController.h"
#import "BlueManager.h"
#import "YiChangManager.h"
@interface Connecting_ViewController ()<ChangeStateDelegate>
{
    NSTimer * _timer;
}
@property (weak, nonatomic ) IBOutlet UILabel        *titleLabel;
@property (nonatomic,strong) MBProgressHUD  *hud;
@property (weak, nonatomic ) IBOutlet UIButton       *isTooSlowBtn;
@property (weak, nonatomic ) IBOutlet UILabel        *percentageLabel;
@property (weak, nonatomic ) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic ) IBOutlet UIButton       *chongLian;

@end

@implementation Connecting_ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self timerRun];
    NSString *mac = App_Manager.QRcodeCacheMac;
    [Blue_Manager smartctionWithMac:mac Sucess:^(NSString *mac) {
        [MBProgressHUD hideHUD];
        //写入衣物名字界面
        BoundSetName_ViewController *boundSetNameVC = [[BoundSetName_ViewController alloc]init];
        [self.navigationController pushViewController:boundSetNameVC animated:NO];
        self.hidesBottomBarWhenPushed=NO;
        [self TimerhuiFu];
        
    } Failure:^(NSString *mac) {
        [self ConnectionFails];
    } andIsRunDelegate:YES];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    //停止连接，连接被用户中断
    [[LGCentralManager sharedInstance] stopScanForPeripherals];
    [_hud removeFromSuperview];
    [self TheLast];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //将控制器放入单例数组保存
    HeatingClothesBLEService *BLEService=[HeatingClothesBLEService sharedInstance];
    BLEService.delegate = self;
    [self setTittleWithText:LK(@"连接设备")];
    [_isTooSlowBtn setTitle:LK(@"连接过慢") forState:UIControlStateNormal];
    _titleLabel.text      = LK(@"正在搜索设备...");
    [_chongLian setTitle:   LK(@"重连") forState:UIControlStateNormal];
    
    //计时器和进度
    self.progressView.progress = 0.0;
    self.percentageLabel.text  = @"0%";
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(everyTime) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,38,30)];
        [rightButton setTitle:@"取消" forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightButtonClick)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
        self.navigationItem.leftBarButtonItem=rightItem;

    
}
#pragma mark - 通知响应
#pragma mark - 蓝牙回调
-(void)ConnectionFails{
    YiChangManager *yiChangManager = [[YiChangManager alloc]init];
    [yiChangManager showViewControllers_vc:self];
}
#pragma mark - 用户事件
-(void)rightButtonClick{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
//连接过慢点击
- (IBAction)isToolSlowClick:(id)sender{
    
}

//点击重连
- (IBAction)chongLian:(id)sender{
    [MBProgressHUD showSuccess:LK(@"重新连接")];
    [self TimerhuiFu];
    //停止连接，连接被用户中断
    [[LGCentralManager sharedInstance] stopScanForPeripherals];
    NSString *mac = App_Manager.QRcodeCacheMac;
    [Blue_Manager smartctionWithMac:mac Sucess:^(NSString *mac) {
        [MBProgressHUD hideHUD];
        //写入衣物名字界面
        BoundSetName_ViewController *boundSetNameVC = [[BoundSetName_ViewController alloc]init];
        [self.navigationController pushViewController:boundSetNameVC animated:NO];
        self.hidesBottomBarWhenPushed=NO;
        [self TimerhuiFu];
        
        
    } Failure:^(NSString *mac) {
        [self ConnectionFails];
    } andIsRunDelegate:YES];
    [self timerRun];
}
#pragma mark - 计时器
-(void)timerRun{
      [_timer setFireDate:[NSDate date]];
}
/**计时器停止*/
-(void)timerStop{
    [_timer setFireDate:[NSDate distantFuture]];
}
/**计时器复位，UI恢复初始状态*/
-(void)TimerhuiFu{
    self.progressView.progress = 0.0;
    self.percentageLabel.text  = @"0%";
    [_timer setFireDate:[NSDate distantFuture]];
}
-(void)everyTime{
    //超时
    if (self.progressView.progress>0.98) {
        [self TimerhuiFu];
    }
    self.progressView.progress += 0.0014;
    self.percentageLabel.text  =[NSString stringWithFormat:@"%.0f%%",self.progressView.progress*100];
}

#pragma mark - 代理
-(void)changeState:(NSString *)text{
    self.titleLabel.text = text;
}
#pragma mark - 清理
-(void)dealloc
{
    [self TheLast];
    
}

//释放定时器,消除通知等善后事宜
-(void)TheLast{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
        if (_timer != nil) {
            //销毁定时器
            [_timer invalidate];
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

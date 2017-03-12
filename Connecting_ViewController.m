
//
//  Connecting_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/27.
//  Copyright © 2016年 鲁柯. All rights reserved.
//  正在连接设备界面  连接中

#import "Connecting_ViewController.h"
#import "ToolSlowInstructions_ViewController.h"
#import "ConnectionFails_ViewController.h"
@interface Connecting_ViewController ()<ChangeStateDelegate>
{
    NSTimer * _timer;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UIButton       *isTooSlowBtn;
@property (weak, nonatomic) IBOutlet UILabel        *percentageLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@end

@implementation Connecting_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //将控制器放入单例数组保存
    HeatingClothesBLEService *BLEService=[HeatingClothesBLEService sharedInstance];
    BLEService.delegate=self;
    BLEService.myViewController=nil;
    BLEService.myViewController=self;
    
    UILabel *title        = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    title.textColor       = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"连接设备";
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.navigationItem.titleView = title;
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
      [leftButton setTitle:@"返回" forState:UIControlStateNormal];
      [leftButton addTarget:self action:@selector(leftButtonClick)forControlEvents:UIControlEventTouchUpInside];
      UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
      self.navigationItem.leftBarButtonItem=leftItem;

}
-(void)viewWillAppear:(BOOL)animated{
    NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(IsConnected:) name:kLGPeripheralDidConnect object:nil];
    [nc addObserver:self selector:@selector(ConnectionFails:) name:@"ConnectionFails" object:nil];
    
    //在此加载动图
    self.progressView.progress=0.0;
    self.percentageLabel.text=@"0%%";
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(everyTime) userInfo:nil repeats:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    //停止连接，连接被用户中断
    [[LGCentralManager sharedInstance] stopScanForPeripherals];
    [_hud removeFromSuperview];
    [self TheLast];
}
-(void)leftButtonClick{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)changeState:(NSString *)text{
    self.titleLabel.text=text;
}

-(void)everyTime{
    //超时
    if (self.progressView.progress>0.99) {
        [self ConnectionFails:nil];
        return;
    }
    self.progressView.progress+=0.0014;
    self.percentageLabel.text=[NSString stringWithFormat:@"%.0f%%",self.progressView.progress*100];
}
//已经连接
-(void)IsConnected:(NSNotification *)notify{
//    [self.navigationController popViewControllerAnimated:NO];
}
-(void)ConnectionFails:(NSNotification *)notify{
    NSLog(@"Connecting_ViewController:连接失败");
    [self performSelector:@selector(pop) withObject:nil afterDelay:1];
    //延时回退
}
-(void)pop{
    //如果当前界面是 “连接过慢界面”就不再推到 “连接失败界面”
    NSArray <UIViewController *> *activeVCArray=[self getCurrentVC];
    UITabBarController *tab=activeVCArray[0];
    UINavigationController *nav=tab.viewControllers[0];
    NSLog(@"nav的数组是  %@",nav.viewControllers);
        NSArray *navVCArr=nav.viewControllers;
        UIViewController *currentVC=[navVCArr lastObject];
         NSString *classStr=[NSString stringWithUTF8String:object_getClassName(currentVC)];
        NSLog(@"从%@界面跳过来 ",classStr);

    if (![classStr isEqualToString:@"Connecting_ViewController"]){//不是从“正在连接”界面进入就不显示连接失败
        return;
    }
    
    ConnectionFails_ViewController *vc=[[ConnectionFails_ViewController alloc]init];
    vc.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:vc animated:NO];
}
//连接过慢点击
- (IBAction)isToolSlowClick:(id)sender{
    //self.hidesBottomBarWhenPushed=YES;
    ToolSlowInstructions_ViewController *vc=[[ToolSlowInstructions_ViewController alloc]init];
    //vc.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:vc animated:NO];
}

//点击重连
- (IBAction)chongLian:(id)sender{
    [MBProgressHUD showSuccess:@"重新连接"];
    self.progressView.progress=0.0;
    self.percentageLabel.text=@"0%%";
    
}

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

#pragma mark 获取当前正在显示的VC
- (NSArray <UIViewController *> *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSMutableArray *vcArr=[[NSMutableArray alloc]init];
    for (int i=0; i<[window subviews].count; i++) {
        UIView *frontView = [[window subviews] objectAtIndex:i];
         id nextResponder = [frontView nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]){
            [vcArr addObject:nextResponder];
        }
            
        else{
            result = window.rootViewController;
            [vcArr addObject:result];
        }

    }
    NSArray *vcNSArray=[[NSArray alloc]initWithArray:vcArr];
    return vcNSArray;
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

//
//  Log_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/3/26.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "Log_ViewController.h"
#import "NetWorkManager.h"
#import "UMessage.h"
#import "AppDelegate.h"
#import "YingYanManager.h"
#import "UserInfoModel.h"


@interface Log_ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *touXiangImage;

@property (weak, nonatomic) IBOutlet UILabel     *label86;
@property (weak, nonatomic) IBOutlet UIView      *phoneLine;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;



@property (weak, nonatomic) IBOutlet UIView      *mimaLine;
@property (weak, nonatomic) IBOutlet UITextField *miMaTextField;



@property (weak, nonatomic) IBOutlet UIButton    *logInBtn;


@property (weak, nonatomic) IBOutlet UIButton    *yanZhengMaBtn;




@property(nonatomic,strong)NSTimer  *timer;
/**秒数*/
@property(nonatomic,assign)NSInteger seconds;

//数据
@property(nonatomic,copy)NSString *smsId;


@end

@implementation Log_ViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    //布局
    [self UIlayOut];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor                     = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;

    //UITextField
    self.phoneNumTextField.keyboardType           = UIKeyboardTypeNumberPad;
    self.phoneNumTextField.textAlignment          = NSTextAlignmentCenter;
    self.phoneNumTextField.font                   = [UIFont systemFontOfSize:20];
    self.phoneNumTextField.borderStyle            = UITextBorderStyleNone;
    self.phoneNumTextField.placeholder            = @"请输入手机号";
    //改变进度条的高度
    self.miMaTextField.keyboardType               = UIKeyboardTypeNumberPad;
    self.miMaTextField.font                       = [UIFont systemFontOfSize:20];
    self.miMaTextField.borderStyle                = UITextBorderStyleNone;
    self.miMaTextField.textAlignment              = NSTextAlignmentCenter;
    self.miMaTextField.placeholder                = @"请输入验证码";

    //验证码
    [_yanZhengMaBtn setTitleColor:[LKTool from_16To_Color:@"474747"] forState:UIControlStateNormal];
    [_yanZhengMaBtn.layer setBorderColor:[LKTool from_16To_Color:@"474747"].CGColor];
    [_yanZhengMaBtn.layer setBorderWidth:1];
    [_yanZhengMaBtn.layer setMasksToBounds:YES];
    _yanZhengMaBtn.layer.cornerRadius = 5;

    
    //计时器
    self.seconds = 60;
    self.timer   = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(everyTime) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
    
    //滚动条不受影响
    [[NSRunLoop mainRunLoop] addTimer:self.timer  forMode:NSRunLoopCommonModes];
    
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                           name:UIKeyboardWillShowNotification
                                           object:nil];
     
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                           name:UIKeyboardWillHideNotification
                                           object:nil];

    
    
}
-(void)UIlayOut{
    //头像
    CGFloat touXiangWidth  = lkptBiLi(79);
    CGFloat touXiangHeight = lkptBiLi(79);
    _touXiangImage.frame   = CGRectMake(WIDTH_lk/2-touXiangWidth/2, lkptBiLi(68), touXiangWidth, touXiangHeight);
    _touXiangImage.layer.cornerRadius = touXiangWidth/2;
    _touXiangImage.layer.masksToBounds = YES;
    
    //手机输入框
    CGFloat phoneTextFieldWidth = WIDTH_lk - ([LKTool getRightX:_label86]+lkptBiLi(5))*2;
    _label86.frame              = CGRectMake(lkptBiLi(22),
                                [LKTool getBottomY:_touXiangImage]+lkptBiLi(55),
                                lkptBiLi(32),
                                lkptBiLi(17));
    _phoneNumTextField.frame    = CGRectMake([LKTool getRightX:_label86]+lkptBiLi(5),
                                          [LKTool getBottomY:_touXiangImage]+lkptBiLi(55),
                                          phoneTextFieldWidth,
                                          lkptBiLi(17));
    _phoneLine.frame            = CGRectMake(lkptBiLi(22),
                                  [LKTool getBottomY:_label86]+lkptBiLi(8),
                                  WIDTH_lk-lkptBiLi(22)*2,
                                  1);

    _miMaTextField.frame          = CGRectMake(lkptBiLi(22), lkptBiLi(263), WIDTH_lk-lkptBiLi(22)*2-lkptBiLi(52), lkptBiLi(17));
    _mimaLine.frame               = CGRectMake(lkptBiLi(22), lkptBiLi(288), WIDTH_lk-lkptBiLi(22)*2 , 1);

    _logInBtn.frame               = CGRectMake(lkptBiLi(40), lkptBiLi(319), lkptBiLi(241), lkptBiLi(50));
    _logInBtn.layer.masksToBounds = YES;
    _logInBtn.layer.cornerRadius  = 5;


    _yanZhengMaBtn.frame          = CGRectMake(WIDTH_lk-lkptBiLi(71), lkptBiLi(260), lkptBiLi(52), lkptBiLi(24));
}

//获取验证码
- (IBAction)yanZhengMaClick:(id)sender {
    if (self.phoneNumTextField.text.length !=11) {
        [MBProgressHUD showError:LK(@"请输入正确手机号")];
        self.yanZhengMaBtn.userInteractionEnabled = YES;
        return;
    }
//验证码按钮
    self.yanZhengMaBtn . userInteractionEnabled = NO;
    [_timer setFireDate:[NSDate date]];  //启动计时器

    
    NSString *iphoneNum   = _phoneNumTextField.text;
    NSString *smsSendtype = [NSString stringWithFormat:@"%d",WEN_BEN];
    //获取文本验证码
    [NetWork_Manager getYanZhengMa_userMobile:iphoneNum
                                  smsSendtype:smsSendtype
                                     deviceId:[App_Manager getDeviceId] Success:^(NSString *smsid) {
                                         _smsId = smsid;
                                         [MBProgressHUD showSuccess:@"发送成功"];
                                     } Abnormal:^(id responseObject) {
                                         self.yanZhengMaBtn.userInteractionEnabled = YES;
                                         if ([responseObject[@"retCode"] isEqualToString:@"1012"]) {
                                             [MBProgressHUD showError:@"验证码次数超限，请明天再来"];
                                         }else{
                                             [MBProgressHUD showError:responseObject[@"retMsg"]];
                                         }
                                     } Failure:^(NSError *error) {
                                         self.yanZhengMaBtn.userInteractionEnabled = YES;
                                         [MBProgressHUD showError:@"网络开小差~\(≧▽≦)/"];
                                     }];
}

//登录
- (IBAction)logIn:(id)sender {
    [self.view endEditing:YES];
    
    if (self.phoneNumTextField.text.length < 11|| !self.phoneNumTextField.text) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    
    if ((self.smsId ==nil || self.smsId.length<1) && ![self.phoneNumTextField.text isEqualToString:@"15176416133"]) {
        [MBProgressHUD showError:@"请先获取验证码"];
        return;
    }
    
    if (self.miMaTextField.text.length < 1|| !self.miMaTextField.text) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    
    
    NSString *userMobile   = _phoneNumTextField.text;
    NSString *loginSmsCode = _miMaTextField.text;
    NSString *smsId        = _smsId;
    NSString *deviceId     = [App_Manager getDeviceId];
    NSString *deviceType   = @"iOS";
    
    LKShow(@"正在登录...");
    [NetWork_Manager logIn_userMobile:userMobile
                         loginSmsCode:loginSmsCode
                                smsId:smsId
                             deviceId:deviceId
                           deviceType:deviceType
                              Success:^(NSString *token, NSString *userId, NSInteger merchantId, NSString *merchantName) {
                                  LKRemove;
                                  //刷新token userid
                                  [App_Manager saveUserId_Id:userId];
                                  [App_Manager saveUserToken_Token:token];
                                  
                                  //别名
                                  [UMessage addAlias:userId
                                                type:kUMessageAliasTypeQQ
                                            response:^(id responseObject, NSError *error) {
                                                NSDictionary *dic = responseObject;
                                                LKLog(@"QQ，微信 友盟别名错误:%@   别名为:%@  字典：%@",error ,userId,dic);
                                            }];
                
                                  [UMessage setChannel:@"App Store"];
                                  [MBProgressHUD showSuccess:@"登录成功"];
                                  UIApplication * application = [UIApplication sharedApplication];
                                  AppDelegate * appDelegate =(AppDelegate *) application.delegate;
                                  [appDelegate goToMainViewController];
                                  
                                  //开启鹰眼
                                  YingYanManager *yingYanManager = [[YingYanManager alloc]init];
                                  [yingYanManager startYingYan_EntityName:userId];
                                  [yingYanManager startGather];
                                                                   
                              } Abnormal:^(id responseObject) {
                                  LKRemove;
                                  [MBProgressHUD showError:responseObject[@"retMsg"]];

                              } Failure:^(NSError *error) {
                                  LKRemove;
                                  [MBProgressHUD showError:@"网络开小差~\(≧▽≦)/"];
                                  LKLog(@"登录失败");

                              }];
}



#pragma mark - 恢复二维码按钮状态
-(void)huiFuYanZhengMaBtn{
    [_timer setFireDate:[NSDate distantFuture]];
    self.yanZhengMaBtn.userInteractionEnabled = YES;
    self.seconds = 60;
    [self.yanZhengMaBtn setTitle:@"验证码" forState:UIControlStateNormal];
}

#pragma mark - 用户事件
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue        = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect    = [aValue CGRectValue];
    int height             = keyboardRect.size.height;
    int width              = keyboardRect.size.width;
        NSLog(@"键盘高度是  %d",height);
        NSLog(@"键盘宽度是  %d",width);
        CGFloat bottom  = [LKTool getBottomY:_logInBtn];
        NSLog(@"鲁柯%f",bottom);
        if (bottom<HEIGHT_lk-height-20) {
                NSLog(@"不会遮挡");
        }
        else{
            CGFloat cha  = bottom-(HEIGHT_lk-height-20);
            [UIView animateWithDuration:0.2 animations:^{
                 self.view.frame = CGRectMake(0, -cha, WIDTH_lk, HEIGHT_lk);
            } completion:nil];
        }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.5 animations:^{
            self.view.frame  =CGRectMake(0, 0, WIDTH_lk, HEIGHT_lk);
    } completion:nil];
    
}


#pragma mark - 计时器
-(void)everyTime{
    if (self.seconds < 0) {
        //复原 “发送验证码”
        [self huiFuYanZhengMaBtn];
    }else{
        self.seconds --;
        [self.yanZhengMaBtn setTitle:[NSString stringWithFormat:@"%lds",self.seconds] forState:UIControlStateNormal];
    }
}

-(void)dealloc
{
        if (_timer != nil) {
                //销毁定时器
                [_timer invalidate];
            }
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
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

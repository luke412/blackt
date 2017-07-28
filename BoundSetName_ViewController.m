//
//  BoundSetName_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/27.
//  Copyright © 2016年 鲁柯. All rights reserved.
//  绑定衣物2界面  写入衣物名字界面   写入衣物名称界面

#import "BoundSetName_ViewController.h"
#import "DataBaseManager.h"
#import "BlueManager.h"


@interface BoundSetName_ViewController ()<UIScrollViewDelegate>
{
    UIScrollView   *scrollw;
    NSArray        *nameArr;
    NSArray        *imagesArray;
    NSArray        *deviceStyleArr;   //设备类型
    NSString       *myDeviceStyle;
    UIPageControl  *pageControl;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField; //名字textfield
@property (weak, nonatomic) IBOutlet UIView      *lineView;
@property (weak, nonatomic) IBOutlet UIButton    *queDingBtn;
@property(nonatomic,copy)   NSString             *myTitle;
@end

@implementation BoundSetName_ViewController
-(void)awakeFromNib{
    [super awakeFromNib];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self.nameTextField becomeFirstResponder];
    self.nameTextField.text = [self deviceQuMing];
}

//设备取名
-(NSString *)deviceQuMing{
    NSArray *devices = [DataBase_Manager getAllBoundDevice];
    BOOL isFinish = NO;
    for (NSInteger i=0; i<10000; i++) {
        isFinish = NO;
        NSString *name = [NSString stringWithFormat:@"设备%ld",i];
        for (NSInteger i=0;i<devices.count;i++){
            DeviceModel *device = devices[i];
            if ([name isEqualToString:device.clothesName]) {
                break;
            }
            
            if (i+1 == devices.count) {
                isFinish = YES;
            }
        }
        if (isFinish == YES) {
            return name;
        }
    }
    return @"设备1";
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTittleWithText:LK(@"添加设备")];
    [self UIlayOut];
}
-(void)UIlayOut{
    //textfield
    CGFloat textFieldLeft = lkptBiLi(26);
    _nameTextField .frame = CGRectMake(textFieldLeft, lkptBiLi(183), WIDTH_lk-2*textFieldLeft, lkptBiLi(20));
    
    //line
    _lineView.frame  = CGRectMake(lkptBiLi(26), lkptBiLi(215), WIDTH_lk-2*textFieldLeft, 1);
    
    //确定按钮
    _queDingBtn.frame = CGRectMake(lkptBiLi(40), lkptBiLi(303), lkptBiLi(241), lkptBiLi(50));
    _queDingBtn.layer .cornerRadius  = 5;
    
    self.navigationItem.hidesBackButton = YES;
      UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,38,30)];
        [rightButton setTitle:@"取消" forState:UIControlStateNormal];
    [rightButton setTitleColor:[LKTool from_16To_Color:tableViewCellTextColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightButtonClick)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
        self.navigationItem.leftBarButtonItem=rightItem;
    
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

#pragma mark - 键盘监听
- (void)keyboardWillShow:(NSNotification *)aNotification
{
        NSDictionary *userInfo = [aNotification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        int height = keyboardRect.size.height;
        int width = keyboardRect.size.width;
        NSLog(@"键盘高度是  %d",height);
        NSLog(@"键盘宽度是  %d",width);
    
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
        CGRect firstResponderRect=[firstResponder convertRect:firstResponder.bounds toView:self.view];
        
        CGFloat bottom=  [LKTool getBottomY:_queDingBtn];
        if (bottom<HEIGHT_lk-height-20) {
                NSLog(@"不会遮挡");
            }
        else{
                CGFloat cha=bottom-(HEIGHT_lk-height-20);
                NSLog(@"cha:%f",cha);
                self.view.frame=CGRectMake(0, -cha, WIDTH_lk, HEIGHT_lk);
                
            }
}
 
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
     self.view.frame = CGRectMake(0, 0, WIDTH_lk, HEIGHT_lk);
}

-(void)rightButtonClick{
    [self.navigationController popToRootViewControllerAnimated:NO];
    NSString *mac = App_Manager.QRcodeCacheMac;
    [Blue_Manager disconnectWithMac:mac Sucess:nil Failure:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD showSuccess:@"已取消"];
    });
}
#pragma mark - 用户事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)queDingClick:(id)sender {
    if (self.nameTextField.text.length<1) {
        [MBProgressHUD showError:LK(@"设备名称不能为空")];
        return;
    }
    if (self.nameTextField.text.length>15) {
        [MBProgressHUD showError:LK(@"字符长度超过15位")];
        return;
    }
    
    NSMutableString *mutStr = [[NSMutableString alloc]initWithString:self.nameTextField.text];
    NSString *str           = [LKTool stringDeleteString:@" " fromStr:mutStr];
    if (str.length < 1){
        [MBProgressHUD showError:LK(@"名称不能为空")];
        return;
    }

    //重名筛查
    //检验是否重名
    NSArray <DeviceModel *>*devices = [DataBase_Manager getAllBoundDevice];
    for (DeviceModel *model in devices) {
        if ([self.nameTextField.text isEqualToString:model.clothesName]) {
            [MBProgressHUD showError:LK(@"此名称已被占用，请重新输入")];
            self.nameTextField.text=@"";
            return;
        }
    }

    //上报mac
    NSString *mac = [App_Manager.QRcodeCacheMac uppercaseString];
    NSString *userId    = [App_Manager getUserId];
    NSString *userToken = [App_Manager getUserToken];
    NSString *deviceid  = [App_Manager getDeviceId];
    LKShow(@"正在绑定...");
    [NetWork_Manager macBind_userId:userId
                          userToken:userToken
                           deviceId:deviceid
                              macNo:mac
                         bindStatus:BangDing
                            Success:^(id responseObject) {
                                LKRemove;
                                //插入数据库
                                [self addDataBase_mac:mac];
                            }Abnormal:^(id responseObject) {
                                LKRemove;
                                [MBProgressHUD showError:responseObject[@"retMsg"]];
                            }Failure:^(NSError *error) {
                                LKRemove;
                                [MBProgressHUD showError:@"网络开小差~\(≧▽≦)/"];
                            }];
}

-(void)addDataBase_mac:(NSString *)mac{
    
    BOOL isOk     = [DataBase_Manager addDeviceTodataBase_mac:mac andName:self.nameTextField.text andType:@""];
    if (isOk) {
        DeviceModel *device    = [[DeviceModel alloc]init];
        device.clothesMac      = mac;
        device.clothesName     = self.nameTextField.text;
        device.deviceType      = @"";
        App_Manager.currDevice = device;
        [MBProgressHUD showSuccess:LK(@"绑定成功")];
        double delayInSeconds = 1.2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime,   dispatch_get_main_queue(), ^(void){
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:BindingSuccess_tongZhi  object:nil];
            [self.navigationController popToRootViewControllerAnimated:NO];
        });
    }else {
        [MBProgressHUD showSuccess:LK(@"绑定失败")];
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

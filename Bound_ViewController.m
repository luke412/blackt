//
//  Bound_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/26.
//  Copyright © 2016年 鲁柯. All rights reserved.
//  绑定界面  绑定衣物界面
//  请扫码界面

#import "Bound_ViewController.h"
#import "ZFScanViewController.h"    //二维码扫码
#import "BoundSetName_ViewController.h" //输入衣物名字界面
#import "Connecting_ViewController.h"//正在连接设备界面
#import "AppDelegate.h"
@interface Bound_ViewController ()
{
    ZFScanViewController * vc;
    int SearchNumber;
}
@property (weak, nonatomic) IBOutlet UIButton *notBoundBtn;
@property (weak, nonatomic) IBOutlet UIButton *scanQRCodeBtn;
@property(nonatomic,strong) HeatingClothesBLEService *BLEService;
@property (weak, nonatomic) IBOutlet UIImageView *centerImage;

@end

@implementation Bound_ViewController
-(HeatingClothesBLEService *)BLEService{
    if (!_BLEService) {
        _BLEService=[HeatingClothesBLEService sharedInstance];
    }
    return _BLEService;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    SearchNumber=0;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"绑定衣物";
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.navigationItem.titleView = title;
    
    
    //右按钮
    
        UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,80,30)];
    
        [rightButton setTitle:@"暂不绑定" forState:UIControlStateNormal];
        rightButton.titleLabel.font    = [UIFont systemFontOfSize: 14];

        rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [rightButton addTarget:self action:@selector(rightButtonClick)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem=rightItem;
    
    //按钮边框
//    [_scanQRCodeBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
//        [_scanQRCodeBtn.layer setBorderWidth:1];
//        [_scanQRCodeBtn.layer setMasksToBounds:YES];
    
    vc = [[ZFScanViewController alloc] init];
    
    //添加监听
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(ConnectionSuccessful:) name:@"ConnectionSuccessful" object:nil];

    //扫码按钮颜色
    _scanQRCodeBtn.layer.masksToBounds =YES;
    _scanQRCodeBtn.layer.cornerRadius =10;
    _scanQRCodeBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
     //[_scanQRCodeBtn setTitleColor:[LKTool from_16To_Color:@"f18c00"] forState:UIControlStateNormal];
    // _scanQRCodeBtn.backgroundColor=[LKTool from_16To_Color:@"f4527c"];
}
//暂不绑定 右按钮
-(void)rightButtonClick{
    [self.navigationController popViewControllerAnimated:NO];
}

//扫码
- (IBAction)scanQRCode:(id)sender{
        [vc setHidesBottomBarWhenPushed:YES];
        __weak typeof (vc)weakvc = vc;
        weakvc.returnScanBarCodeValue = ^(NSString * barCodeString){
        NSLog(@"二维码：%@",barCodeString);
        NSString *Mac=[[LKDataBaseTool sharedInstance]parsingQRcodeReturnMacWithQRStr:barCodeString];
        if (Mac.length!=12){
            [self showQRError];//二维码数据错误---用户扫错码了
            return;
        }
        NSArray<ClothesModel*> *clothesArr=[[LKDataBaseTool sharedInstance] isExistInTheTable:Mac];
        //如果已经绑定过
        if (clothesArr.count>0){
            [MBProgressHUD hideHUD];
            [self showPopupWindowWithArr:clothesArr];
        }else if(clothesArr.count==0||!  clothesArr){
            //如果未绑定
            [MBProgressHUD hideHUD];
            //1.检验mac
            [self BluetoothOperationWithMac:Mac];
        }
            };
        [self.navigationController pushViewController:weakvc animated:YES];
}
-(void)showPopupWindowWithArr:(NSArray *)clothesModelArr{
    NSMutableString *mutstr=[[NSMutableString alloc]init];
    for (ClothesModel *model in clothesModelArr) {
        [mutstr appendFormat:@"%@ ",model.clothesName];
    }
    NSString *message=[NSString stringWithFormat:@"此衣物已绑定,名称为“%@”",mutstr];//显示衣物名字
    [MBProgressHUD showError:message];
    [self performSelector:@selector(pop) withObject:nil afterDelay:1.5];
}
-(void)pop{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
//mac验证失败
-(void)showPopupWindow2{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"Mac地址验证失败" preferredStyle:UIAlertControllerStyleAlert];
       UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                          }];
        [alertVc addAction:cancle];
        [self presentViewController:alertVc animated:YES completion:^{
                
        
         }];
}
//蓝牙操作
-(void)BluetoothOperationWithMac:(NSString *)macStr{
    //将要绑定的mac写入单例数组
    [[LKDataBaseTool sharedInstance].macArray addObject:macStr];
    HeatingClothesBLEService *BLEService = [HeatingClothesBLEService sharedInstance];
    BLEService.SearchNumber=0;
    self.hidesBottomBarWhenPushed=NO;
    Connecting_ViewController *contVC = [[Connecting_ViewController alloc]init];
    contVC.macAdress=macStr;
    contVC.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:contVC animated:NO];
    self.hidesBottomBarWhenPushed=NO;
    BLEService.isBound=YES;
    [BLEService StartScanningDeviceWithMac:macStr];
}
-(void)ConnectionSuccessful:(NSNotification *)notify
{
    BoundSetName_ViewController *bound_vc=[[BoundSetName_ViewController alloc]init];
    bound_vc.macAddress=notify.object;
    [self.navigationController pushViewController:bound_vc animated:NO];

}

-(void)showQRError{
    [MBProgressHUD hideHUD];
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请扫描标注“设备地址”的二维码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
         [vc.session startRunning];//再次扫描
    }];
        [alertVc addAction:cancle];
        [self presentViewController:alertVc animated:YES completion:^{
                nil;
            }];
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

//
//  TianJia_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/7.
//  Copyright © 2017年 鲁柯. All rights reserved.
//


#import "TianJia_ViewController.h"
#import "ZFScanViewController.h"         //二维码扫码

#import "BlueManager.h"
#import "DataBaseManager.h"
#import "Connecting_ViewController.h"
@interface TianJia_ViewController ()
{
    ZFScanViewController * vc;
    __weak IBOutlet UIView *backView;
    __weak IBOutlet UIImageView *imageVC;
    __weak IBOutlet UILabel *textLabel;
    __weak IBOutlet UIButton *saoMaBtn;
}

@end

@implementation TianJia_ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    //判断蓝牙
    NSString *blueState = [LGCentralManager sharedInstance].stateMessage;
    if ([blueState isEqualToString:@"蓝牙关闭状态"]) {
        WinManager *winManager = [[WinManager alloc]init];
        [winManager showWin_bluePoweredOff];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTittleWithText:LK(@"添加设备")];
    [self layOutUI];
}
-(void)layOutUI{
    self.view.backgroundColor = [LKTool from_16To_Color:BACK_COLOR_new];
    
    //back
    CGFloat leftBianJu = lkptBiLi(5);
    CGFloat upJianJu   = lkptBiLi(76);
    CGFloat backWitdh  = lkptBiLi(310);
    CGFloat backHeight = lkptBiLi(483);
    backView.frame = CGRectMake(leftBianJu, upJianJu, backWitdh, backHeight);
    
    
    //image
    CGFloat imageLeftjU = lkptBiLi(54);
    CGFloat imageUpJu   = lkptBiLi(20);
    CGFloat imageWidth  = backWitdh - imageLeftjU*2;
    CGFloat imageHeight = imageWidth;
    imageVC.frame       = CGRectMake(imageLeftjU, imageUpJu, imageWidth, imageHeight);
    
    
    //label
    CGFloat labelWidth = backWitdh;
    CGFloat labelHeight = lkptBiLi(50);
    CGFloat labelY      = lkptBiLi(317);
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.frame     = CGRectMake(0, labelY, labelWidth, labelHeight);
    
    
    
    //圆角
    CGFloat saoMaWidth           = lkptBiLi(241);
    CGFloat saoMaHeight          = lkptBiLi(50);
    saoMaBtn.frame               = CGRectMake(WIDTH_lk/2-saoMaWidth/2, lkptBiLi(360) + 64, saoMaWidth, saoMaHeight);
    saoMaBtn.layer.masksToBounds = YES;
    saoMaBtn.layer.cornerRadius  = 5;
    
}
//扫描二维码
- (IBAction)saoMiao:(id)sender {
    vc = [[ZFScanViewController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];
        __weak typeof (vc)weakvc = vc;
        weakvc.returnScanBarCodeValue = ^(NSString * barCodeString){
                LKLog(@"二维码：%@",barCodeString);
                NSString *Mac=[Blue_Manager getMacFromQRcode:barCodeString];
                if (Mac.length!=12){
                    [self showQRError];//二维码数据错误---用户扫错码了
                    return;
                }
                NSArray<DeviceModel*> *clothesArr=[DataBase_Manager isExistInTheTable:Mac];
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
//蓝牙操作
-(void)BluetoothOperationWithMac:(NSString *)macStr{
    //将要绑定的mac写入单例数组
    App_Manager.QRcodeCacheMac            = macStr;
    self.hidesBottomBarWhenPushed         = NO;
    Connecting_ViewController *contVC     = [[Connecting_ViewController alloc]init];
    contVC.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:contVC animated:NO];
    self.hidesBottomBarWhenPushed         = NO;
}
-(void)showPopupWindowWithArr:(NSArray *)clothesModelArr{
    NSMutableString *mutstr = [[NSMutableString alloc]init];
    for (DeviceModel *model in clothesModelArr) {
        [mutstr appendFormat:@"%@ ",model.clothesName];
    }
    NSString *message = [NSString stringWithFormat:@"%@“%@”",LK(@"此设备已绑定,名称为"),mutstr];//显示衣物名字
    [MBProgressHUD showError:message];
    [self performSelector:@selector(pop) withObject:nil afterDelay:1.5];
}
-(void)pop{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)showQRError{
    [MBProgressHUD hideHUD];
    LKAlertController  *alertVc = [LKAlertController  alertControllerWithTitle:LK(@"温馨提示") message:LK(@"请扫描标注“设备地址”的二维码") preferredStyle:UIAlertControllerStyleAlert];
        LKAlertAction  *cancle = [LKAlertAction  actionWithTitle:LK(@"知道了") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
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

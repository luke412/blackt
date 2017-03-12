
//
//  ConnectionFails_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/27.
//  Copyright © 2016年 鲁柯. All rights reserved.
//  连接失败界面

#import "ConnectionFails_ViewController.h"
#import "ToolSlowInstructions_ViewController.h"//连接步骤，连接过慢界面
@interface ConnectionFails_ViewController ()

@end

@implementation ConnectionFails_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"连接失败";
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.navigationItem.titleView = title;
    
    //左按钮
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,60,30)];
        [leftButton setTitle:@"返回" forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftButtonAnswer)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem=leftItem;

}

//找找原因
- (IBAction)ToFindTheReason:(id)sender{
    ToolSlowInstructions_ViewController *vc=[[ToolSlowInstructions_ViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}

//
-(void)leftButtonAnswer{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
//重新连接 重连
- (IBAction)ConnectAgain:(id)sender{
    //判断是否已有设备绑定，以此执行相应的搜索
    NSArray *devices=[[LKDataBaseTool sharedInstance]showAllDataFromTable:nil];
    if (devices.count<1||devices==nil) {
        NSMutableArray *arr=[LKDataBaseTool sharedInstance].macArray;
        if (arr.count>0) {
            [[LGCentralManager sharedInstance]stopScanForPeripherals];
            [HeatingClothesBLEService sharedInstance].SearchNumber=0;
            [HeatingClothesBLEService sharedInstance].isBound=YES;
            [[HeatingClothesBLEService sharedInstance]StartScanningDeviceWithMac:arr[0]];
            [self.navigationController popViewControllerAnimated:NO];
        }else{
            NSLog(@"重连的时候没有找到mac地址！");
        }
    }else{
        [HeatingClothesBLEService sharedInstance].SearchNumber=0;
        [HeatingClothesBLEService sharedInstance].isBound=NO;
        [[HeatingClothesBLEService sharedInstance]StartScanningDeviceWithMac:nil];
        [self.navigationController popViewControllerAnimated:NO];
    }
   
}

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

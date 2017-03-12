//
//  Base_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/22.
//  Copyright © 2016年 鲁柯. All rights reserved.
//  所有界面的基类

#import "Base_ViewController.h"

@interface Base_ViewController ()

@end

@implementation Base_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条颜色
    [self.navigationController.navigationBar setBarTintColor:[LKTool from_16To_Color:NAV_COLOR]];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor=[LKTool from_16To_Color:ThemeColor];

    //返回按钮上的字
    UIBarButtonItem *backIetm = [[UIBarButtonItem alloc] init];
    backIetm.title =@"返回";//这是在基类里  所以可以在此写@“返回”  这样 就是中文"返回"了 这里为空
    self.navigationItem.backBarButtonItem = backIetm;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
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

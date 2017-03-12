

//
//  SystemInfo_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/26.
//  Copyright © 2016年 鲁柯. All rights reserved.
//  系统信息界面

#import "SystemInfo_ViewController.h"

@interface SystemInfo_ViewController ()

@end

@implementation SystemInfo_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"系统消息";
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.navigationItem.titleView = title;
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(0,0, 300, 100)];
    label2.numberOfLines=2;
    label2.text=@"暂无内容";
    label2.font=[UIFont systemFontOfSize:20];
    label2.textColor=[UIColor whiteColor];
    label2.textAlignment=NSTextAlignmentCenter;
    label2.center=CGPointMake(WIDTH_lk/2, HEIGHT_lk/2);
    [self.view addSubview:label2];

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

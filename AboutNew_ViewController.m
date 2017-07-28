


//
//  AboutNew_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/2/10.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  关于界面

#import "AboutNew_ViewController.h"
@interface AboutNew_ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *cellTitleArr;
    NSArray *cellImageNameArr;
    UITableView *tableView_LK;
}
@end

@implementation AboutNew_ViewController
-(void)viewWillAppear:(BOOL)animated{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTittleWithText:LK(@"关 于")];
    
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

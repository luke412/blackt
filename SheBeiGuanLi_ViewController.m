//
//  SheBeiGuanLi_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/6.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  设备管理界面

#define sheBeiGuanLiCellHeight 80

#import "SheBeiGuanLi_ViewController.h"
//界面
#import "TianJia_ViewController.h"
#import "XiuGai_ViewController.h"
#import "Unbund_ViewController.h"
#import "SheBeiQieHuan_ViewController.h"


//模型
#import "DataBaseManager.h"



@interface SheBeiGuanLi_ViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableView_LK;
    NSArray     *dataSource;
}
@end

@implementation SheBeiGuanLi_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTittleWithText:LK(@"设备管理")];
    
    dataSource = @[LK(@"添加设备"),LK(@"切换设备"),LK(@"解绑设备"),LK(@"修改名称")];
    
    tableView_LK            = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH_lk, HEIGHT_lk-64) style:UITableViewStyleGrouped];
    tableView_LK.delegate   = self;
    tableView_LK.dataSource = self;
    [self.view addSubview:tableView_LK];

    tableView_LK.backgroundColor = [UIColor whiteColor];
    [tableView_LK setSeparatorColor:[LKTool from_16To_Color:ZUI_QIAN_HUI]];
    
    if ([tableView_LK respondsToSelector:@selector(setSeparatorInset:)])
    {
             [tableView_LK setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView_LK respondsToSelector:@selector(setLayoutMargins:)])
    {
             [tableView_LK setLayoutMargins:UIEdgeInsetsZero];
    }

}
#pragma mark - UITableView 相关
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
            {
                    [cell setSeparatorInset:UIEdgeInsetsZero];
                }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
            {
                    [cell setLayoutMargins:UIEdgeInsetsZero];
                }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSArray <DeviceModel *>*devices = [DataBase_Manager getAllBoundDevice];
    if ([dataSource[indexPath.row] isEqualToString:LK(@"添加设备")]){
        TianJia_ViewController *vc = [[TianJia_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    }
    
    else if([dataSource[indexPath.row] isEqualToString:LK(@"解绑设备")]){
        if (devices.count == 0) {
            [MBProgressHUD showError:LK(@"暂无已绑定设备")];
            return;
        }
        
        Unbund_ViewController *vc = [[Unbund_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    }
    else if ([dataSource[indexPath.row] isEqualToString:LK(@"修改名称")]){
        if (devices.count == 0) {
            [MBProgressHUD showError:LK(@"暂无已绑定设备")];
            return;
        }
        
        XiuGai_ViewController *vc = [[XiuGai_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    }
    else if ([dataSource[indexPath.row] isEqualToString:LK(@"切换设备")]){
        if (devices.count == 0) {
            [MBProgressHUD showError:LK(@"暂无已绑定设备")];
            return;
        }
        SheBeiQieHuan_ViewController *vc = [[SheBeiQieHuan_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
              cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = dataSource[indexPath.row];
    cell.textLabel.textColor = [LKTool from_16To_Color:tableViewCellTextColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000000001;
}
//返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return sheBeiGuanLiCellHeight;
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

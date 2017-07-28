//
//  FaXin_Xiao_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/10.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  小发现界面

#import "FaXin_Xiao_ViewController.h"
#import "JiBu_ViewController.h"
#import "Location_ViewController.h"


@interface FaXin_Xiao_ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableView_LK;
    NSArray     *titleArr;
}

@end

@implementation FaXin_Xiao_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTittleWithText:@"发现"];
    titleArr                     = @[@"运动",@"位置"];
    tableView_LK                 = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH_lk, HEIGHT_lk-64) style:UITableViewStyleGrouped];
    tableView_LK.delegate        = self;
    tableView_LK.dataSource      = self;
    tableView_LK.backgroundColor = [LKTool from_16To_Color:BACK_COLOR_new];
    [self.view addSubview:tableView_LK];
    
    if ([tableView_LK respondsToSelector:@selector(setSeparatorInset:)])
            {
                         [tableView_LK setSeparatorInset:UIEdgeInsetsZero];
                }
        if ([tableView_LK respondsToSelector:@selector(setLayoutMargins:)])
            {
                             [tableView_LK setLayoutMargins:UIEdgeInsetsZero];
            }

}



#pragma mark - tableView
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
        NSString    *title = titleArr[indexPath.row];
        if ([title isEqualToString:@"运动"]) {
            JiBu_ViewController *vc   = [[JiBu_ViewController alloc]init];
            [self.navigationController  pushViewController:vc animated:NO];
        }
        else if ([title isEqualToString:@"位置"]){
            Location_ViewController *vc = [[Location_ViewController alloc]init];
            [self.navigationController  pushViewController:vc animated:NO];
        }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *reuseIdentifier = @"reuseIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
         }
        cell.textLabel.text      = titleArr[indexPath.row];
        cell.textLabel.textColor = [LKTool from_16To_Color:@"595959"];
    
        return cell;
}
//返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 0.000000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
        return 0.000000001;
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

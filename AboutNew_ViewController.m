


//
//  AboutNew_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/2/10.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  关于界面

#import "AboutNew_ViewController.h"
#import "My_TableViewCell.h"
#import "About2_ViewController.h"  //公司介绍
#import "About_ViewController.h"   //官网公众
@interface AboutNew_ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *cellTitleArr;
    NSArray *cellImageNameArr;
    UITableView *tableView_LK;
}
@end

@implementation AboutNew_ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"关 于";
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.navigationItem.titleView = title;
    cellTitleArr=[[NSArray alloc]initWithObjects:    @"公司介绍",@"官网公众号", nil];
    cellImageNameArr=[[NSArray alloc]initWithObjects:@"公司介绍",@"公众号",    nil];
    
    tableView_LK=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH_lk, HEIGHT_lk-64-48) style:UITableViewStyleGrouped];
    tableView_LK.delegate=self;
    tableView_LK.dataSource=self;
    tableView_LK.backgroundColor=[LKTool from_16To_Color:tableViewBackGroundColor];
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

#pragma mark 代理相关
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *str=cellTitleArr[indexPath.row];
    if ([str isEqualToString:@"公司介绍"]) {
        self.hidesBottomBarWhenPushed=YES;
        About2_ViewController *vc=[[About2_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
        self.hidesBottomBarWhenPushed=NO;
    }else if([str isEqualToString:@"官网公众号"]){
        About_ViewController *vc=[[About_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
           return (NSInteger)cellTitleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    My_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"My_TableViewCell" owner:nil options:nil]firstObject];
    }
    cell.headImageView.image=[UIImage imageNamed:cellImageNameArr[indexPath.row]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.tittle.text=cellTitleArr[indexPath.row];
    cell.backgroundColor=[LKTool from_16To_Color:ThemeColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.0000001;
}
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

//返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 80;
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

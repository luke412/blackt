//
//  My_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/22.
//  Copyright © 2016年 鲁柯. All rights reserved.
//  我的界面

#import "My_ViewController.h"
#import "My_TableViewCell.h"
#import "MyClothes_ViewController.h"  //我的衣物  硬件信息  系统消息  关于  界面
#import "AboutNew_ViewController.h"
#import "SystemInfo_ViewController.h"

#import "Help_ViewController.h"
@interface My_ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView     *tablev_LK;
    NSMutableArray  *dataSource;
    
}
@property(nonatomic,strong)NSArray *cellTittleArr;
@property(nonatomic,strong)NSArray *cellImageArr;
@end

@implementation My_ViewController
-(NSArray *)cellTittleArr{
    if (!_cellTittleArr) {
        //_cellTittleArr=@[@"我的衣物",@"硬件信息",@"系统消息",@"关于"];
        _cellTittleArr=@[@"衣物信息",@"系统消息",@"关于",@"帮助"];
    }
    return _cellTittleArr;
}
-(NSArray *)cellImageArr{
    if (!_cellImageArr) {
        _cellImageArr=@[@"衣物",@"信息",@"关于",@"帮助",@"工具"];
    }
    return _cellImageArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"我 的";
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.navigationItem.titleView = title;
    
    [self createTableView];
}

-(void)createTableView{
    //去cell左侧划线空白
    if ([tablev_LK respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tablev_LK setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tablev_LK respondsToSelector:@selector(setLayoutMargins:)])
    {
        [tablev_LK setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    
    tablev_LK=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH_lk, HEIGHT_lk-64-48) style:UITableViewStyleGrouped];
    tablev_LK.delegate=self;
    tablev_LK.dataSource=self;
    tablev_LK.backgroundColor=[LKTool from_16To_Color:tableViewBackGroundColor];
  //  [tablev_LK setSeparatorColor:[UIColor whiteColor]];
    [self.view addSubview:tablev_LK];

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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
           return self.cellTittleArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *reuseIdentifier = @"reuseIdentifier";
        My_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"My_TableViewCell" owner:nil options:nil]firstObject];
        }
        cell.headImageView.image=[UIImage imageNamed:self.cellImageArr[indexPath.row]];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.tittle.text=self.cellTittleArr[indexPath.row];
        cell.backgroundColor=[LKTool from_16To_Color:ThemeColor];
    
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([self.cellTittleArr[indexPath.row]isEqualToString:@"衣物信息"]) {
        MyClothes_ViewController *vc=[[MyClothes_ViewController alloc]init];
        vc.master=MyClothes;
        [self.navigationController pushViewController:vc animated:NO];
    }
    else if ([self.cellTittleArr[indexPath.row]isEqualToString:@"系统消息"]){
        SystemInfo_ViewController *vc=[[SystemInfo_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];

    }
    else if ([self.cellTittleArr[indexPath.row]isEqualToString:@"关于"]) {
        AboutNew_ViewController *vc=[[AboutNew_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];

    }
    else if ([self.cellTittleArr[indexPath.row]isEqualToString:@"帮助"]) {
        Help_ViewController *vc=[[Help_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    }

}
//返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 70;
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

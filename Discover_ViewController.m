//
//  Discover_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/22.
//  Copyright © 2016年 鲁柯. All rights reserved.
//  发现界面

#import "Discover_ViewController.h"
#import "Webpdf_ViewController.h"
#import "Location_ViewController.h"
#import "Discover_Cell.h"
#import "Mall_ViewController.h"  //商城
@interface Discover_ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView    *tableView_LK;
    NSMutableArray *dataSource;
}
@property(nonatomic,strong)NSArray *cellTittleArr;
@property(nonatomic,strong)NSArray *cellImageArr;
@end

@implementation Discover_ViewController
-(NSArray *)cellTittleArr{
    if (!_cellTittleArr) {
        //_cellTittleArr=@[@"我的衣物",@"硬件信息",@"系统消息",@"关于"];
        _cellTittleArr=@[@"商城",@"位置"];
    }
    return _cellTittleArr;
}
-(NSArray *)cellImageArr{
    if (!_cellImageArr) {
        _cellImageArr=@[@"商城",@"定位"];
    }
    return _cellImageArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"发 现";
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.navigationItem.titleView = title;

    tableView_LK=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH_lk, HEIGHT_lk-64-48) style:UITableViewStyleGrouped];
    tableView_LK.delegate=self;
    tableView_LK.dataSource=self;
    tableView_LK.backgroundColor=[LKTool from_16To_Color:tableViewBackGroundColor];
    [self.view addSubview:tableView_LK];
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
    Discover_Cell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"Discover_Cell" owner:nil options:nil]firstObject];
    }
    cell.imageV.image=[UIImage imageNamed:self.cellImageArr[indexPath.row]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.titleLabel.text=self.cellTittleArr[indexPath.row];
    cell.backgroundColor=[LKTool from_16To_Color:ThemeColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([self.cellTittleArr[indexPath.row]isEqualToString:@"位置"]) {
        Location_ViewController *vc=[[Location_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    }else if([self.cellTittleArr[indexPath.row]isEqualToString:@"商城"]) {
        Mall_ViewController *vc=[[Mall_ViewController alloc]init];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:NO];
         self.hidesBottomBarWhenPushed=NO;
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

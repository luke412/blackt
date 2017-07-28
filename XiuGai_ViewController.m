//
//  XiuGai_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/6.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  修改界面

#import "XiuGai_ViewController.h"
#import "XiuGaiMingCheng_TableViewCell.h"
#import "XiuGaiMingChengNew_ViewController.h"
#import "DataBaseManager.h"

@interface XiuGai_ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView_LK;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation XiuGai_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTittleWithText:LK(@"修改名称")];
    _tableView_LK                 = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH_lk, HEIGHT_lk-64) style:UITableViewStyleGrouped];
    _tableView_LK.backgroundColor = [LKTool from_16To_Color:ThemeColor];
    [_tableView_LK setSeparatorColor:[LKTool from_16To_Color:ZUI_QIAN_HUI]];
    _dataSource                   = [[NSMutableArray alloc]init];
    [self refreshDataSource];
    _tableView_LK.dataSource      = self;
    _tableView_LK.delegate        = self;
    [self.view addSubview:_tableView_LK];
    
    if ([self.tableView_LK respondsToSelector:@selector(setSeparatorInset:)])
    {
             [self.tableView_LK setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView_LK respondsToSelector:@selector(setLayoutMargins:)])
         {
                 [self.tableView_LK setLayoutMargins:UIEdgeInsetsZero];
        }
}

-(void)refreshDataSource{
    [_dataSource removeAllObjects];
    NSArray <DeviceModel *>*devices = [DataBase_Manager getAllBoundDevice];
    [_dataSource addObjectsFromArray:devices];
}
#pragma mark - TableView相关
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
    DeviceModel  *model                   = _dataSource[indexPath.row];
    XiuGaiMingChengNew_ViewController *vc = [[XiuGaiMingChengNew_ViewController alloc]init];
    vc.myClothesModel                     = model;
    [self.navigationController pushViewController:vc animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
      static NSString *reuseIdentifier = @"reuseIdentifier";
      XiuGaiMingCheng_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"XiuGaiMingCheng_TableViewCell" owner:nil options:nil]firstObject];
    }
    DeviceModel  *model = _dataSource[indexPath.row];
    cell.tittle         = model.clothesName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.styleStr       = model.clothesStyle;
    return cell;
}


//返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
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

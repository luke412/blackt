//
//  YiJianGongNeng_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/10.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  一键功能界面

#import "YiJianGongNeng_ViewController.h"
#import "YiJianPlanListModel.h"
#import "YiJianPlanXiangQing_ViewController.h"
#import "YiJianManager.h"
#import "YiJianGongNeng_TableViewCell.h"
#import "UIImageView+WebCache.h"
#import "YiJianPlanModel.h"

@interface YiJianGongNeng_ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView    *tableView_LK;
    NSMutableArray <YiJianPlanListModel *>*dataSource;
    NSMutableArray <NSNumber *>* cellHeightArr;
}
@end

@implementation YiJianGongNeng_ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [tableView_LK reloadData];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTittleWithText:@"一键功能"];
    dataSource                   = [[NSMutableArray alloc]init];
    cellHeightArr                = [[NSMutableArray alloc]init];
    tableView_LK                 = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH_lk, HEIGHT_lk-64) style:UITableViewStyleGrouped];
    tableView_LK.delegate        = self;
    tableView_LK.dataSource      = self;
    tableView_LK.backgroundColor = [UIColor whiteColor];
    tableView_LK.separatorColor  = [UIColor clearColor];
    [self.view addSubview:tableView_LK];
    [self requestPlan];
}
-(void)requestPlan{
    NSString *userid    = [App_Manager getUserId];
    NSString *usertoken = [App_Manager getUserToken];
    NSString *deviceid  = [App_Manager getDeviceId];
    LKShow(@"正在加载...");
    [dataSource removeAllObjects];
    [NetWork_Manager loadAllYuZhiPlan_userId:userid
                                   userToken:usertoken
                                    deviceId:deviceid
                                     Success:^(NSArray<YiJianPlanListModel *> *planArr) {
                                         LKRemove;
                                         [dataSource addObjectsFromArray:planArr];
                                         [tableView_LK reloadData];
                                     } Abnormal:^(id responseObject) {
                                         LKRemove;
                                         [MBProgressHUD showError:responseObject[@"retMsg"]];
                                     } Failure:^(NSError *error) {
                                         LKRemove;
                                         [MBProgressHUD showError:@"网络开小差~\(≧▽≦)/"];
                                     }];
}

#pragma mark - tableView
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YiJianPlanListModel *model             = dataSource[indexPath.row];
    YiJianPlanXiangQing_ViewController *vc = [[YiJianPlanXiangQing_ViewController alloc]init];
    vc.schemeId                            = model.schemeId;
    vc.titleText                           = model.schemeName;
    vc.imagePath                           = model.drugbagLocationPic;
    [self.navigationController pushViewController:vc animated:NO];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *reuseIdentifier = @"reuseIdentifier";
        YiJianGongNeng_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
                cell =[[[NSBundle mainBundle]loadNibNamed:@"YiJianGongNeng_TableViewCell" owner:nil options:nil]firstObject];
        }
        YiJianPlanListModel *model = dataSource[indexPath.row];
        cell.name.text = model.schemeName;
        cell.renshu.text = [NSString stringWithFormat:@"%ld人正在使用",model.usingCount];
        [cell.image sd_setImageWithURL:[NSURL URLWithString:model.drugbagLocationPic] placeholderImage:[UIImage imageNamed:@"推文图片占位"]];
    if (indexPath.row == 0) {
        [cellHeightArr removeAllObjects];
    }
    CGFloat iamgeHeight = [LKTool getBottomY:cell.image];
    [cellHeightArr addObject:@(iamgeHeight)];
    
    //如果处于一键理疗状态
    if (App_Manager.heatState == YiJian_heat) {
        YiJianPlanModel *currPlan = YiJian_Manager.currPlan;
        NSString *schemeId = currPlan.schemeId;
        if ([model.schemeId isEqualToString:schemeId]) {
            [cell showRuningFace];
        }
    }else{
        [cell showStopFace];
    }
    return cell;
}
//返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (cellHeightArr.count == 0) {
        return 100;
    }
    LKLog( @"%ld",cellHeightArr.count);
    NSNumber *n =  cellHeightArr[indexPath.row];
    CGFloat height = [n floatValue];
    return height;
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
-(void)dealloc{
    LKLog(@"YiJianGongNeng_ViewController  死亡");
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

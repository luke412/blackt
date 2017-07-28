//
//  BluthNameAddDevice_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/13.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  蓝牙名称添加设备  手动输入mac

#import "BluthNameAddDevice_ViewController.h"
#import "MJRefresh.h"
#import "DataBaseManager.h"
#import "BlueManager.h"
#import "YiChangManager.h"
#import "BoundSetName_ViewController.h"

@interface BluthNameAddDevice_ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView    *tableView_LK;
    NSMutableArray *dataSource;
    //已经绑定的设备
    NSArray<DeviceModel *> *devices;
}
@end

@implementation BluthNameAddDevice_ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTittleWithText:@"添加设备"];
    LKShow(@"正在扫描...");
    dataSource = [[NSMutableArray alloc]init];
    devices = [DataBase_Manager getAllBoundDevice];
    
    //扫描设备
    [[LGCentralManager sharedInstance] scanForPeripheralsByInterval:4 completion:^(NSArray *peripherals) {
        NSMutableArray *nameArr = [[NSMutableArray alloc]init];
        for (LGPeripheral *p in peripherals) {
            NSString *name = p.name;
            if (![name hasPrefix:@"BL"]) {
                continue;
            }
            [nameArr addObject:name];
        }
        LKRemove;
        [dataSource addObjectsFromArray:nameArr];
        [self createTableView_dataSource:dataSource];
    }];
}

-(void)createTableView_dataSource:(NSMutableArray *)dataArr{
    tableView_LK            = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH_lk, (float)dataArr.count*80) style:UITableViewStyleGrouped];
    tableView_LK.delegate   = self;
    tableView_LK.dataSource = self;
    tableView_LK.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[LGCentralManager sharedInstance] scanForPeripheralsByInterval:4 completion:^(NSArray *peripherals) {
            [dataSource removeAllObjects];
            [tableView_LK.mj_header endRefreshing];
            NSMutableArray *nameArr = [[NSMutableArray alloc]init];
            for (LGPeripheral *p in peripherals) {
                NSString *name = p.name;
                if (![name hasPrefix:@"BL"]) {
                    continue;
                }
                [nameArr addObject:name];
            }
            [dataSource addObjectsFromArray:nameArr];
            [tableView_LK reloadData];
        }];
    }];
    

    [self.view addSubview:tableView_LK];
}

#pragma mark - tableView 代理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        NSString *macName = dataSource[indexPath.row];
    NSArray *arr = [macName componentsSeparatedByString:@"x"];
    NSString *mac = arr[1];
    for (DeviceModel *deivce in devices) {
        if ([mac isEqualToString:deivce.clothesMac]) {
            [MBProgressHUD showError:@"此设备已绑定"];
            return;
        }
    }
    
    //绑定，蓝牙连接设备
    App_Manager.QRcodeCacheMac = mac;
     LKShow(@"正在连接...");
    [Blue_Manager smartctionWithMac:mac
                             Sucess:^(NSString *mac) {
                                 LKRemove;
                                 //进入输入名字界面
                                 BoundSetName_ViewController *VC  =  [[BoundSetName_ViewController alloc]init];
                                 [self.navigationController pushViewController:VC animated:NO];
                             }
                             Failure:^(NSString *mac) {
                                 LKRemove;
                                 YiChangManager *yichang = [[YiChangManager alloc]init];
                                 yichang.successBlock = ^(NSString *mac) {
                                     
                                     
                                 };
                                 [yichang showViewControllers_vc:self];
                             }
                             andIsRunDelegate:NO];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *reuseIdentifier = @"reuseIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        cell.textLabel.text = dataSource[indexPath.row];
        cell.detailTextLabel.text = @"连接";
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

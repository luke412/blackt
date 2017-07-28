//
//  SheBeiQieHuan_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/4/8.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  设备切换界面 切换设备界面

#import "SheBeiQieHuan_ViewController.h"
#import "QieHuanSheBei_TableViewCell.h"
#import "QieHuanSheBeiSelected_TableViewCell.h"
#import "DataBaseManager.h"
#import "BlueManager.h"

@interface SheBeiQieHuan_ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView    *tableView_LK;
@property(nonatomic,strong)NSMutableArray *dataSource;

@property(nonatomic,assign)int currentIndex;
@end
@implementation SheBeiQieHuan_ViewController
-(void)viewWillAppear:(BOOL)animated{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTittleWithText:LK(@"切换设备")];
    //装填数据源
     self.dataSource   = [[NSMutableArray alloc]init];
    [self loadDataSource];

    [self.view addSubview:self.tableView_LK];
    if ([self.tableView_LK respondsToSelector:@selector(setSeparatorInset:)])
    {
             [self.tableView_LK setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView_LK respondsToSelector:@selector(setLayoutMargins:)])
         {
                 [self.tableView_LK setLayoutMargins:UIEdgeInsetsZero];
        }
}

-(void)loadDataSource{
    NSArray *devices = [DataBase_Manager getAllBoundDevice];
    DeviceModel *device = App_Manager.currDevice;
    if (devices.count == 0) {
        return;
    }
    [self.dataSource removeAllObjects];
    for (int i = 0; i<devices.count; i++) {
        DeviceModel *model = devices[i];
        [self.dataSource addObject:model];
        if ([model.clothesMac isEqualToString:device.clothesMac]) {
            self.currentIndex = i;
        }
    }
    
    //当前设备置顶，修改数据源
    NSIndexPath *targetIndexPath  = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
    [_tableView_LK moveRowAtIndexPath:currentIndexPath toIndexPath:targetIndexPath]; //置顶
    id tempData                   = self.dataSource[currentIndexPath.row];
    _tableView_LK.backgroundColor = [LKTool from_16To_Color:ThemeColor];
    [self.dataSource removeObjectAtIndex:currentIndexPath.row];
    [self.dataSource insertObject:tempData atIndex:0];
     self.currentIndex = 0;
    [self.tableView_LK reloadData];
}
#pragma mark - UITableView 代理相关
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
    if (indexPath.row == 0) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
      return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
       static NSString *reuseIdentifier  = @"reuseIdentifier";
       static NSString *reuseIdentifier2 = @"reuseIdentifier2";
    //选中状态
    LKLog(@"%d",self.currentIndex);
    if (indexPath.row == self.currentIndex) {
        QieHuanSheBeiSelected_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"QieHuanSheBeiSelected_TableViewCell" owner:nil options:nil]firstObject];
            
            }
        DeviceModel *device = self.dataSource[indexPath.row];
        cell.deviceMac      = device.clothesMac;
        cell.deviceName     = device.clothesName;
        cell.deviceStyle    = device.clothesStyle;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    else {
        QieHuanSheBei_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier2];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"QieHuanSheBei_TableViewCell" owner:nil options:nil]firstObject];
        }
        DeviceModel *device = self.dataSource[indexPath.row];
        cell.deviceMac      = device.clothesMac;
        cell.deviceName     = device.clothesName;
        cell.deviceStyle    = device.clothesStyle;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        //切换设备点击事件   1.先都归为未选中状态   2.动画    3.标出选中状态
        __weak typeof (cell)weakCell = cell;
        cell.myClickBlock = ^(){
            if (App_Manager.heatState != WuCaoZuo_heat) {
                [self noSwitchoverAllowed];//禁止切换
                return ;
            }
            
            //弹窗：是否确定切换设备
            LKAlertController  *alertVc = [LKAlertController  alertControllerWithTitle:nil message:LK(@"确定切换设备吗?") preferredStyle:UIAlertControllerStyleAlert];
            alertVc.text = @"确定切换设备吗?";
                   LKAlertAction  *cancle = [LKAlertAction  actionWithTitle:LK(@"取消") style:UIAlertActionStyleCancel handler:^    (UIAlertAction *action){
                    }];
             LKAlertAction  *queDing = [LKAlertAction  actionWithTitle:LK(@"确定") style:UIAlertActionStyleDefault handler:^    (UIAlertAction *action){
                            NSIndexPath *targetIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                            [tableView moveRowAtIndexPath:indexPath toIndexPath:targetIndexPath]; //置顶
                            id tempData                  = self.dataSource[indexPath.row];
                            [self.dataSource removeObjectAtIndex:indexPath.row];
                            [self.dataSource insertObject:tempData atIndex:0];
                            [self.tableView_LK reloadData];
                            
                DeviceModel *deivce = App_Manager.currDevice;
                [Blue_Manager disconnectWithMac:deivce.clothesMac Sucess:nil Failure:nil];
                   DeviceModel  *deviceNew = [[DeviceModel alloc]init];
                deviceNew.clothesName = weakCell.deviceName;
                deviceNew.clothesMac  = weakCell.deviceMac;
                deviceNew.deviceType =weakCell.deviceStyle;
                App_Manager.currDevice = deviceNew;
                }];

            [alertVc addAction:queDing];
            [alertVc addAction:cancle];
            [self presentViewController:alertVc animated:YES completion:^{    }];
         };
        return cell;
    }
}
-(void)noSwitchoverAllowed{


}


//返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}



#pragma mark - 懒加载
-(UITableView *)tableView_LK{
    if (!_tableView_LK) {
        _tableView_LK = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH_lk, HEIGHT_lk-64) style:UITableViewStyleGrouped];
        _tableView_LK.delegate = self;
        _tableView_LK.dataSource = self;
        _tableView_LK.backgroundColor = [LKTool from_16To_Color:ThemeColor];

        [_tableView_LK setSeparatorColor:[LKTool from_16To_Color:ZUI_QIAN_HUI]];
    }

    return _tableView_LK;
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

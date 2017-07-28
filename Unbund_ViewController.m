//
//  Unbund_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/4/6.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  解绑设备界面

#import "Unbund_ViewController.h"
#import "Device_TableViewCell.h"
#import "CurrDevice_TableViewCell.h"
#import "LKView.h"
#import "DataBaseManager.h"

@interface Unbund_ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView    *tableView_LK;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) int            currentIndex;
@end

@implementation Unbund_ViewController
-(void)viewWillAppear:(BOOL)animated{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTittleWithText:LK(@"解绑设备")];
    NSArray <DeviceModel *>*devices = [DataBase_Manager getAllBoundDevice];
    self.dataSource                 = [[NSMutableArray alloc]initWithArray:devices];
    if (devices.count == 0) {
        return;
    }
    
    DeviceModel *currDevice = App_Manager.currDevice;
    for (int i =0 ; i<devices.count; i++ ){
        DeviceModel *model = devices[i];
        if ([model.clothesMac isEqualToString:currDevice.clothesMac]) {
            self.currentIndex = i;
        }
    }
    self.tableView_LK.backgroundColor = [LKTool from_16To_Color:ThemeColor];
    [self.tableView_LK setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:self.tableView_LK];

    //当前设备置顶，修改数据源
    NSIndexPath *targetIndexPath  = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
    [_tableView_LK moveRowAtIndexPath:currentIndexPath toIndexPath:targetIndexPath]; //置顶
    id tempData = self.dataSource[currentIndexPath.row];
    [self.dataSource removeObjectAtIndex:currentIndexPath.row];
    [self.dataSource insertObject:tempData atIndex:0];
    self.currentIndex = 0;
    [self.tableView_LK reloadData];
    
    if ([self.tableView_LK respondsToSelector:@selector(setSeparatorInset:)])
    {
             [self.tableView_LK setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView_LK respondsToSelector:@selector(setLayoutMargins:)])
    {
         [self.tableView_LK setLayoutMargins:UIEdgeInsetsZero];
    }

}
#pragma mark - 左滑删除
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
//- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        [self.dataSource removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath]
//                              withRowAnimation:UITableViewRowAnimationAutomatic];
//        [tableView reloadData];
//    }
//}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
          LKAlertController *alertVc = [LKAlertController alertControllerWithTitle:nil message:LK(@"确定删除设备吗?") preferredStyle:UIAlertControllerStyleAlert];
                LKAlertAction *cancle = [LKAlertAction actionWithTitle:LK(@"取消")
                                                                 style:UIAlertActionStyleCancel
                                                               handler:^(UIAlertAction *action){ }];
                                                                [alertVc addAction:cancle];
                LKAlertAction *queDing = [LKAlertAction actionWithTitle:LK(@"确定")
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action){
                                                                            //解绑设备
                                                                          [self jieBang_NSIndexPath:indexPath tableView:tableView];
                                                                      }];
                                                                    [alertVc addAction:queDing];
                [self presentViewController:alertVc animated:YES completion:^{ }];

        
        
        
    
    }];
    deleteAction.backgroundColor = [LKTool from_16To_Color:@"474747"];
    return @[deleteAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
}

#pragma mark - 解绑
-(void)jieBang_NSIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    DeviceModel *device = self.dataSource[indexPath.row];
    NSString *mac       = device.clothesMac;
    NSString *userId    = [App_Manager getUserId];
    NSString *userToken = [App_Manager getUserToken];
    NSString *deviceid  = [App_Manager getDeviceId];
     LKShow(@"正在解绑...");
    [NetWork_Manager macBind_userId:userId
                          userToken:userToken
                           deviceId:deviceid
                              macNo:mac
                         bindStatus:JieBang
                            Success:^(id responseObject) {
                                LKRemove;
                                BOOL isOk =[DataBase_Manager DeletedFromTheTable:mac];
                                if (isOk) {
                                    //删除数据源
                                    [self.dataSource removeObjectAtIndex:indexPath.row];
                                    //删除cell
                                    [self.tableView_LK deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                    [MBProgressHUD showSuccess:@"解绑成功"];
                                    [tableView reloadData];
                                    [self.navigationController popToRootViewControllerAnimated:NO];
                                }else{
                                    [MBProgressHUD showSuccess:@"解绑失败"];
                                }
                            } Abnormal:^(id responseObject) {
                                LKRemove;
                                [MBProgressHUD showError:responseObject[@"retMsg"]];
                            } Failure:^(NSError *error) {
                                LKRemove;
                                [MBProgressHUD showError:@"网络开小差~\(≧▽≦)/"];
                            }];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
           return (NSInteger)self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
      static NSString *reuseIdentifier  = @"reuseIdentifier";
      static NSString *reuseIdentifier2 = @"reuseIdentifier2";
    if (indexPath.row == 0) {
        DeviceModel *model  = self.dataSource[indexPath.row];
        CurrDevice_TableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier2];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CurrDevice_TableViewCell" owner:nil options:nil]firstObject];
        }
        cell.deviceName     = model.clothesName;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        DeviceModel *model  = self.dataSource[indexPath.row];
        Device_TableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"Device_TableViewCell" owner:nil options:nil]firstObject];
        }
        cell.deviceStyle    = model.clothesStyle;
        cell.deviceName     = model.clothesName;
        cell.deviceMac      = model.clothesMac;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
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
        _tableView_LK.tag = -100;
        _tableView_LK.delegate = self;
        _tableView_LK.dataSource = self;
      
    }
    return _tableView_LK;
}

#pragma mark - 生命周期
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableView_LK setEditing:NO];
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

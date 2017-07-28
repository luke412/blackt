//
//  FriendInfo_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/17.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "FriendInfo_ViewController.h"
#import "FriendModel.h"

#import "AddFriend_TableViewCell.h"
#import "AddRequestSuccess_ViewController.h"



@interface FriendInfo_ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView_LK;
@property(nonatomic,strong)NSMutableArray <FriendModel *>*dataSource;

@end

@implementation FriendInfo_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTittleWithText:@"添加好友"];
    _dataSource = [[NSMutableArray alloc]init];
    [_dataSource addObject:self.currFriendModel];
    
    _tableView_LK            = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH_lk, HEIGHT_lk-64) style:UITableViewStyleGrouped];
    _tableView_LK.delegate   = self;
    _tableView_LK.dataSource = self;
    _tableView_LK.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView_LK];
}

//添加好友请求
- (void)createAddFriendRequest{
    NSString *userId        = [App_Manager getUserId];
    NSString *userToken     = [App_Manager getUserToken];
    NSString *deviceId      = [App_Manager getDeviceId];
    NSInteger passiveUserId = self.currFriendModel.passiveUserId;
    LKShow(@"正在处理...");
    [NetWork_Manager sendAddFriendRequest_userId:userId
                                       userToken:userToken
                                        deviceId:deviceId
                                   passiveUserId:passiveUserId
                                         Success:^(id responseObject) {
                                             LKRemove;
                                             //添加好友请求发送成功
                                             AddRequestSuccess_ViewController *vc = [[AddRequestSuccess_ViewController alloc]init];
                                             [self.navigationController pushViewController:vc animated:NO];
                                         }
                                        Abnormal:^(id responseObject) {
                                            LKRemove;
                                            [MBProgressHUD showError:responseObject[@"retMsg"]];
                                        }
                                         Failure:^(NSError *error) {
                                            LKRemove;
                                             [MBProgressHUD showError:@"网络开小差~\(≧▽≦)/"];
                                         }];
}


#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *reuseIdentifier = @"reuseIdentifier";
        AddFriend_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
                cell =[[[NSBundle mainBundle]loadNibNamed:@"AddFriend_TableViewCell" owner:nil options:nil]firstObject];
        }
    FriendModel *friendModel = _dataSource[indexPath.row];
    cell.currFriendModel     = friendModel;
    cell.myCellBlock         = ^(FriendModel *firendModel) {
                                   [self createAddFriendRequest];
                               };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (IBAction)cancel:(id)sender {
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

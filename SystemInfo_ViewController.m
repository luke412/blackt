
//  SystemInfo_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/26.
//  Copyright © 2016年 鲁柯. All rights reserved.
//  系统消息界面  消息列表

#import "SystemInfo_ViewController.h"
#import "MessageModel.h"
#import "XiaoXi_TableViewCell.h"
#import "XiaoXiXiangQing_ViewController.h"
#import "TuiWenXiaoXiTableViewCell.h"
#import "TuiWenTableViewCell.h"
#import "MessageTableViewCell.h"
#import "webViewController.h"
#import "DataBaseManager.h"


@interface SystemInfo_ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak,  nonatomic)IBOutlet UIImageView *zhanWeiImage;
@property (nonatomic,strong)NSMutableArray <MessageModel *>* mesaageArray;
@property (nonatomic,strong)UITableView  *tableView_LK;

@end
@implementation SystemInfo_ViewController
-(void)viewWillAppear:(BOOL)animated{
    if (_mesaageArray.count > 0) {
        _zhanWeiImage.hidden = YES;
        _tableView_LK.hidden = NO;
        
    }else{
        _zhanWeiImage.hidden = NO;
        _tableView_LK.hidden = YES;
    }
    [_tableView_LK reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTittleWithText:LK(@"消息")];
    if (![UserDefaultsUtils iscHanYu]) {
        _zhanWeiImage.image = [UIImage imageNamed:@"暂无信息英"];
    }

    //获取数据库消息信息
    [self loadDataBaseMessageInfo];
    
    _tableView_LK                 = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH_lk, HEIGHT_lk - 64) style:UITableViewStyleGrouped];
    _tableView_LK.delegate        = self;
    _tableView_LK.dataSource      = self;
    _tableView_LK.backgroundColor = [LKTool from_16To_Color:ZUI_QIAN_HUI];
    _tableView_LK.separatorColor  = [UIColor clearColor];
    [self.view addSubview:_tableView_LK];
}

-(void)loadDataBaseMessageInfo{
    _mesaageArray = [[NSMutableArray alloc]initWithArray:[DataBase_Manager loadAllMessage]];
    NSMutableArray *messageArrCopy = [[NSMutableArray alloc]initWithArray:[_mesaageArray copy]];
    NSInteger index = 0;
    for (MessageModel *model in messageArrCopy) {
        if (![model.customKey hasPrefix:@"A"] && ![model.customKey hasPrefix:@"B"]) {
            [_mesaageArray removeObject:model];
        }
        index ++;
    }
    
    NSEnumerator *enumerator = [_mesaageArray reverseObjectEnumerator];
    _mesaageArray            = (NSMutableArray*)[enumerator allObjects];
}

#pragma  mark - tableView 相关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return _mesaageArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier        = @"reuseIdentifier";
    static NSString *MessageReuseIdentifier = @"MessageReuseIdentifier";
    MessageModel *model   = _mesaageArray [indexPath.row];
    if ([model.customKey hasPrefix:@"A"]) {
            MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageReuseIdentifier];
                if (cell == nil) {
                cell = [[MessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MessageReuseIdentifier];
            }
            
            cell.messageModel    = model;
            cell.backgroundColor = [LKTool from_16To_Color:ZUI_QIAN_HUI];
            [cell loadData];
            return cell;

    }else if ([model.customKey hasPrefix:@"B"]){
        TuiWenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (cell == nil) {
            cell = [[TuiWenTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        
        cell.messgModel      = model;
        cell.backgroundColor = [LKTool from_16To_Color:ZUI_QIAN_HUI];
        [cell loadData];
        return cell;
    }else{
        return nil;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MessageModel *message   = _mesaageArray[indexPath.row];
    if (message.customUrlKey.length>3) {
        webViewController *web = [[webViewController alloc]init];
        web.url                = message.customUrlKey;
        [self.navigationController pushViewController:web animated:NO];
        //修改数据库 已读状态
        message.isRead = @"YES";
        [DataBase_Manager lk_xiuGaiReadStateWithMessage:message];
        return;
    }
    XiaoXiXiangQing_ViewController *vc = [[XiaoXiXiangQing_ViewController alloc]init];
    vc.messageModel                    = message;
    [self.navigationController pushViewController:vc animated:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *model = _mesaageArray[indexPath.row];
    if ([model.customKey hasPrefix:@"A"]) {
         return 162;
    }else{
        return 357;
    }
       
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

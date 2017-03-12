//
//  MyClothes_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/1/4.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  衣物信息界面

#import "MyClothes_ViewController.h"
#import "ClothesInfoCell.h"
@interface MyClothes_ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableView_LK;
    NSString    *myStyle;
    int blackTCount;
    int huYaoCount;
}
@property(nonatomic,strong)NSArray *rowTittleArr;
@property(nonatomic,strong)NSMutableArray *sectionModelArr;
@property(nonatomic,strong)NSDictionary *HuYaoInfoDic;
@property(nonatomic,strong)NSDictionary *BlackTInfoDic;
@property(nonatomic,strong)NSDictionary *cellTitleInfoDic;
//@property(nonatomic,strong)NSArray *cellImageArr;
@end

@implementation MyClothes_ViewController
-(NSArray *)sectionModelArr{
    if (!_sectionModelArr){
        _sectionModelArr=[[NSMutableArray alloc]init];
    }
    return _sectionModelArr;
}
-(NSDictionary *)cellTitleInfoDic{
    if (!_cellTitleInfoDic) {
        _cellTitleInfoDic=[[NSDictionary alloc]initWithObjects:@[self.BlackTInfoDic,self.HuYaoInfoDic]
                                                       forKeys:@[@"BlackT",@"护腰"]];
    }
    return _cellTitleInfoDic;
}
-(NSDictionary *)HuYaoInfoDic{
    if (!_HuYaoInfoDic) {
        //护腰信息字典
        _HuYaoInfoDic=[[NSDictionary alloc]initWithObjects:@[@"护腰",@"北京创新爱尚家科技股份有限公司",@"V3.0.1.1234",@"V1.1.2.56", @"4000mAh",@"1",@"14cm",@"14cm"]
                                                   forKeys:@[@"产品名称",@"出品",@"固件版本",@"硬件版本",@"电池容量",@"石墨烯加热片数",@"石墨烯加热片长度",@"石墨烯加热片宽度"]];
    }
    return _HuYaoInfoDic;
}
-(NSDictionary *)BlackTInfoDic{
    if (!_BlackTInfoDic) {
        //BlackT信息字典
        _BlackTInfoDic=[[NSDictionary alloc]initWithObjects:@[@"BlackT",@"北京创新爱尚家科技股份有限公司",@"V3.0.1.1234",@"V1.1.2.56", @"4000mAh",@"1",@"14cm",@"7cm"]
                                                    forKeys:@[@"产品名称",@"出品",@"固件版本",@"硬件版本",@"电池容量",@"石墨烯加热片数",@"石墨烯加热片长度",@"石墨烯加热片宽度"]];
    }
    return _BlackTInfoDic;
}

-(NSArray *)rowTittleArr{
    if (!_rowTittleArr) {
        _rowTittleArr=@[@"产品名称",@"出品",@"固件版本",@"硬件版本",@"电池容量",@"石墨烯加热片数",@"石墨烯加热片长度",@"石墨烯加热片宽度"];
    }
    return _rowTittleArr;
}
-(void)judgeDeviceStyle{
     blackTCount =0;
     huYaoCount  =0;
    NSArray *devices=[[LKDataBaseTool sharedInstance]showAllDataFromTable:nil];
    if (devices.count==0) {
        [tableView_LK removeFromSuperview];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
        label.center=self.view.center;
        label.textAlignment=NSTextAlignmentCenter;
        label.text=@"暂无已绑定衣物";
        label.font=[UIFont systemFontOfSize:20];
        label.textColor=[UIColor whiteColor];
        [self.view addSubview:label];
        return;
    }
    
    [self.sectionModelArr removeAllObjects];
    for (int i=0; i<devices.count; i++) {
        ClothesModel *model=devices[i];
        [self.sectionModelArr addObject:model];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    if (tableView_LK!=nil) {
        //判断拥有的设备类型
        [self judgeDeviceStyle];

        [tableView_LK reloadData];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"衣物信息";
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.navigationItem.titleView = title;

    
    tableView_LK=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH_lk, HEIGHT_lk-64-48) style:UITableViewStyleGrouped];
    tableView_LK.delegate=self;
    tableView_LK.dataSource=self;
    tableView_LK.backgroundColor=[LKTool from_16To_Color:tableViewBackGroundColor];
    
    [tableView_LK setSeparatorColor:[LKTool from_16To_Color:@"#666666"]];
    [self.view addSubview:tableView_LK];
    
   
    
    //展示数据库内容
    //展示数据库内容
    NSArray *dataBaseArr=[[LKDataBaseTool sharedInstance]showAllDataFromTable:nil];
    
    for (int i=0; i<dataBaseArr.count; i++) {
        ClothesModel *model=dataBaseArr[i];
        NSLog(@"内容%d %@",i,model);
    }
    
    
}
#pragma mark tableView代理
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    ClothesModel *model=self.sectionModelArr[section];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, WIDTH_lk, 50)];
    label.text=[NSString stringWithFormat:@"  %@",model.clothesName];
    label.textColor=[UIColor whiteColor];
    return label;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionModelArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rowTittleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *reuseIdentifier = @"reuseIdentifier";
        UITableViewCell   *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil){
         cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        cell.backgroundColor=[LKTool from_16To_Color:tableViewBackGroundColor];
    }
    cell.textLabel.text=self.rowTittleArr[indexPath.row];
    
    
    ClothesModel *model=self.sectionModelArr[indexPath.section];
    NSString *sectionStyle=model.clothesStyle;
    NSDictionary *infoDic=self.cellTitleInfoDic[sectionStyle];
    cell.detailTextLabel.text=infoDic[cell.textLabel.text];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.userInteractionEnabled = NO;
    
    //字号设置
    if ([LKTool iPhoneStyle]==iPhone5) {
        cell.textLabel.font=[UIFont systemFontOfSize:13];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:13];

    }
        return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
//返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return 50;
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

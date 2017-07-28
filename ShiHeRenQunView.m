//
//  ShiHeRenQunView.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/14.
//  Copyright © 2017年 鲁柯. All rights reserved.
//
#define SHRQ_cellHeight  65

#import "ShiHeRenQunView.h"
#import "YiJianPlanModel.h"
#import "ShiYongRenModel.h"
#import "ShiYongRenQun_TableViewCell.h"

@interface ShiHeRenQunView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView_LK;
@property(nonatomic,strong)NSMutableArray <ShiYongRenModel *> *dataSouce;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation ShiHeRenQunView
/** 刷新视图 */
-(void)refreshUI_Model:(YiJianPlanModel *)planModel{
    if (!planModel) {
        return;
    }
    NSString *suitCrowdStr = planModel.suitCrowd;
    NSArray *subStrArr     = [suitCrowdStr componentsSeparatedByString:@"#"];
    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
    for (NSString *str in subStrArr) {
        NSArray *arr           = [str componentsSeparatedByString:@"$"];
        NSString *title        = arr[0];
        NSString *text         = arr[1];
        ShiYongRenModel *model = [[ShiYongRenModel alloc]init];
        model.title            = title;
        model.text             = text;
        [mutArr addObject:model];
    }
    [_dataSouce removeAllObjects];
    [_dataSouce addObjectsFromArray:mutArr];
    [_tableView_LK reloadData];
    
    CGFloat selfWidth            = WIDTH_lk - lkptBiLi(5)*2;
    CGFloat tableViewWidth       = selfWidth -lkptBiLi(28)*2;
    _tableView_LK.frame          = CGRectMake(lkptBiLi(28), lkptBiLi(60),tableViewWidth, SHRQ_cellHeight*_dataSouce.count);
    _tableView_LK.separatorColor = [UIColor clearColor];
    self.height                  = [LKTool getBottomY:_tableView_LK] + lkptBiLi(20);
    [LKTool setView_Height:self.height andView:self];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    CGFloat selfWidth      = WIDTH_lk - lkptBiLi(5)*2;
    CGFloat tableViewWidth = selfWidth -lkptBiLi(28)*2;
    _dataSouce             = [[NSMutableArray alloc]init];
    
    _titleLabel.frame             = CGRectMake(lkptBiLi(10), lkptBiLi(12), lkptBiLi(82), lkptBiLi(17));
    _titleLabel.textColor         = [LKTool from_16To_Color:@"#595959"];
    _line.frame                   = CGRectMake(lkptBiLi(5), lkptBiLi(40), selfWidth-lkptBiLi(5)*2, 1);
    _tableView_LK                 = [[UITableView alloc]initWithFrame:CGRectMake(lkptBiLi(28), lkptBiLi(60),tableViewWidth, 38*_dataSouce.count) style:UITableViewStyleGrouped];
    _tableView_LK.userInteractionEnabled = NO;
    _tableView_LK.delegate        = self;
    _tableView_LK.dataSource      = self;
    _tableView_LK.backgroundColor = [UIColor blueColor];
    [self addSubview:_tableView_LK];
    self.height = [LKTool getBottomY:_tableView_LK]+lkptBiLi(20);
}


#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.dataSouce.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    ShiYongRenQun_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"ShiYongRenQun_TableViewCell" owner:nil options:nil]firstObject];
    }
    ShiYongRenModel *model = _dataSouce[indexPath.row];
    [cell refreshUI_ShiYongRenModel:model];
    return cell;
}
//返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return SHRQ_cellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 0.000000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
        return 0.000000001;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

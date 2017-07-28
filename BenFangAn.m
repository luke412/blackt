//
//  BenFangAn.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/13.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#define benFangAnCellHeight 45

#import "BenFangAn.h"
#import "YiJianPlanModel.h"
#import "WenDu_TableViewCell.h"

@interface BenFangAn() <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel     *bigTitle;
@property (weak, nonatomic) IBOutlet UIView      *line1;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel     *subTitle;
@property (weak, nonatomic) IBOutlet UILabel     *subTitle1;
@property (weak, nonatomic) IBOutlet UILabel     *subTitle2;
@property (weak, nonatomic) IBOutlet UILabel     *subTitle3;
@property (weak, nonatomic) IBOutlet UILabel     *sumCount;
@property (weak, nonatomic) IBOutlet UILabel     *weekSumCount;
@property (weak, nonatomic) IBOutlet UILabel     *monthSunCount;
@property (weak, nonatomic) IBOutlet UIView      *line2;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UILabel     *wenDuKongZhi;

@property(nonatomic,strong)UITableView      *tableView_LK;
@property(nonatomic,strong)NSMutableArray   *dataSource;
@end

@implementation BenFangAn
/** 刷新视图 */
-(void)refreshUI_Model:(YiJianPlanModel *)planModel{
    [_dataSource removeAllObjects];
    CGFloat selfWidth            = WIDTH_lk  - lkptBiLi(5) * 2;
    CGFloat tableViewWidth       = selfWidth - lkptBiLi(43)* 2;
    [_dataSource addObjectsFromArray:planModel.treatmentTemperatureList];
    [_tableView_LK reloadData];
    _tableView_LK.frame = CGRectMake(lkptBiLi(43),
                                     lkptBiLi(228),
                                     lkptBiLi(229),
                                     benFangAnCellHeight*_dataSource.count);
    self.height = [LKTool getBottomY:_tableView_LK]+lkptBiLi(20);
    [LKTool setView_Height:self.height andView:self];
    
    
    //本周  本月 总共
    _weekSumCount.text           = [NSString stringWithFormat:@"%@次",planModel.weekCount];
    _monthSunCount.text          = [NSString stringWithFormat:@"%@次",planModel.monthCount];
    _sumCount.text               = [NSString stringWithFormat:@"%@次",planModel.sumCount];


    
//    _weekSumCount.backgroundColor = [UIColor yellowColor];
//    _monthSunCount.backgroundColor = [UIColor yellowColor];
//    _sumCount.backgroundColor = [UIColor yellowColor];

    
}

-(void)awakeFromNib{
    [super awakeFromNib];
    CGFloat selfWidth            = WIDTH_lk  - lkptBiLi(5) * 2;
    CGFloat tableViewWidth       = selfWidth - lkptBiLi(43)* 2;
    _bigTitle.frame      = CGRectMake(lkptBiLi(10), lkptBiLi(17), lkptBiLi(82), lkptBiLi(17));
    _line1.frame         = CGRectMake(lkptBiLi(5),lkptBiLi(50),selfWidth-lkptBiLi(5)*2, 1);
    _image.frame         = CGRectMake(lkptBiLi(18), lkptBiLi(65), lkptBiLi(25), lkptBiLi(25));
    _subTitle.frame      = CGRectMake(lkptBiLi(45), lkptBiLi(66), lkptBiLi(60), lkptBiLi(17));
    _subTitle1.frame     = CGRectMake(lkptBiLi(48), lkptBiLi(111), lkptBiLi(40), lkptBiLi(17));
    _subTitle2.frame     = CGRectMake(lkptBiLi(146), lkptBiLi(111), lkptBiLi(40), lkptBiLi(17));
    _subTitle3.frame     = CGRectMake(lkptBiLi(253), lkptBiLi(111), lkptBiLi(40), lkptBiLi(17));
    
    _sumCount.frame      = CGRectMake(lkptBiLi(49), lkptBiLi(138), lkptBiLi(70), lkptBiLi(16));
    _weekSumCount.frame  = CGRectMake(lkptBiLi(146), lkptBiLi(138), lkptBiLi(70), lkptBiLi(16));
    _monthSunCount.frame = CGRectMake(lkptBiLi(254), lkptBiLi(138), lkptBiLi(70), lkptBiLi(16));
    
    _subTitle1.textAlignment     = NSTextAlignmentCenter;
    _subTitle2.textAlignment     = NSTextAlignmentCenter;
    _subTitle3.textAlignment     = NSTextAlignmentCenter;

    _weekSumCount.textAlignment  = NSTextAlignmentCenter;
    _monthSunCount.textAlignment = NSTextAlignmentCenter;
    _sumCount.textAlignment      = NSTextAlignmentCenter;
    //中心对齐
    [LKTool setView_CenterX:_subTitle1.center.x andView:_sumCount];
    [LKTool setView_CenterX:_subTitle2.center.x andView:_weekSumCount];
    [LKTool setView_CenterX:_subTitle3.center.x andView:_monthSunCount];
   


    _line2.frame         = CGRectMake(0, lkptBiLi(163), selfWidth, 1);
    _image2.frame        = CGRectMake(lkptBiLi(18), lkptBiLi(185), lkptBiLi(25), lkptBiLi(25));
    _wenDuKongZhi.frame  = CGRectMake(lkptBiLi(46), lkptBiLi(185), lkptBiLi(72), lkptBiLi(17));

    _dataSource              = [[NSMutableArray alloc]init];

    _tableView_LK            = [[UITableView alloc]initWithFrame:CGRectMake(lkptBiLi(43), lkptBiLi(228), lkptBiLi(229), 38*_dataSource.count) style:UITableViewStyleGrouped];
    _tableView_LK.delegate   = self;
    _tableView_LK.dataSource = self;
    _tableView_LK.frame      = CGRectMake(lkptBiLi(43), lkptBiLi(228), lkptBiLi(229), 38*_dataSource.count);
    _tableView_LK.backgroundColor = [UIColor yellowColor];
    _tableView_LK.userInteractionEnabled = NO;
    _tableView_LK.separatorColor = [UIColor clearColor];
    [self addSubview:_tableView_LK];

    self.height = [LKTool getBottomY:_tableView_LK]+lkptBiLi(20);
    
    
    //颜色
    _bigTitle.textColor = [LKTool from_16To_Color:@"#595959"];
    _subTitle.textColor = [LKTool from_16To_Color:@"#595959"];
    _line1.backgroundColor = [LKTool from_16To_Color:@"#969393"];
    _subTitle1.textColor   =[LKTool from_16To_Color:@"#595959"];
    _subTitle2.textColor   =[LKTool from_16To_Color:@"#595959"];
    _subTitle3.textColor   =[LKTool from_16To_Color:@"#595959"];
    _sumCount.textColor =[LKTool from_16To_Color:@"#595959"];
    _weekSumCount.textColor =[LKTool from_16To_Color:@"#595959"];
    _monthSunCount.textColor =[LKTool from_16To_Color:@"#595959"];
    _wenDuKongZhi.textColor = [LKTool from_16To_Color:@"#595959"];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *reuseIdentifier = @"reuseIdentifier";
        WenDu_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell =[[[NSBundle mainBundle]loadNibNamed:@"WenDu_TableViewCell" owner:nil options:nil]firstObject];
        }
        HeatModel *model = _dataSource[indexPath.row];
        [cell refreshUI_HeatModel:model];
        return cell;
}
//返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return benFangAnCellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 0.000000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
        return 0.000000001;
}

#pragma mark - 懒加载
-(UITableView *)tableView_LK{
    if (!_tableView_LK) {
        CGFloat selfWidth            = WIDTH_lk  - lkptBiLi(5) * 2;
        CGFloat tableViewWidth       = selfWidth - lkptBiLi(43)* 2;
        _tableView_LK            = [[UITableView alloc]initWithFrame:CGRectMake(lkptBiLi(43), lkptBiLi(228), tableViewWidth, 38) style:UITableViewStyleGrouped];
        _tableView_LK.delegate   = self;
        _tableView_LK.dataSource = self;
        [self addSubview:self.tableView_LK];
    }
    return _tableView_LK;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

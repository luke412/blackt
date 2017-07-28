//
//  JiBu_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/6/13.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  计步界面

#import "JiBu_ViewController.h"
#import <HealthKit/HealthKit.h>
#import "HealthKitManage.h"
#import "HealthModel.h"
#import "UUChart.h"
#import "LKHealthManager.h"

@interface JiBu_ViewController ()<UUChartDataSource>
{
    UUChart *bloodPressureCharView_bushu;
    UUChart *bloodPressureCharView_juli;
    
    NSMutableArray *xValues;
    NSMutableArray *yValues1;
     NSMutableArray *yValues2;
    
    __weak IBOutlet UIImageView *setupCountImage;
    __weak IBOutlet UIImageView *juliImage;
    NSMutableArray *dateList;
    
    //今日步数
    
    __weak IBOutlet UILabel *bushuToDayLabel;
}
@property(nonatomic,strong)NSMutableArray *healthDataList;
@end

@implementation JiBu_ViewController
-(void)layOut{
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTittleWithText:@"计步"];
    LKShow(@"正在获取...");
    _healthDataList = [[NSMutableArray alloc]init];
    dateList = [[NSMutableArray alloc]init];
    //最近7天的日期
    for (NSInteger i=6; i>=0; i--) {
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-1*MEI_TIAN_MIAO_SHU*i];
        [dateList addObject:date];
    }
    [self get7day_dateList:dateList];
    
}
-(void)get7day_dateList:(NSArray *)dateList{
    static NSInteger i = 0;
    if (i>=dateList.count) {
        i = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showData];
        });
        return;
    }
    NSDate *currDate = dateList[i];
    
      dispatch_queue_t queue  = dispatch_get_global_queue(0, 0);
      dispatch_async(queue, ^{
         //获取某天步数
         LKHealthManager *manager = [[LKHealthManager alloc]init];
         __block  HealthModel *model;
          dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
         [manager get1day_nowDate:currDate Success:^(NSArray<HealthModel *> *healthDataList) {
             if (healthDataList.count>=1) {
                 model = healthDataList[0];
                 LKLog(@"%@",model);
                 [_healthDataList addObject:model];
                 i++;
             }
             dispatch_semaphore_signal(semaphore);
         } Failure:^{
             
         }];
         
         dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
         [self get7day_dateList:dateList];
     });
   
}
#pragma mark - 展示数据
-(void)showData{
    NSArray *datasArr = _healthDataList;
     xValues = [[NSMutableArray alloc]init];
     yValues1 = [[NSMutableArray alloc]init];
     yValues2 = [[NSMutableArray alloc]init];
    for (NSInteger i=0; i<datasArr.count; i++) {
        HealthModel *model = datasArr[i];
        NSString *riStr    = [model getRiStr];
        NSString *buShuStr = [NSString stringWithFormat:@"%.0f",model.StepCount];
        NSString *juLiStr  = [NSString stringWithFormat:@"%.0f",model.Distance];
        [xValues  addObject:riStr];
        [yValues1 addObject:buShuStr];
        [yValues2 addObject:juLiStr];
        
        if (i==6) {
            bushuToDayLabel.text = buShuStr;
        }
    }
    
    
    
    
//    xValues                                     = [[NSMutableArray alloc]initWithArray:@[@"5",@"10",@"15",@"20"]]; //日期
//    yValues1                                    = [[NSMutableArray alloc]initWithArray:@[@"4000",@"4700",@"12000"]]; //步数
    bloodPressureCharView_bushu                 = [[UUChart alloc]initWithFrame:CGRectMake(0,40,setupCountImage.frame.size.width,setupCountImage.frame.size.height-50) dataSource:self style:UUChartStyleLine];//折线
    bloodPressureCharView_bushu.tag = 1;
    bloodPressureCharView_bushu.backgroundColor = [UIColor clearColor];
    [bloodPressureCharView_bushu showInView:setupCountImage];
    LKRemove;
}
#pragma mark - 画图相关
//横坐标标题数组
-(NSArray *)chartConfigAxisXLabel:(UUChart *)chart{
    return xValues;
}
//纵坐标辩题数组
-(NSArray *)chartConfigAxisYValue:(UUChart *)chart{
    if (chart.tag == 1) {
        return @[yValues1];
    }else{
        return @[yValues2];
    }
}

//这里返回纵坐标的范围。
-(CGRange)chartRange:(UUChart *)chart
{
    if (chart.tag == 1) {
        return CGRangeMake(20000,0);
    }else{
        return CGRangeMake(20,0);
    }
}

//这里用于设置是否显示最大值最小值。
-(BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index

{
    return NO;
}
//颜色数组

- (NSArray *)chartConfigColors:(UUChart *)chart

{
    return @[[UIColor whiteColor]];
    
}
#pragma mark 折线图专享功能

//标记数值区域
- (CGRange)chartHighlightRangeInLine:(UUChart *)chart
{
//    if (path.row == 2) {
//        return CGRangeMake(25, 75);
//    }
    return CGRangeZero;
}

//判断显示横线条
- (BOOL)chart:(UUChart *)chart showHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//判断显示最大最小值
- (BOOL)chart:(UUChart *)chart showMaxMinAtIndex:(NSInteger)index
{
    return NO;
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

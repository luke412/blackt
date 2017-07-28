//
//  LKNiuView.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/3/29.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "LKNiuView.h"
#import "LKView.h"

@interface LKNiuView ()
@property (weak, nonatomic ) IBOutlet UILabel  *showLabel;
@property (nonatomic,assign) float     cacheWenDu;
/**时间的读秒数 */
@property (nonatomic,assign) NSInteger  timeCount;
@end

@implementation LKNiuView

-(void)awakeFromNib{
    [super awakeFromNib];
    //计时器
    _timeCount                           = 0;
    _showLabel.adjustsFontSizeToFitWidth = YES;
    
}
#pragma mark - 小牛小展板显示
-(void)showTempText:(NSString *)text userState:(UserHeatState)state{
    if (state == Zizhu_heat) {
       self.showLabel.text = text;
    }
    else if (state == WuCaoZuo_heat){
        self.showLabel.text = @"戳我";
    }else if(state == YiJian_heat){
        self.showLabel.text = @"一键理疗";
    }
}
-(void)showStateText:(UserHeatState)state{
    if (state == Zizhu_heat) {
         self.showLabel.text = @"自助调温";
    }
    else if (state == WuCaoZuo_heat){
        self.showLabel.text = @"戳我";
    }else if(state == YiJian_heat){
        self.showLabel.text = @"一键理疗";
    }

}

#pragma mark - 显示弹窗信息
-(void)showInfo_currTemp:(NSInteger)currTemp MuBiaoTemp:(NSInteger)muBiaoTemp HeatState:(UserHeatState)userHeatState{
    NSString *tempStateStr;
    NSString *PlanName;
    NSString *tempStr;
    WinManager *winManager = [WinManager sharedInstance];
    
    if (abs((int)currTemp - (int)muBiaoTemp)<=2) {
        tempStateStr = @"恒温中";
    }else{
        if (currTemp < muBiaoTemp) {
            tempStateStr = @"升温中";
        }else{
            tempStateStr = @"降温中";
        }
    }
    
    //如果当前温度异常就强性过滤
    if (currTemp >59 || currTemp <10) {
        currTemp = 27;
    }
    tempStr = [NSString stringWithFormat:@"%ld℃",currTemp];
    if (userHeatState == Zizhu_heat) {
        PlanName = @"自助调温";
        [winManager showZiZhuCowWindow_TempStr:tempStr tempStateStr:tempStateStr planName:PlanName];
    }
    else if (userHeatState != Zizhu_heat){
        PlanName = @"其他状态";
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  SwitchView.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/5/15.
//  Copyright © 2017年 鲁柯. All rights reserved.
//
#define leftAdd  10

#import "SwitchView.h"
#import "YiJianManager.h"
#import "YiJianPlanModel.h"
@interface SwitchView ()


@end

@implementation SwitchView
-(instancetype)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self layoutUI];
    }
    return self;
}


-(void)layoutUI{
    CGFloat selfWidth = WIDTH_lk;
    CGFloat selfHeight = 82;
    _leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(30+leftAdd, selfHeight/2-15, 30, 30)];
    _leftImage.image = [UIImage imageNamed:@"温度_首页"];
    

    _centerLabel                = [[UILabel alloc]initWithFrame:CGRectMake([LKTool getRightX:_leftImage]+ 10+leftAdd, selfHeight/2-10, 77, 20)];
    _centerLabel.text           = LK(@"连接");

    _kaiGuanBtn                 = [[LKButton alloc]initWithFrame:CGRectMake(selfWidth - 110+leftAdd, selfHeight/2-
                                                             10, 56, 32)];
    _kaiGuanBtn.isOn = NO;
    [self showKaiGuanImage:NO];
    [_kaiGuanBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];

    _bottomLine                 = [[UIView alloc]initWithFrame:CGRectMake(0,81, selfWidth, 1)];
    _bottomLine.backgroundColor = [LKTool from_16To_Color:ZUI_QIAN_HUI];

    [self addSubview:_leftImage];
    [self addSubview:_centerLabel];
    [self addSubview:_kaiGuanBtn];
    [self addSubview:_bottomLine];
    

    //KVO监听开关状态
    [self.kaiGuanBtn addObserver:self forKeyPath:@"isOn" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isOn"]) {
        LKLog(@"%@",change);
        NSString *classStr=[NSString stringWithUTF8String:object_getClassName(change[@"new"])];

        LKLog(@"%@",classStr);
        BOOL isOn  = [change[@"new"] boolValue];
        [self showKaiGuanImage:isOn];
    }
}


-(void)showKaiGuanImage:(BOOL)isOn{
    if (isOn == YES) {
        [self.kaiGuanBtn setImage:[UIImage imageNamed:@"开关开"] forState:UIControlStateNormal];
    }else{
        [self.kaiGuanBtn setImage:[UIImage imageNamed:@"开关关"] forState:UIControlStateNormal];
    }
}

- (void)click:(LKButton *)mykaiGaun{
    if (App_Manager.heatState == YiJian_heat) {
        YiJianPlanModel *currPlanModel = YiJian_Manager.currPlan;
        NSString *name = currPlanModel.schemeName;
        [Win_Manager showTuiChuWindiw_name:name
                                   queDing:^{
                                       [YiJian_Manager end];
                                       App_Manager.heatState = WuCaoZuo_heat;
                                   } quXiao:^{
                                       
                                   }];
        return;
    }
    
    
    self.kaiGuanBtn.isOn = !self.kaiGuanBtn.isOn;
    if (_delegate && [_delegate respondsToSelector:@selector(switchClick:)]) {
        [_delegate switchClick:mykaiGaun];
    }
}

//显示开关为关闭状态
-(void)showKaiGuanClose{
    self.kaiGuanBtn.isOn = NO;
}
//显示开关为开启状态
-(void)showKaiGuanOpen{
    self.kaiGuanBtn.isOn = YES;
}


-(void)dealloc
{
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        //移除所有self监听的所有通知
        [nc removeObserver:self];
    
    @try {
        [self.kaiGuanBtn removeObserver:self forKeyPath:@"isOn" context:nil];
    } @catch (NSException *exception) {
        
    } @finally {
        
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

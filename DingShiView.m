//
//  DingShiView.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/5/15.
//  Copyright © 2017年 鲁柯. All rights reserved.
//
#define leftAdd  10

#import "DingShiView.h"
#import "YiJianPlanModel.h"
#import "YiJianManager.h"

@interface DingShiView ()<UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIImageView *leftImage;
@property (strong, nonatomic) UILabel     *centerLabel;
@property (strong, nonatomic) UILabel     *rightLabel;
@end

@implementation DingShiView
-(instancetype)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
         [self layoutUI];
         self.rightLabel.text = LK(@"00:00:00");
    }
    return self;
}
-(void)layoutUI{
    CGFloat selfWidth = self.frame.size.width;
    CGFloat selfHeight = 82;
    _leftImage                  = [[UIImageView alloc]initWithFrame:CGRectMake(30+leftAdd, selfHeight/2-15, 30, 30)];
    _leftImage.image            = [UIImage imageNamed:LK(@"定时_首页")];

    _centerLabel                = [[UILabel alloc]initWithFrame:CGRectMake([LKTool getRightX:_leftImage]+ 10+leftAdd, selfHeight/2-10, 77, 20)];
    _centerLabel.text           = LK(@"定时");

    _rightLabel                 = [[UILabel alloc]initWithFrame:CGRectMake(selfWidth - 150+leftAdd, selfHeight/2-10, 100, 20)];
    _rightLabel.textAlignment   = NSTextAlignmentRight;
    _rightLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dingShiClick:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];

    _bottomLine                 = [[UIView alloc]initWithFrame:CGRectMake(0,81, selfWidth, 1)];
    _bottomLine.backgroundColor = [LKTool from_16To_Color:ZUI_QIAN_HUI];
    
    [self addSubview:_leftImage];
    [self addSubview:_centerLabel];
    [self addSubview:_rightLabel];
    [self addSubview:_bottomLine];
}
-(void)dingShiClick:(UITapGestureRecognizer *)myTap{
    if (App_Manager.heatState ==  YiJian_heat) {
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
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(dingClick)]) {
        [_delegate dingClick];
    }
}
#pragma mark - set相关
-(void)showRestTime_seconds:(NSInteger)seconds{
    NSInteger hours = seconds / 3600;
    NSInteger mins  = (seconds - hours * 3600) /60;
    NSInteger miaoShu = seconds - hours * 3600 - mins * 60;
    self.rightLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",hours,mins,miaoShu];
    if (seconds >30000) {
        self.rightLabel.text = @"不限时";
    }
}


-(void)dealloc
{
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        //移除所有self监听的所有通知
        [nc removeObserver:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

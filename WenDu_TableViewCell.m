//
//  WenDu_TableViewCell.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/16.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "WenDu_TableViewCell.h"
#import "HeatModel.h"

@interface WenDu_TableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *jieduanLabel;
@property (weak, nonatomic) IBOutlet UILabel *wendu_Label;
@property (weak, nonatomic) IBOutlet UILabel *shijian_Label;

@end
@implementation WenDu_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _jieduanLabel.frame  = CGRectMake(lkptBiLi(20), lkptBiLi(3), lkptBiLi(70), lkptBiLi(12));
    _wendu_Label.frame   = CGRectMake(lkptBiLi(104), lkptBiLi(3), lkptBiLi(50), lkptBiLi(12));
    _shijian_Label.frame = CGRectMake(lkptBiLi(158), lkptBiLi(3), lkptBiLi(50), lkptBiLi(12));
    
    _backView.frame = CGRectMake(self.backView.frame.origin.x,
                                 self.backView.frame.origin.y,
                                 lkptBiLi(235),
                                 25);
    _backView.layer.cornerRadius = self.backView.frame.size.height/2;
    _backView.layer.masksToBounds = YES;
    
    UIView *jianBian = [[UIView alloc]initWithFrame:_backView.bounds];
    //渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors     = @[(__bridge id)[LKTool from_16To_Color:@"#717171"].CGColor, (__bridge id)[UIColor whiteColor].CGColor];
    gradientLayer.locations  = @[@0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint   = CGPointMake(1.0, 0);
    gradientLayer.frame      = _backView.layer.bounds;
    [jianBian.layer addSublayer:gradientLayer];
    
    [_backView  addSubview:jianBian];
    
    [_backView sendSubviewToBack:jianBian];
    
    
    //子控件上下中心对齐
    [LKTool setView_CenterY:_backView.center.y andView:_jieduanLabel];
    [LKTool setView_CenterY:_backView.center.y andView:_wendu_Label];
    [LKTool setView_CenterY:_backView.center.y andView:_shijian_Label];
    
}

-(void)refreshUI_HeatModel:(HeatModel *)heatModel{
    _jieduanLabel.text  = [NSString stringWithFormat:@"第%ld阶段",heatModel.index+1];
    _wendu_Label.text   = [NSString stringWithFormat:@"%ld℃",heatModel.temperatureHigh];
    _shijian_Label.text = [NSString stringWithFormat:@"%ldmin",heatModel.temperatureDuration];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

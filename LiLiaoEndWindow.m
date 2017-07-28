
//
//  LiLiaoEndWindow.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/22.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "LiLiaoEndWindow.h"
@interface LiLiaoEndWindow ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *planNameLabel; //xx方案

@end

@implementation LiLiaoEndWindow
-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    
    self.backgroundColor = [UIColor clearColor];
_backView.layer.cornerRadius = 5;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 
*/
-(void)showPlanName:(NSString *)planName{
    _planNameLabel.text = planName;
}
- (IBAction)queDingClick:(id)sender {
    if (_queDingBlock) {
        _queDingBlock();
    }
}

@end

//
//  MenuView.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/1/18.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView
- (IBAction)duankai:(id)sender{
    if (self.disconnectClickBlock) {
        self.disconnectClickBlock();
    }
}
- (IBAction)xiugaiName:(id)sender {
    if (self.modifyClickBlock) {
        self.modifyClickBlock();
    }
}
-(void)set_disconnectClickBlock:(ClickBlock)block{
    if (block) {
        self.disconnectClickBlock=block;
    }
}
-(void)set_modifyClickBlock:(ClickBlock)block{
    if (block) {
        self.modifyClickBlock=block;
    }

}

//出现动画
-(void)appearAnimation{
      [UIView animateWithDuration:0.5 animations:^{
        self.frame=CGRectMake(WIDTH_lk-120, 64, 110, 130);
    } completion:^(BOOL finished) {
        self.isOpen=YES;
    }];
}
-(void)disappearAnimation{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame=CGRectMake(WIDTH_lk-120, -132, 110, 130);
    } completion:^(BOOL finished) {
      
        [self removeFromSuperview];
        self.isOpen=NO;
    }];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

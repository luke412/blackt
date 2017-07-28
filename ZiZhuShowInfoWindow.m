

//
//  ZiZhuShowInfoWindow.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/5/24.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "ZiZhuShowInfoWindow.h"
@interface ZiZhuShowInfoWindow()
@property (weak, nonatomic) IBOutlet UILabel *heatStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *wenDuValueLabel;

@end
@implementation ZiZhuShowInfoWindow

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)showInfo{
    _heatStateLabel.text = _heatStateStr;
    _wenDuValueLabel.text = _wenDuValueStr;
    int wenDu = [_wenDuValueStr intValue];
    if (wenDu > 59 || wenDu < 0) {
         _wenDuValueLabel.text = @"17℃";
    }
    
}
@end

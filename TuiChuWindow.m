//
//  TuiChuWindow.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/22.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "TuiChuWindow.h"
@interface TuiChuWindow()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *title1;

@end
@implementation TuiChuWindow
-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    _backView.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor clearColor];

}

-(void)showText:(NSString *)planName{
    _title1.text = [NSString stringWithFormat:@"%@理疗在进行中",planName];
    _title1.textAlignment = NSTextAlignmentCenter;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)queDingClick:(id)sender {
    if (_queDingBlock) {
        _queDingBlock();
    }
}
- (IBAction)quXiao:(id)sender {
    if (_quXiao) {
        _quXiao();
    }
}

@end

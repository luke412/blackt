//
//  MapTongYiWindow.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/27.
//  Copyright © 2017年 鲁柯. All rights reserved.
//
#define selfTextColor   @"#595959"
#define qianTextColor  @"#969393"
#import "MapTongYiWindow.h"

@interface MapTongYiWindow ()
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation MapTongYiWindow
-(void)awakeFromNib{
    [super awakeFromNib];
    
    _title1.textColor = [LKTool from_16To_Color:selfTextColor];
    

    [_lookBtn        setTitleColor:[LKTool from_16To_Color:selfTextColor]
                            forState:UIControlStateNormal];
    
    self.layer.cornerRadius      = 5;
    _backView.layer.cornerRadius = 5;
    self.backgroundColor         = [UIColor clearColor];
}


-(void)showText:(NSString *)text{
    _title1.text = [NSString stringWithFormat:@"%@",text];

}
- (IBAction)lookBtnClick:(id)sender {
    if (_lookBlock) {
        _lookBlock();
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

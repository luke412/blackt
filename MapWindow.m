//
//  MapWindow.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/22.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#define selfTextColor   @"#595959"
#define qianTextColor  @"#969393"
#define bi   1.82

#import "MapWindow.h"
@interface MapWindow()
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIButton *zaiXiangXiangBtn;
@property (weak, nonatomic) IBOutlet UIButton *tongYiBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation MapWindow
-(void)awakeFromNib{
    [super awakeFromNib];
    
    _title1.textColor = [LKTool from_16To_Color:selfTextColor];
    
    [_zaiXiangXiangBtn setTitleColor:[LKTool from_16To_Color:qianTextColor]
                            forState:UIControlStateNormal];
    [_tongYiBtn        setTitleColor:[LKTool from_16To_Color:selfTextColor]
                            forState:UIControlStateNormal];
    
    self.layer.cornerRadius      = 5;
    _backView.layer.cornerRadius = 5;
    self.backgroundColor         = [UIColor clearColor];
}
-(void)showText:(NSString *)text{
    
    _title1.text          = [NSString stringWithFormat:@"%@",text];
    _title1.textAlignment = NSTextAlignmentCenter;
}

- (IBAction)zaiXiang:(id)sender {
    if (_zaiXiangBlock) {
        _zaiXiangBlock();
    }
}

- (IBAction)tongYi:(id)sender {
    if (_tongYiBlock) {
        _tongYiBlock();
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

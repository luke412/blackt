//
//  BlueiTiShiView.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/24.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "BlueiTiShiView.h"
@interface BlueiTiShiView ()
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *top1label;
@property (weak, nonatomic) IBOutlet UILabel *top2label;
@property (weak, nonatomic) IBOutlet UILabel *top3label;
@property (weak, nonatomic) IBOutlet LKButton *leftBtn;
@property (weak, nonatomic) IBOutlet LKButton *rightBtn;

@end

@implementation BlueiTiShiView
-(void)awakeFromNib{
    [super awakeFromNib];
    //image
    _leftImage.frame = CGRectMake(0,
                                  lkptBiLi(50),
                                  WIDTH_lk - lkptBiLi(183),
                                  HEIGHT_lk-lkptBiLi(50) - lkptBiLi(101));

    //top1
    _top1label.frame = LKMakeRect_Font_Text_Frame(17, @"我们需要您打开", lkptBiLi(158), lkptBiLi(77),  WIDTH_lk -lkptBiLi(158), 0);
    _top1label.textColor = [LKTool from_16To_Color:@"#2b2a2a"];
    _top1label.text      = @"我们需要您打开";
    
    //top2

   _top2label.frame = LKMakeRect_Font_Text_Frame(20, @"蓝牙", lkptBiLi(158),  [LKTool getBottomY:_top1label]+5,  WIDTH_lk -lkptBiLi(158), 0);
    
    _top2label.text  = @"蓝牙";
    _top2label.textColor = [LKTool from_16To_Color:@"#2b2a2a"];

    
    
    //top3
    
  _top3label.frame =  LKMakeRect_Font_Text_Frame(15,  @"打开蓝牙，可以使设备和手机数据传输", lkptBiLi(158),  lkptBiLi(173),  WIDTH_lk -lkptBiLi(158), 0);
    _top3label.text = @"打开蓝牙，可以使设备和手机数据传输";
    _top3label.numberOfLines = 2;
    _top3label.textColor = [LKTool from_16To_Color:@"#969393"];

    
    
    
    //leftBtn
    _leftBtn.frame = CGRectMake(0,
                                HEIGHT_lk - lkptBiLi(50),
                                WIDTH_lk/2,
                                lkptBiLi(50));
    _leftBtn.backgroundColor = [LKTool from_16To_Color:@"#d6d6d6"];
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //rightBtn
    _rightBtn.frame = CGRectMake(WIDTH_lk/2,
                                HEIGHT_lk - lkptBiLi(50),
                                WIDTH_lk/2,
                                lkptBiLi(50));
    _rightBtn.backgroundColor = [LKTool from_16To_Color:@"#2b2a2a"];
    [_rightBtn setTitleColor:[UIColor whiteColor]
                    forState:UIControlStateNormal];
    
    _leftBtn.tag = 1;
    _rightBtn.tag = 2;
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

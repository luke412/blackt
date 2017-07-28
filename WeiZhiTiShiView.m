//
//  WeiZhiTiShiView.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/24.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "WeiZhiTiShiView.h"
@interface WeiZhiTiShiView()
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *top1label;
@property (weak, nonatomic) IBOutlet UILabel *top2label;
@property (weak, nonatomic) IBOutlet UILabel *top3label;
@property (weak, nonatomic) IBOutlet LKButton *leftBtn;
@property (weak, nonatomic) IBOutlet LKButton *rightBtn;

@end

@implementation WeiZhiTiShiView
-(void)awakeFromNib{
    [super awakeFromNib];
    //image
    _leftImage.frame = CGRectMake(0,
                                  lkptBiLi(50),
                                  WIDTH_lk - lkptBiLi(183),
                                  HEIGHT_lk-lkptBiLi(50) - lkptBiLi(101));
    
    //top1
    _top1label.frame =CGRectMake(lkptBiLi(158),
                                 lkptBiLi(77),
                                 WIDTH_lk -lkptBiLi(158),
                                 lkptBiLi(56));
    _top1label.textColor = [LKTool from_16To_Color:@"#2b2a2a"];
    _top1label.text      = @"我们需要您“始终”允许";
    _top1label.numberOfLines = 2;
    
    
    //top2

    _top2label.frame = LKMakeRect_Font_Text_Frame(20, @"位置信息", lkptBiLi(158), [LKTool getBottomY:_top1label]+5,  WIDTH_lk -lkptBiLi(158), 0);
    _top2label.text  = @"位置信息";
    _top2label.textColor = [LKTool from_16To_Color:@"#2b2a2a"];
    
    
    
    //top3
    _top3label.frame = CGRectMake(lkptBiLi(158),
                                  lkptBiLi(173),
                                  WIDTH_lk -lkptBiLi(158),
                                  200);
    _top3label.text = @"1.保持设备和手机持续连接不中断 \n\n 2.可以与好友互看地理位置";
    _top3label.frame = LKMakeRect_Font_Text_Frame(15, @"1.保持设备和手机持续连接不中断 \n\n 2.可以与好友互看地理位置",
                                                  lkptBiLi(158),
                                                  lkptBiLi(173),
                                                  WIDTH_lk -lkptBiLi(158),
                                                  0);
    _top3label.numberOfLines = 8;
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

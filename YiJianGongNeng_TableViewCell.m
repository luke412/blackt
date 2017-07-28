//
//  YiJianGongNeng_TableViewCell.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/17.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "YiJianGongNeng_TableViewCell.h"
@interface YiJianGongNeng_TableViewCell()
@property(nonatomic,strong)UIImageView *ingImage;

@end
@implementation YiJianGongNeng_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _image.frame       = CGRectMake(lkptBiLi(10), 10, WIDTH_lk - lkptBiLi(10)*2, lkptBiLi(76));
    _image.contentMode = UIViewContentModeScaleAspectFill;
    _image.layer.cornerRadius = 5;
    _image.layer.masksToBounds = YES;
    
    _name.textAlignment   = NSTextAlignmentRight;
    _name.textColor = [UIColor whiteColor];
    _renshu.textAlignment = NSTextAlignmentRight;
    _renshu.font          = [UIFont systemFontOfSize:15];
    _renshu.textColor     = [UIColor whiteColor];
    
    _name.frame   = CGRectMake(WIDTH_lk - lkptBiLi(71) - 100 , lkptBiLi(32)+10, 100, lkptBiLi(20));
    _renshu.frame = CGRectMake(WIDTH_lk - lkptBiLi(14) - 180, lkptBiLi(58)+5, 170, lkptBiLi(20));
    _renshu.textAlignment = NSTextAlignmentRight;
}

/**显示在正在运行的样子*/
-(void)showRuningFace{
    if (!_ingImage) {
        CGFloat imageWidth  = lkptBiLi(26);
        CGFloat imageHeight = lkptBiLi(26);
        CGFloat backImageWidth   = self.image.frame.size.width;
        _ingImage = [[UIImageView alloc]initWithFrame:CGRectMake(backImageWidth - imageWidth - 2,
                                                                 2,
                                                                 imageWidth,
                                                                 imageHeight)];
        
        _ingImage.image = [UIImage imageNamed:@"ing"];
        [self.image addSubview:_ingImage];
    }
    self.ingImage.hidden = NO;
    
}

/**显示没有使用的样子*/
-(void)showStopFace{
    self.ingImage.hidden = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

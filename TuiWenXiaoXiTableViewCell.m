//
//  TuiWenXiaoXiTableViewCell.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/6/28.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  推文消息cell  

#import "TuiWenXiaoXiTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MessageModel.h"

@interface TuiWenXiaoXiTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *backView;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *centerImage;
@property (weak, nonatomic) IBOutlet UILabel *neiRongLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


//分割线
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *yueDuLabel;




@end;
@implementation TuiWenXiaoXiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleLabel.text = @"推送消息";
    _neiRongLabel.text = self.messgModel.descriptionKey;
    _dateLabel.text    = self.messgModel.createTimeKey;
    [_centerImage sd_setImageWithURL:[NSURL URLWithString:self.messgModel.introPicKey] placeholderImage:[UIImage imageNamed:@"推文图片占位"]];
    
    [self UIlayOut];
}
-(void)UIlayOut{
    //控件在BackView上的左边距
    CGFloat topMargin  = 20;
    CGFloat backLeftMargin = 20;
    
    CGFloat leftMargin = 22;
    CGFloat uuupMargin = 15;
    CGFloat myWith = WIDTH_lk-backLeftMargin*2;
    CGFloat myHeight = 230;
    _backView.frame = CGRectMake(backLeftMargin, topMargin, WIDTH_lk-backLeftMargin*2, myHeight);
    _titleLabel.frame = CGRectMake(leftMargin,uuupMargin,70, 21);
    _centerImage.frame = CGRectMake(leftMargin,[LKTool getBottomY:_titleLabel]+uuupMargin, WIDTH_lk-leftMargin*2, 165);
    _neiRongLabel.frame = CGRectMake(leftMargin, [LKTool getBottomY:_centerImage]+uuupMargin,  WIDTH_lk-10*2, 40);
    _line.frame = CGRectMake(0, [LKTool getBottomY:_neiRongLabel]+uuupMargin, myWith, 1);
    _yueDuLabel.frame = CGRectMake(leftMargin, [LKTool getBottomY:_neiRongLabel]+uuupMargin, 70, 21);
    _dateLabel.frame  = CGRectMake(myWith-70-leftMargin,  [LKTool getBottomY:_line]+uuupMargin, 70, 21);
    
    
    //重新写高度
    _backView.frame = CGRectMake(backLeftMargin, topMargin, WIDTH_lk-backLeftMargin*2, 6*uuupMargin +
                                 _titleLabel.frame.size.height+
                                 _centerImage.frame.size.height+
                                 _neiRongLabel.frame.size.height+
                                 _yueDuLabel.frame.size.height);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

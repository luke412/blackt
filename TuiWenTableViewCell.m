//
//  TuiWenTableViewCell.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/6/29.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "TuiWenTableViewCell.h"
#import "MessageModel.h"
#import "UIImageView+WebCache.h"
@interface TuiWenTableViewCell ()
@property (nonatomic,strong)  UIView *backView;
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UIImageView *centerImage;
@property (strong, nonatomic)  UILabel *neiRongLabel;
@property (strong, nonatomic)  UILabel *dateLabel;


//分割线
@property (strong, nonatomic)  UIView *line;
@property (strong, nonatomic)  UILabel *yueDuLabel;




@end;
@implementation TuiWenTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        if (self) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_backView];
        
        _titleLabel = [[UILabel alloc]init];
        [self.backView addSubview:_titleLabel];
        _centerImage = [[UIImageView alloc]init];
        [self.backView addSubview:_centerImage];

        _neiRongLabel = [[UILabel alloc] init];
        [self.backView addSubview:_neiRongLabel];

        _dateLabel = [[UILabel alloc]init];
        [self.backView addSubview:_dateLabel];

        _line = [[UIView alloc]init];
        [self.backView addSubview:_line];

        _yueDuLabel = [[UILabel alloc]init];
        [self.backView addSubview:_yueDuLabel];

            
    }
     [self UIlayOut];
     return self;
}
-(void)loadData{
    _titleLabel.text   = self.messgModel.headlineKey;
    _neiRongLabel.text = self.messgModel.descriptionKey;
    _dateLabel.text    = self.messgModel.createTimeKey;
    [_centerImage sd_setImageWithURL:[NSURL URLWithString:self.messgModel.introPicKey] placeholderImage:[UIImage imageNamed:@"推文图片占位"]];
    _yueDuLabel.text = @"阅读全文";
    if (_dateLabel.text.length > 10) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
          [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
          NSDate *date =[dateFormat dateFromString:_dateLabel.text];
        
        NSDateFormatter* dateFormat2 = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat2 setDateFormat:@"MM-dd HH:mm"];//设定时间格式,这里可以设置成自己需要的格式
        NSString *currentDateStr = [dateFormat2 stringFromDate:date];
        _dateLabel.text = currentDateStr;
    }

}

-(void)UIlayOut{
    //控件在BackView上的左边距
    CGFloat topMargin  = 20;
    CGFloat backLeftMargin = 20;
    CGFloat backWidth = WIDTH_lk-backLeftMargin*2;
    
    CGFloat leftMargin = 22;
    CGFloat uuupMargin = 15;
    CGFloat myWith = WIDTH_lk-backLeftMargin*2;
    CGFloat myHeight = 230;
    
    
    _backView.frame = CGRectMake(backLeftMargin, topMargin,backWidth , myHeight);
    _backView.layer.cornerRadius = 8;
    
    _titleLabel.frame = CGRectMake(leftMargin,uuupMargin, WIDTH_lk-leftMargin*2-20, 21);
    
    _centerImage.frame = CGRectMake(leftMargin,[LKTool getBottomY:_titleLabel]+uuupMargin, backWidth -2*leftMargin, 165);
    _centerImage.layer.masksToBounds =YES;
    _centerImage.layer.cornerRadius =8;
    
    _neiRongLabel.frame = CGRectMake(leftMargin, [LKTool getBottomY:_centerImage]+uuupMargin,  WIDTH_lk-leftMargin*2-20, 40);
    
    _line.frame = CGRectMake(0, [LKTool getBottomY:_neiRongLabel]+uuupMargin, myWith, 1);
    
    _yueDuLabel.frame = CGRectMake(leftMargin, [LKTool getBottomY:_line]+uuupMargin, 70, 21);
    
    _dateLabel.frame  = CGRectMake(myWith-140-leftMargin,  [LKTool getBottomY:_line]+uuupMargin, 140, 21);
    _dateLabel.textAlignment = NSTextAlignmentRight;
    
    //重新写高度
    _backView.frame = CGRectMake(backLeftMargin, topMargin, WIDTH_lk-backLeftMargin*2, 6*uuupMargin +
                                 _titleLabel.frame.size.height+
                                 _centerImage.frame.size.height+
                                 _neiRongLabel.frame.size.height+
                                 _yueDuLabel.frame.size.height);
    
    
    //颜色
    _titleLabel.textColor = [LKTool from_16To_Color:ZUI_SHEN_HUI];
    _neiRongLabel.textColor =  [LKTool from_16To_Color:CI_SHEN_HUI];
    _yueDuLabel.textColor =  [LKTool from_16To_Color:CI_SHEN_HUI];
    _dateLabel.textColor  =  [LKTool from_16To_Color:CI_SHEN_HUI];
    
    _line.backgroundColor = [LKTool from_16To_Color:ZUI_QIAN_HUI];
    _myCellHeight = _backView.frame.size.height + 2*topMargin;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

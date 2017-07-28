//
//  MessageTableViewCell.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/6/29.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "MessageModel.h"
@interface MessageTableViewCell ()
@property (nonatomic,strong)  UIView *backView;
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UILabel *neiRongLabel;
@property (strong, nonatomic)  UILabel *dateLabel;



@end

@implementation MessageTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        if (self) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_backView];
        
        _titleLabel = [[UILabel alloc]init];
        [self.backView addSubview:_titleLabel];
        
        _neiRongLabel = [[UILabel alloc] init];
        [self.backView addSubview:_neiRongLabel];
        
        _dateLabel = [[UILabel alloc]init];
        [self.backView addSubview:_dateLabel];
    
    }
    [self UIlayOut];
     return self;
}
-(void)loadData{
    _titleLabel.text   = @"通知";
    _neiRongLabel.text = self.messageModel.text;
    _dateLabel.text    = self.messageModel.createTimeKey;
    
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
    
    _neiRongLabel.frame = CGRectMake(leftMargin, [LKTool getBottomY:_titleLabel]+uuupMargin,   WIDTH_lk-leftMargin*2-20, 40);
    
    _dateLabel.frame  = CGRectMake(myWith-140-leftMargin,  [LKTool getBottomY:_neiRongLabel]+uuupMargin, 140, 21);
    _dateLabel.textAlignment = NSTextAlignmentRight;
    
    //重新写高度
    _backView.frame = CGRectMake(backLeftMargin, topMargin, WIDTH_lk-backLeftMargin*2, 4*uuupMargin +
                                 _titleLabel.frame.size.height+
                                 _neiRongLabel.frame.size.height+
                                 _dateLabel.frame.size.height);
    
    
    //颜色
    _titleLabel.textColor = [LKTool from_16To_Color:ZUI_SHEN_HUI];
    _neiRongLabel.textColor =  [LKTool from_16To_Color:CI_SHEN_HUI];
    _dateLabel.textColor  =  [LKTool from_16To_Color:CI_SHEN_HUI];
    
    _myCellHeight = _backView.frame.size.height + 2*topMargin;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

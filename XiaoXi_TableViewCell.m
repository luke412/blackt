//
//  XiaoXi_TableViewCell.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/5/13.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "XiaoXi_TableViewCell.h"
#import "MessageModel.h"
#import "DataBaseManager.h"

@interface XiaoXi_TableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *isReadView;
@property (weak, nonatomic) IBOutlet UIView *fenLeiColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *date_Label;
@end

@implementation XiaoXi_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _isReadView.hidden                    = YES;
    NSNotificationCenter *nc              = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(RefreshXiaoXi:) name:@"RefreshXiaoXi" object:nil];
    _isReadView.layer.masksToBounds       = YES;
    _isReadView.layer.cornerRadius        = _isReadView.frame.size.width/2;

    _fenLeiColorLabel.layer.masksToBounds = NO;
    _fenLeiColorLabel.layer.cornerRadius  = _fenLeiColorLabel.frame.size.width/2;
}
-(void)refreshUI{
    [self RefreshXiaoXi:nil];
}
-(void)RefreshXiaoXi:(NSNotification *)notify
{
    NSArray <MessageModel *>* messageArray = [DataBase_Manager loadAllMessage];
    //统计未读信息数目
    for (MessageModel *message in messageArray) {
        if ([message.idStr isEqualToString:_cellMessage.idStr]) {
            if ([message.isRead isEqualToString: @"NO"]) {
                _isReadView.hidden = NO;
            }else {
                _isReadView.hidden = YES;
            }

        }
    }
}
-(void)setCellMessage:(MessageModel *)cellMessage{
    _cellMessage = cellMessage;
    self.date_Label.text  = cellMessage.timeStr;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc
{
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        //移除所有self监听的所有通知
        [nc removeObserver:self];
}
@end

//
//  AddFriend_TableViewCell.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/18.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  添加好友cell

#import "AddFriend_TableViewCell.h"
#import "FriendModel.h"

@interface AddFriend_TableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end


@implementation AddFriend_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _addBtn.layer.cornerRadius = 5;
    
}

//添加好友点击
- (IBAction)addClick:(id)sender {
    if (_myCellBlock) {
        _myCellBlock(_currFriendModel);
    }
}

-(void)setCurrFriendModel:(FriendModel *)currFriendModel{
    _currFriendModel = currFriendModel;
    _nameLabel.text  = _currFriendModel.userNickname;
    
    if (_nameLabel.text.length<1) {
        _nameLabel.text = currFriendModel.phoneNum;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

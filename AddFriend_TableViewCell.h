//
//  AddFriend_TableViewCell.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/18.
//  Copyright © 2017年 鲁柯. All rights reserved.
//
@class FriendModel;

typedef  void(^CellClick)(FriendModel *firendModel);

#import <UIKit/UIKit.h>
@interface AddFriend_TableViewCell : UITableViewCell
@property(nonatomic,strong)FriendModel *currFriendModel;

@property(nonatomic,copy)CellClick myCellBlock;
@end

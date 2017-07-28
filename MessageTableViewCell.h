//
//  MessageTableViewCell.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/6/29.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property(nonatomic,strong)MessageModel *messageModel;
@property(nonatomic,assign)CGFloat myCellHeight;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)loadData;
@end

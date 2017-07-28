//
//  XiaoXi_TableViewCell.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/5/13.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageModel;
@interface XiaoXi_TableViewCell : UITableViewCell
@property (nonatomic,strong)MessageModel *cellMessage;
@property (weak, nonatomic) IBOutlet UILabel *title_label;
//刷新UI
-(void)refreshUI;
@end

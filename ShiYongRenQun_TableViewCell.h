//
//  ShiYongRenQun_TableViewCell.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/16.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShiYongRenModel;
@interface ShiYongRenQun_TableViewCell : UITableViewCell
-(void)refreshUI_ShiYongRenModel:(ShiYongRenModel *)model;
@end

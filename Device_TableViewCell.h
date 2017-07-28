//
//  Device_TableViewCell.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/4/6.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^delBtnClickBlock)();
@interface Device_TableViewCell : UITableViewCell
@property(nonatomic,copy)NSString *deviceStyle;
@property(nonatomic,copy)NSString *deviceName;
@property(nonatomic,copy)NSString *deviceMac;

@property(nonatomic,copy)delBtnClickBlock delBlock;
@property(nonatomic,assign,readonly)BOOL isOpenEditState;
-(void)openEditState;
-(void)closeEditState;
@end

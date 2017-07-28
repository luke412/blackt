//
//  QieHuanSheBei_TableViewCell.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/4/7.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^clickBlock)();

@interface QieHuanSheBei_TableViewCell : UITableViewCell
@property(nonatomic,copy)NSString *deviceStyle;
@property(nonatomic,copy)NSString *deviceName;
@property(nonatomic,copy)NSString *deviceMac;

@property(nonatomic,copy)clickBlock myClickBlock;
@end

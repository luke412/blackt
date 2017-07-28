//
//  YiJianGongNeng_TableViewCell.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/17.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YiJianGongNeng_TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *renshu;


/**显示在正在运行的样子*/
-(void)showRuningFace;

/**显示没有使用的样子*/
-(void)showStopFace;
@end

//
//  ShiHeRenQunView.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/14.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YiJianPlanModel;


@interface ShiHeRenQunView : UIView
@property(nonatomic,assign)CGFloat height;
/** 刷新视图 */
-(void)refreshUI_Model:(YiJianPlanModel *)planModel;
@end

//
//  YiJianManager.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/16.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "DOSingleton.h"
@class  YiJianPlanModel;
@class  YiJianPlanXiangQing_ViewController;

@protocol  YiJianManagertDelegate <NSObject>

@required
-(void)refreshEveryTime:(NSInteger)restSeconds sumSecond:(NSInteger)sumSecond;
-(void)startRun:(NSInteger)restSeconds; //剩余时间
-(void)end;
-(void)finish;
@end


@interface YiJianManager : DOSingleton
@property(nonatomic,weak) id <YiJianManagertDelegate> delegate;
@property(nonatomic,strong)YiJianPlanModel *currPlan;

-(void)planRun_Model:(YiJianPlanModel *)model;
-(void)finish;
-(void)end;


@end
